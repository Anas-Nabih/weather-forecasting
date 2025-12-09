import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:forecast_weather/core/services/cache_service.dart';
import 'package:forecast_weather/features/weather/data/models/forecast_model.dart';
import 'package:forecast_weather/features/weather/data/models/weather_model.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_helpers.dart';

void main() {
  late CacheService cacheService;
  late MockSharedPreferences mockPrefs;
  late MockEncryptionService mockEncryptionService;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockEncryptionService = MockEncryptionService();
    cacheService = CacheService(mockPrefs, mockEncryptionService);
  });

  final testWeather = WeatherModel(
    cityName: 'London',
    country: 'GB',
    temperature: 293.15,
    feelsLike: 291.15,
    humidity: 65,
    windSpeed: 5.5,
    pressure: 1013,
    condition: 'Clear',
    description: 'clear sky',
    conditionId: 800,
    icon: '01d',
    dateTime: DateTime.now(),
  );

  final testForecast = ForecastModel(
    cityName: 'London',
    country: 'GB',
    forecasts: [],
  );

  group('CacheService - Weather', () {
    test('cacheWeather stores weather in SharedPreferences', () async {
      // Arrange
      when(
        () => mockPrefs.setString(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);

      // Act
      await cacheService.cacheWeather(testWeather);

      // Assert
      verify(() => mockPrefs.setString('current_weather', any())).called(1);
    });

    test('getCachedWeather retrieves weather from SharedPreferences', () {
      // Arrange
      final jsonString = jsonEncode(testWeather.toJson());
      when(() => mockPrefs.getString('current_weather')).thenReturn(jsonString);

      // Act
      final result = cacheService.getCachedWeather();

      // Assert
      expect(result, isNotNull);
      expect(result!.cityName, 'London');
    });

    test('getCachedWeather returns null if no weather cached', () {
      // Arrange
      when(() => mockPrefs.getString('current_weather')).thenReturn(null);

      // Act
      final result = cacheService.getCachedWeather();

      // Assert
      expect(result, isNull);
    });
  });

  group('CacheService - Forecast', () {
    test('cacheForecast encrypts and stores forecast', () async {
      // Arrange
      when(
        () => mockEncryptionService.encryptJson(any()),
      ).thenReturn('encrypted_data');
      when(
        () => mockPrefs.setString(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);

      // Act
      await cacheService.cacheForecast(testForecast);

      // Assert
      verify(() => mockEncryptionService.encryptJson(any())).called(1);
      verify(
        () => mockPrefs.setString('forecast_encrypted', 'encrypted_data'),
      ).called(1);
    });

    test('getCachedForecast decrypts and retrieves forecast', () {
      // Arrange
      when(
        () => mockPrefs.getString('forecast_encrypted'),
      ).thenReturn('encrypted_data');
      when(
        () => mockEncryptionService.decryptJson('encrypted_data'),
      ).thenReturn(testForecast.toJson());

      // Act
      final result = cacheService.getCachedForecast();

      // Assert
      expect(result, isNotNull);
      expect(result!.cityName, 'London');
      verify(
        () => mockEncryptionService.decryptJson('encrypted_data'),
      ).called(1);
    });

    test('getCachedForecast returns null if no forecast cached', () {
      // Arrange
      when(() => mockPrefs.getString('forecast_encrypted')).thenReturn(null);

      // Act
      final result = cacheService.getCachedForecast();

      // Assert
      expect(result, isNull);
    });
  });

  group('CacheService - City', () {
    test('cacheLastCity stores city name', () async {
      // Arrange
      when(
        () => mockPrefs.setString(any(), any()),
      ).thenAnswer((_) async => true);

      // Act
      await cacheService.cacheLastCity('London');

      // Assert
      verify(() => mockPrefs.setString('last_city', 'London')).called(1);
    });

    test('getLastCity retrieves cached city', () {
      // Arrange
      when(() => mockPrefs.getString('last_city')).thenReturn('London');

      // Act
      final result = cacheService.getLastCity();

      // Assert
      expect(result, 'London');
    });
  });

  group('CacheService - Theme', () {
    test('setDarkMode stores dark mode preference', () async {
      // Arrange
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);

      // Act
      await cacheService.setDarkMode(true);

      // Assert
      verify(() => mockPrefs.setBool('is_dark_mode', true)).called(1);
    });

    test('isDarkMode returns dark mode preference', () {
      // Arrange
      when(() => mockPrefs.getBool('is_dark_mode')).thenReturn(true);

      // Act
      final result = cacheService.isDarkMode();

      // Assert
      expect(result, true);
    });

    test('isDarkMode returns false by default', () {
      // Arrange
      when(() => mockPrefs.getBool('is_dark_mode')).thenReturn(null);

      // Act
      final result = cacheService.isDarkMode();

      // Assert
      expect(result, false);
    });
  });

  group('CacheService - Last Update Time', () {
    test('getLastUpdateTime retrieves timestamp', () {
      // Arrange
      final now = DateTime.now().millisecondsSinceEpoch;
      when(() => mockPrefs.getInt('last_update_time')).thenReturn(now);

      // Act
      final result = cacheService.getLastUpdateTime();

      // Assert
      expect(result, isNotNull);
    });

    test('getLastUpdateTime returns null if not set', () {
      // Arrange
      when(() => mockPrefs.getInt('last_update_time')).thenReturn(null);

      // Act
      final result = cacheService.getLastUpdateTime();

      // Assert
      expect(result, isNull);
    });
  });

  group('CacheService - Clear Cache', () {
    test('clearAllCache removes weather and forecast data', () async {
      // Arrange
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      await cacheService.clearAllCache();

      // Assert
      verify(() => mockPrefs.remove('current_weather')).called(1);
      verify(() => mockPrefs.remove('forecast_encrypted')).called(1);
      verify(() => mockPrefs.remove('last_update_time')).called(1);
    });

    test('clearAll removes all preferences', () async {
      // Arrange
      when(() => mockPrefs.clear()).thenAnswer((_) async => true);

      // Act
      await cacheService.clearAll();

      // Assert
      verify(() => mockPrefs.clear()).called(1);
    });
  });
}
