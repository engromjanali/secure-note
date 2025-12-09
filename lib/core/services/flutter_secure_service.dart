import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FSSService {
  static FSSService _instance = FSSService._();
  FSSService._();
  factory FSSService() => _instance;

  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  final iOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  late final FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
    iOptions: iOptions,
  );

  Future<void> setString(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> getString(String key) async {
    return await storage.read(key: key);
  }

  Future<void> clear() async {
    await storage.deleteAll();
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
}
