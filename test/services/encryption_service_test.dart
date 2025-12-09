import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:forecast_weather/core/services/encryption_service.dart';
import 'package:forecast_weather/core/errors/app_exception.dart';
import '../helpers/mock_helpers.dart';

void main() {
  late EncryptionService encryptionService;
  late MockFlutterSecureStorage mockSecureStorage;

  // 🔑 مفتاح AES-256 صحيح (32 bytes -> Base64 = 44 chars)
  const validKey = 'AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8=';

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    encryptionService = EncryptionService(mockSecureStorage);
  });

  group('EncryptionService', () {
    test('init generates new key if none exists', () async {
      // Arrange
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      when(() => mockSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      )).thenAnswer((_) async {});

      // Act
      await encryptionService.init();

      // Assert
      verify(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .called(1);

      verify(() => mockSecureStorage.write(
        key: 'weather_encryption_key',
        value: any(named: 'value'),
      )).called(1);
    });

    test('init loads existing key', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      verify(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .called(1);

      verifyNever(() => mockSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ));
    });

    test('encryptText encrypts plain text', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      final encrypted = encryptionService.encryptText('Hello World');

      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot('Hello World'));
    });

    test('decryptText decrypts cipher text', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      final encrypted = encryptionService.encryptText('Hello World');
      final decrypted = encryptionService.decryptText(encrypted);

      expect(decrypted, 'Hello World');
    });

    test('encrypt and decrypt round trip preserves data', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      const testData = 'This is sensitive weather forecast data!';

      final encrypted = encryptionService.encryptText(testData);
      final decrypted = encryptionService.decryptText(encrypted);

      expect(decrypted, testData);
    });

    test('encryptJson encrypts JSON object', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      final jsonData = {'city': 'London', 'temp': 20};

      final encrypted = encryptionService.encryptJson(jsonData);

      expect(encrypted, isNotEmpty);
    });

    test('decryptJson decrypts to JSON object', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      await encryptionService.init();

      final jsonData = {'city': 'London', 'temp': 20};
      final encrypted = encryptionService.encryptJson(jsonData);
      final decrypted = encryptionService.decryptJson(encrypted);

      expect(decrypted, jsonData);
    });

    test('encryptText throws if not initialized', () {
      expect(
            () => encryptionService.encryptText('test'),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('decryptText throws if not initialized', () {
      expect(
            () => encryptionService.decryptText('test'),
        throwsA(isA<EncryptionException>()),
      );
    });

    test('clearKey deletes encryption key', () async {
      when(() => mockSecureStorage.read(key: 'weather_encryption_key'))
          .thenAnswer((_) async => validKey);

      when(() => mockSecureStorage.delete(key: 'weather_encryption_key'))
          .thenAnswer((_) async {});

      await encryptionService.init();

      await encryptionService.clearKey();

      verify(() => mockSecureStorage.delete(key: 'weather_encryption_key'))
          .called(1);

      expect(
            () => encryptionService.encryptText('test'),
        throwsA(isA<EncryptionException>()),
      );
    });
  });
}
