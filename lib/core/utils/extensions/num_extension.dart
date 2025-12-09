 import 'package:forecast_weather/core/utils/constants.dart';

extension WeatherConditionExtensions on int {
  /// Get Lottie animation asset based on weather condition ID
  String get weatherAnimation {
    if (WeatherConditions.thunderstorm.contains(this)) {
      return LottieAssets.thunderstorm;
    } else if (WeatherConditions.drizzle.contains(this) ||
        WeatherConditions.rain.contains(this)) {
      return LottieAssets.rainy;
    } else if (WeatherConditions.snow.contains(this)) {
      return LottieAssets.snowy;
    } else if (WeatherConditions.atmosphere.contains(this)) {
      return LottieAssets.mist;
    } else if (this == WeatherConditions.clear) {
      return LottieAssets.sunny;
    } else if (WeatherConditions.clouds.contains(this)) {
      return LottieAssets.cloudy;
    }
    return LottieAssets.sunny; // default
  }

  /// Get weather condition description
  String get weatherDescription {
    if (WeatherConditions.thunderstorm.contains(this)) {
      return 'Thunderstorm';
    } else if (WeatherConditions.drizzle.contains(this)) {
      return 'Drizzle';
    } else if (WeatherConditions.rain.contains(this)) {
      return 'Rainy';
    } else if (WeatherConditions.snow.contains(this)) {
      return 'Snowy';
    } else if (WeatherConditions.atmosphere.contains(this)) {
      return 'Misty';
    } else if (this == WeatherConditions.clear) {
      return 'Clear';
    } else if (WeatherConditions.clouds.contains(this)) {
      return 'Cloudy';
    }
    return 'Unknown';
  }
}


 extension TemperatureExtensions on double {
   /// Convert Kelvin to Celsius
   double get kelvinToCelsius => this - 273.15;

   /// Convert Kelvin to Fahrenheit
   double get kelvinToFahrenheit => (this - 273.15) * 9 / 5 + 32;

   /// Format temperature with degree symbol
   String toTemperature({bool celsius = true}) {
     final temp = celsius ? kelvinToCelsius : kelvinToFahrenheit;
     return '${temp.round()}°${celsius ? 'C' : 'F'}';
   }
 }
