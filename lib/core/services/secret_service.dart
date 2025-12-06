import 'dart:convert';
import 'dart:typed_data';
import 'package:secure_note/core/functions/f_genarate_randome_data.dart';
import 'package:secure_note/core/services/flutter_secure_service.dart';
import 'package:encrypt/encrypt.dart';

class SecretService {
  late Key _key;
  late IV _iv;
  late Encrypter _encrypter;

  SecretService._();
  static SecretService _instance = SecretService._();
  factory SecretService() => _instance;

  Future<void> init(String rawKey) async {
    _key = Key(Uint8List.fromList(utf8.encode(rawKey)));
    _iv = IV(Uint8List.fromList(utf8.encode(rawKey)));
    _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
  }

  // --- Private Key/IV Generation ---

  // // Generates a cryptographically secure 32-byte (256-bit) key
  // Future<Key> _generateSecureKey() async {
  //   String? raw = await FSSService().getString("eSkey");
  //   if (raw == null) {
  //     Uint8List bytes = generateRandomData(32, asUint8List: true);
  //     await FSSService().setString("eSkey", base64Encode(bytes));
  //     return Key(bytes);
  //   } else {
  //     return Key(base64Decode(raw));
  //   }
  // }

  // // Generates a cryptographically secure 16-byte (128-bit) IV
  // Future<IV> _generateSecureIV() async {
  //   String? raw = await FSSService().getString("eSIV");
  //   if (raw == null) {
  //     Uint8List bytes = generateRandomData(16, asUint8List: true);
  //     await FSSService().setString("eSIV", base64Encode(bytes));
  //     return IV(bytes);
  //   } else {
  //     return IV(base64Decode(raw));
  //   }
  // }

  // --- Encryption Function ---
  /// Encrypts the given plaintext string.
  /// Returns the ciphertext as a Base64-encoded string.
  String encrypt(String plaintext) {
    final encrypted = _encrypter.encrypt(plaintext, iv: _iv);
    // Convert the encrypted bytes into a Base64 string for safe storage/transmission
    return encrypted.base64;
  }

  // --- Decryption Function ---
  /// Decrypts the Base64-encoded ciphertext string.
  /// Returns the original plaintext string.
  String decrypt(String base64Ciphertext) {
    // Convert the Base64 string back to Encrypted bytes
    final encrypted = Encrypted.fromBase64(base64Ciphertext);
    // Perform the decryption
    final decrypted = _encrypter.decrypt(encrypted, iv: _iv);

    return decrypted;
  }
}
