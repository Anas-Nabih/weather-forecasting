/// Application-wide constants
library;

/// API Constants
class ApiConstants {
  static const String currentWeatherEndpoint = '/weather';
  static const String forecastEndpoint = '/forecast';
  static const String geocodingEndpoint =
      'https://api.openweathermap.org/geo/1.0/direct';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;
}

/// Cache Keys
class CacheKeys {
  static const String currentWeather = 'current_weather';
  static const String forecast = 'forecast_encrypted';
  static const String lastCity = 'last_city';
  static const String lastUpdateTime = 'last_update_time';
  static const String favoriteCities = 'favorite_cities';
  static const String isDarkMode = 'is_dark_mode';
  static const String encryptionKey = 'weather_encryption_key';
}

/// App Constants
class AppConstants {
  static const String appName = 'Weather Forecast';
  static const String appNameDev = 'Weather Forecast DEV';
  static const int searchDebounceMs = 500;
  static const int maxFavorites = 10;
  static const int cacheValidityHours = 1;
}

/// Lottie Animation Assets
class LottieAssets {
  static const String sunny = 'assets/lottie/sunny.json';
  static const String rainy = 'assets/lottie/rainy.json';
  static const String cloudy = 'assets/lottie/cloudy.json';
  static const String snowy = 'assets/lottie/snowy.json';
  static const String thunderstorm = 'assets/lottie/thunderstorm.json';
  static const String mist = 'assets/lottie/mist.json';
}

/// Weather Condition IDs from OpenWeatherMap
class WeatherConditions {
  // Thunderstorm
  static const List<int> thunderstorm = [
    200,
    201,
    202,
    210,
    211,
    212,
    221,
    230,
    231,
    232,
  ];

  // Drizzle
  static const List<int> drizzle = [
    300,
    301,
    302,
    310,
    311,
    312,
    313,
    314,
    321,
  ];

  // Rain
  static const List<int> rain = [
    500,
    501,
    502,
    503,
    504,
    511,
    520,
    521,
    522,
    531,
  ];

  // Snow
  static const List<int> snow = [
    600,
    601,
    602,
    611,
    612,
    613,
    615,
    616,
    620,
    621,
    622,
  ];

  // Atmosphere (mist, fog, etc.)
  static const List<int> atmosphere = [
    701,
    711,
    721,
    731,
    741,
    751,
    761,
    762,
    771,
    781,
  ];

  // Clear
  static const int clear = 800;

  // Clouds
  static const List<int> clouds = [801, 802, 803, 804];
}
