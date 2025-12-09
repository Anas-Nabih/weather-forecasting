import 'dart:convert';

import 'package:forecast_weather/core/errors/app_exception.dart';
import 'package:forecast_weather/core/utils/constants.dart';
import 'package:forecast_weather/features/weather/data/models/forecast_model.dart';
import 'package:forecast_weather/features/weather/data/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'encryption_service.dart';

class CacheService {
  final SharedPreferences _prefs;
  final EncryptionService _encryptionService;

  CacheService(this._prefs, this._encryptionService);

  // ==================== Weather Caching ====================

  Future<void> cacheWeather(WeatherModel weather) async {
    try {
      final json = weather.toJson();
      final jsonString = jsonEncode(json);
      await _prefs.setString(CacheKeys.currentWeather, jsonString);
      await _updateLastUpdateTime();
    } catch (e) {
      throw CacheException('Failed to cache weather: $e');
    }
  }

  WeatherModel? getCachedWeather() {
    try {
      final jsonString = _prefs.getString(CacheKeys.currentWeather);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } catch (e) {
      throw CacheException('Failed to load cached weather: $e');
    }
  }

  // ==================== Forecast Caching (Encrypted) ====================

  Future<void> cacheForecast(ForecastModel forecast) async {
    try {
      final json = forecast.toJson();
      final encrypted = _encryptionService.encryptJson(json);
      await _prefs.setString(CacheKeys.forecast, encrypted);
      await _updateLastUpdateTime();
    } catch (e) {
      throw CacheException('Failed to cache forecast: $e');
    }
  }

  ForecastModel? getCachedForecast() {
    try {
      final encrypted = _prefs.getString(CacheKeys.forecast);
      if (encrypted == null) {
        return null;
      }

      final json = _encryptionService.decryptJson(encrypted);
      return ForecastModel.fromJson(json);
    } catch (e) {
       throw CacheException('Failed to load cached forecast: $e');
    }
  }

  // ==================== City Caching ====================

  Future<void> cacheLastCity(String cityName) async {
    try {
      await _prefs.setString(CacheKeys.lastCity, cityName);
    } catch (e) {
      throw CacheException('Failed to cache city: $e');
    }
  }

  String? getLastCity() {
    return _prefs.getString(CacheKeys.lastCity);
  }

  // ==================== Last Update Time ====================

  Future<void> _updateLastUpdateTime() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _prefs.setInt(CacheKeys.lastUpdateTime, now);
  }

  DateTime? getLastUpdateTime() {
    final timestamp = _prefs.getInt(CacheKeys.lastUpdateTime);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // ==================== Theme Preference ====================

  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(CacheKeys.isDarkMode, isDark);
  }

  bool isDarkMode() {
    return _prefs.getBool(CacheKeys.isDarkMode) ?? false;
  }

  // ==================== Clear Cache ====================

  Future<void> clearAllCache() async {
    await _prefs.remove(CacheKeys.currentWeather);
    await _prefs.remove(CacheKeys.forecast);
    await _prefs.remove(CacheKeys.lastUpdateTime);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
