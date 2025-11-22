import 'dart:convert';
import 'dart:io';
import "package:crypto/crypto.dart";
import 'package:daily_info/core/constants/all_enums.dart';
import 'package:daily_info/core/extensions/ex_date_time.dart';
import 'package:daily_info/core/functions/f_genarate_randome_data.dart';
import 'package:daily_info/core/functions/f_is_null.dart';
import 'package:daily_info/core/functions/f_printer.dart';
import 'package:daily_info/core/services/encryption_service.dart';
import 'package:daily_info/core/services/flutter_secure_service.dart';
import 'package:daily_info/features/task/data/model/m_query.dart';
import 'package:daily_info/features/task/data/model/m_task.dart';
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
  Future<bool> addNote(MTask payload) async {
    Map data = Map.from(payload.toMap());
    data.remove(id);
    String genaratedHash = _generateHash(payload.title ?? "", payload.details ?? "");
    var db = await getDB();
    int effectedRow = await db.insert(tableName, {
      ...data,
      hash: genaratedHash, // For integrity verification
    });
    printer(effectedRow);
    return effectedRow > 0;
  }

  // 🔍 Fetch all tasks with integrity verification
  Future<List<MTask>> fetchTask(MQuery payload) async {
    var db = await getDB();
    printer(payload.filter);
    printer("page no ${payload.pageNo}");

    List<Map<String, dynamic>> list = await db.query(
      tableName, // Your table name
      orderBy: '$id DESC', // Essential for consistent ordering
      limit: payload.limit,
      // where: payload.filter,
      // whereArgs: [
      //   payload.isLoadNext ?? false

      //       ? "${payload.lastEid}"
      //       : "${payload.firstEid}",
      // ],
      // where: '$taskId = ? AND $taskTitle = ?',
      // whereArgs: [1, "abcd"],
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
    await Future.delayed(Duration(seconds: 4));
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
        .map(
          (Map map) => MTask(
            id: map["id"],
            title: map["title"],
            createdAt: isNotNull(map["createdAt"])
                ? DateTime.parse(map["createdAt"])
                : null,
            finishedAt: isNotNull(map["finishedAt"])
                ? DateTime.parse(map["finishedAt"])
                : null,
          ),
        )
        .toList();
    // return verifiedData;
  }

  // 🔄 Update with new hash
  Future<bool> updateNote({required MTask payload}) async {
    var db = await getDB();
    String genaratedHash = _generateHash(title, details);

    int effectedRow = await db.update(
      tableName,
      {
        title: payload.title,
        points: payload.points,
        details: payload.details,
        // createdAt: payload.createdAt,
        updatedAt: payload.updatedAt,
        endAt: payload.endAt,
        finishedAt: payload.finishedAt,
        hash: genaratedHash,
      },
      where: "$id = ?, ",
      whereArgs: [payload.id],
    );

    return effectedRow > 0;
  }

  // 🗑️ Delete task
  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int effectedRow = await db.delete(
      tableName,
      where: "$id = ?",
      whereArgs: [id],
    );
    return effectedRow > 0;
  }

  // 🔒 Close database
  Future<void> closeDB() async {
    if (myDB != null) {
      await myDB!.close();
      myDB = null;
    }
  }
}
