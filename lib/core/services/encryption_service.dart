import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../errors/app_exception.dart';
import '../utils/constants.dart';

class EncryptionService {
  final FlutterSecureStorage _secureStorage;
  encrypt.Encrypter? _encrypter;
  bool _initialized = false;

  EncryptionService(this._secureStorage);

  Future<void> init() async {
    if (_initialized) return;

    try {
      String? keyString = await _secureStorage.read(
        key: CacheKeys.encryptionKey,
      );

      if (keyString == null) {
        final key = encrypt.Key.fromSecureRandom(32);
        keyString = base64Encode(key.bytes);
        await _secureStorage.write(
          key: CacheKeys.encryptionKey,
          value: keyString,
        );
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
      } else {
        final keyBytes = base64Decode(keyString);
        final key = encrypt.Key(Uint8List.fromList(keyBytes));
        _encrypter = encrypt.Encrypter(encrypt.AES(key));
      }

      _initialized = true;
    } catch (e) {
      throw EncryptionException('Failed to initialize encryption: $e');
    }
  }

  String encryptText(String plainText) {
    if (!_initialized || _encrypter == null) {
      throw const EncryptionException('Encryption service not initialized');
    }

    try {
      final iv = encrypt.IV.fromLength(16);
      final encrypted = _encrypter!.encrypt(plainText, iv: iv);
      return '${iv.base64}:${encrypted.base64}';
    } catch (e) {
      throw EncryptionException('Failed to encrypt data: $e');
    }
  }

  /// Decrypt cipher text
  String decryptText(String cipherText) {
    if (!_initialized || _encrypter == null) {
      throw const EncryptionException('Encryption service not initialized');
    }

    try {
      final parts = cipherText.split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid encrypted data format');
      }

      final iv = encrypt.IV.fromBase64(parts[0]);
      final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

      return _encrypter!.decrypt(encrypted, iv: iv);
    } catch (e) {
      throw EncryptionException('Failed to decrypt data: $e');
    }
  }

  /// Encrypt JSON object
  String encryptJson(Map<String, dynamic> json) {
    final jsonString = jsonEncode(json);
    return encryptText(jsonString);
  }

  /// Decrypt to JSON object
  Map<String, dynamic> decryptJson(String cipherText) {
    final jsonString = decryptText(cipherText);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Clear encryption key (use with caution)
  Future<void> clearKey() async {
    await _secureStorage.delete(key: CacheKeys.encryptionKey);
    _encrypter = null;
    _initialized = false;
  }
}
