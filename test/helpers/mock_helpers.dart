import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forecast_weather/core/services/encryption_service.dart';
import 'package:forecast_weather/core/services/cache_service.dart';
import 'package:forecast_weather/core/services/api_service.dart';

// Mock classes for testing

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockEncryptionService extends Mock implements EncryptionService {}

class MockCacheService extends Mock implements CacheService {}

class MockApiService extends Mock implements ApiService {}
