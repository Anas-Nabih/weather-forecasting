import 'package:forecast_weather/core/services/cache_service.dart';

class ThemeRepository {
  final CacheService _cacheService;

  ThemeRepository(this._cacheService);

  bool isDarkMode() {
    return _cacheService.isDarkMode();
  }

  Future<void> setDarkMode(bool isDark) async {
    await _cacheService.setDarkMode(isDark);
  }
}
