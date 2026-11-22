import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSession {
  static const _loggedInKey = 'is_logged_in';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static Future<bool> isLoggedIn() async {
    return await _storage.read(key: _loggedInKey) == 'true';
  }

  static Future<void> markLoggedIn() async {
    await _storage.write(key: _loggedInKey, value: 'true');
  }

  static Future<void> clear() async {
    await _storage.delete(key: _loggedInKey);
  }
}
