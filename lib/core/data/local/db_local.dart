import 'dart:convert';
import 'dart:io';
import "package:crypto/crypto.dart";
import 'package:secure_note/core/constants/all_enums.dart';
import 'package:secure_note/core/extensions/ex_date_time.dart';
import 'package:secure_note/core/functions/f_genarate_randome_data.dart';
import 'package:secure_note/core/functions/f_is_null.dart';
import 'package:secure_note/core/functions/f_printer.dart';
import 'package:secure_note/core/services/encryption_service.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:secure_note/features/task/data/model/m_query.dart';
import 'package:secure_note/features/task/data/model/m_task.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DBHelper {
  DBHelper._();
  String? encryptionKey;
  static final DBHelper getInstance = DBHelper._();

  Database? myDB;
  static final tableName = "task";
  static final id = "id";
  static final title = "title";
  static final points = "points";
  static final details = "details";
  static final endAt = "endAt";
  static final createdAt = "createdAt";
  static final updatedAt = "updatedAt"; // For integrity verification
  static final finishedAt = "finishedAt"; // For integrity verification
  static final hash = "hash"; // For integrity verification

  Future<void> init() async {
    await _setEncryptionKey();
  }

  // 🔑 Generate encryption password (use secure storage in production)
  Future<void> _setEncryptionKey() async {
    String? key = await FSSService().getString('dbKey');
    //decrypt db key

    if (key == null) {
      key = generateRandomData(16).toString(); // Generate random key
      // encrypt. db key
      key = EncryptionService().encrypt(key);
      await FSSService().setString('dbKey', key);
    }
    encryptionKey = EncryptionService().decrypt(key);
  }

  /// default return string

  // 📊 Generate hash for data integrity
  String _generateHash(String title, String details) {
    final data = "$title|$details";
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // 🔓 Open encrypted database
  Future<Database> getDB() async {
    myDB ??= await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "taskDB_encrypted.db");

    return await openDatabase(
      dbPath,
      password: encryptionKey, // 🔐 Encryption password
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $tableName ("
          "$id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$title TEXT, "
          "$points TEXT, "
          "$details TEXT, "
          "$endAt DATETIME DEFAULT NULL, "
          "$createdAt DATETIME DEFAULT CURRENT_DATETIME NOT NULL, "
          "$updatedAt DATETIME DEFAULT NULL, "
          "$finishedAt DATETIME DEFAULT NULL, "
          "$hash TEXT "
          ");",
        );
      },
      version: 1,
    );
  }

  // ✅ Insert with integrity hash
  Future<MTask> addNote(MTask payload) async {
    Map data = Map.from(payload.toMap());
    data.remove(id);
    String genaratedHash = _generateHash(
      payload.title ?? "",
      payload.details ?? "",
    );
    var db = await getDB();
    int effectedRow = await db.insert(tableName, {
      ...data,
      hash: genaratedHash, // For integrity verification
    });
    if (effectedRow > 0) {
      List<MTask> list = await fetchTask(
        MQuery(where: "$hash IS ? ", args: [genaratedHash]),
      );
      return list.first;
    } else {
      throw "Addition failed";
    }
  }

  // 🔍 Fetch all tasks with integrity verification
  Future<List<MTask>> fetchTask(MQuery payload) async {
    var db = await getDB();
    printer(payload.where);
    printer("page no ${payload.pageNo}");

    List<Map<String, dynamic>> list = await db.query(
      tableName, // Your table name
      orderBy: '$id DESC', // Essential for consistent ordering
      limit: payload.limit,
      where: payload.where,
      whereArgs: payload.args,
      offset: ((payload.pageNo ?? 0) - 1) * (payload.limit ?? 0),
    );

    printer(list);

    // Verify data integrity
    List<Map<String, dynamic>> verifiedData = [];
    for (var task in list) {
      String storedHash = task[hash] ?? '';
      String calculatedHash = _generateHash(
        task[title] ?? '',
        task[details] ?? '',
      );
      if (storedHash == calculatedHash) {
        verifiedData.add(task);
      } else {
        print("⚠️ Data integrity compromised for task #${task[id]}");
        // You can handle tampered data here (delete, flag, etc.)
      }
    }
    // await Future.delayed(Duration(seconds: 2));
    // return List.generate(
    //   payload.limit ?? 0,
    //   (index) => MTask(
    //     id: int.parse(DateTime.timestamp().timestamp),
    //     title:
    //         "${int.parse(DateTime.timestamp().timestamp) % 100000000} ${payload.taskState == TaskState.pending
    //             ? "Pending"
    //             : payload.taskState == TaskState.timeOut
    //             ? "timeout"
    //             : "completed"}",
    //   ),
    // );
    printer("fetched ${list.length}");
    printer("verifyed ${verifiedData.length}");
    return verifiedData
        .map((Map<String, dynamic> map) => MTask.fromMap(map))
        .toList();
    // return verifiedData;
  }

  // 🔄 Update with new hash
  Future<MTask> updateNote({required MTask payload}) async {
    Map data = Map.from(payload.toMap());
    data.remove(id);
    data.remove(createdAt);
    printer("update called");
    var db = await getDB();
    String genaratedHash = _generateHash(
      payload.title ?? "",
      payload.details ?? "",
    );

    int effectedRow = await db.update(
      tableName,
      {...data, hash: genaratedHash},
      where: "${DBHelper.id} = ? ",
      whereArgs: [payload.id],
    );

    if (effectedRow > 0) {
      printer("Updated success");
      List<MTask> list = await fetchTask(
        MQuery(where: "${DBHelper.id} IS ? ", args: [payload.id]),
      );
      return list.first;
    } else {
      throw "Updation failed";
    }
  }

  // 🗑️ Delete task
  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int effectedRow = await db.delete(
      tableName,
      where: "${DBHelper.id} = ?",
      whereArgs: [id],
    );
    printer(effectedRow);
    return effectedRow > 0;
  }

  // 🔒 Close database
  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }

  Future<void> clear() async {
    Database db = await getDB();
    try {
      //Note: remove all of thing without secret valut data or related data.
      await db.delete(tableName);
      await FSSService().delete('dbKey');
      await FSSService().delete("eSkey");
      await FSSService().delete("eSIV");
    } catch (e) {
      rethrow;
    }
  }
}
