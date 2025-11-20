// import 'dart:convert';
// import 'dart:io';
// import 'package:crypto/crypto.dart';
// import 'package:note/core/function/f_genarate_randome_data.dart';
// import 'package:note/core/services/encryption_service.dart';
// import 'package:note/core/services/flutter_secure_service.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite_sqlcipher/sqflite.dart';

// class DBHelper {
//   DBHelper._();
//   String? encryptionKey;
//   static final DBHelper getInstance = DBHelper._();

//   Database? myDB;
//   static final tableName = "note";
//   static final noteTitle = "title";
//   static final noteDesc = "desc";
//   static final noteNo = "ls_no";
//   static final noteTime = "entry_time";
//   static final noteHash = "data_hash"; // For integrity verification

//   void init() {
//     _setEncryptionKey();
//   }

//   // 🔑 Generate encryption password (use secure storage in production)
//   void _setEncryptionKey() async {
//     String? key = await FSSService().getString('dbKey');
//     //decrypt db key

//     if (key == null) {
//       key = generateRandomData(16).toString(); // Generate random key
//       // encrypt. db key
//       key = EncryptionService().encrypt(key);
//       await FSSService().setString('dbKey', key);
//     }
//     encryptionKey = EncryptionService().decrypt(key);
//   }

//   /// default return string

//   // 📊 Generate hash for data integrity
//   String _generateHash(String title, String desc) {
//     final data = "$title|$desc";
//     final bytes = utf8.encode(data);
//     final hash = sha256.convert(bytes);
//     return hash.toString();
//   }

//   // 🔓 Open encrypted database
//   Future<Database> getDB() async {
//     myDB ??= await openDB();
//     return myDB!;
//   }

//   Future<Database> openDB() async {
//     Directory appDir = await getApplicationDocumentsDirectory();
//     String dbPath = join(appDir.path, "noteDB_encrypted.db");

//     return await openDatabase(
//       dbPath,
//       password: encryptionKey, // 🔐 Encryption password
//       onCreate: (db, version) {
//         db.execute("CREATE TABLE $tableName ("
//             "$noteNo INTEGER PRIMARY KEY AUTOINCREMENT, "
//             "$noteTitle TEXT, "
//             "$noteDesc TEXT, "
//             "$noteHash TEXT, " // Hash for integrity check
//             "$noteTime TEXT DEFAULT CURRENT_TIMESTAMP"
//             ");");
//       },
//       version: 1,
//     );
//   }

//   // ✅ Insert with integrity hash
//   Future<bool> addNote({required String title, required String desc}) async {
//     var db = await getDB();
//     String hash = _generateHash(title, desc);

//     int effectedRow = await db.insert(
//       tableName,
//       {
//         noteTitle: title,
//         noteDesc: desc,
//         noteHash: hash,
//       },
//     );

//     return effectedRow > 0;
//   }

//   // 🔍 Fetch all notes with integrity verification
//   Future<List<Map<String, dynamic>>> getAllNote() async {
//     var db = await getDB();
//     List<Map<String, dynamic>> allData = await db.query(tableName);

//     // Verify data integrity
//     List<Map<String, dynamic>> verifiedData = [];
//     for (var note in allData) {
//       String storedHash = note[noteHash] ?? '';
//       String calculatedHash = _generateHash(
//         note[noteTitle] ?? '',
//         note[noteDesc] ?? '',
//       );

//       if (storedHash == calculatedHash) {
//         verifiedData.add(note);
//       } else {
//         print("⚠️ Data integrity compromised for note #${note[noteNo]}");
//         // You can handle tampered data here (delete, flag, etc.)
//       }
//     }

//     return verifiedData;
//   }

//   // 🔄 Update with new hash
//   Future<bool> updateNote({
//     required String title,
//     required String desc,
//     required int slNo,
//   }) async {
//     var db = await getDB();
//     String hash = _generateHash(title, desc);

//     int effectedRow = await db.update(
//       tableName,
//       {
//         noteTitle: title,
//         noteDesc: desc,
//         noteHash: hash,
//       },
//       where: "$noteNo = ?",
//       whereArgs: [slNo],
//     );

//     return effectedRow > 0;
//   }

//   // 🗑️ Delete note
//   Future<bool> deleteNote({required int slNo}) async {
//     var db = await getDB();

//     int effectedRow = await db.delete(
//       tableName,
//       where: "$noteNo = ?",
//       whereArgs: [slNo],
//     );

//     return effectedRow > 0;
//   }

//   // 🔒 Close database
//   Future<void> closeDB() async {
//     if (myDB != null) {
//       await myDB!.close();
//       myDB = null;
//     }
//   }
// }



// // --- Demonstration ---
// void main() {
//   // 1. Initialize the service (generates unique key and IV)
//   final service = EncryptionService();

//   final originalText = "This is the secret message to be secured.";

//   print('Original Text: $originalText');
//   print('---');

//   // Display the generated keys (for demonstration purposes only)
//   print('Generated 256-bit Key (Base64): ${service.keyBytes}');
//   print('Generated 128-bit IV (Base64):  ${service.ivBytes}');
//   print('---');

//   // 2. Encryption
//   final ciphertext = service.encrypt(originalText);
//   print('Encrypted Ciphertext (Base64): $ciphertext');
//   print('---');

//   // 3. Decryption
//   try {
//     final decryptedText = service.decrypt(ciphertext);
//     print('Decrypted Text: $decryptedText');
//   } catch (e) {
//     print('Decryption Error: $e');
//   }
// }
