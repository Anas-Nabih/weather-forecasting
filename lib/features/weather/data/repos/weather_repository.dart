import 'package:dartz/dartz.dart';
import 'package:forecast_weather/core/errors/app_exception.dart';
import 'package:forecast_weather/core/errors/failure.dart';
import 'package:forecast_weather/core/services/api_service.dart';
import 'package:forecast_weather/core/services/cache_service.dart';
import 'package:forecast_weather/features/weather/data/models/forecast_model.dart';
import 'package:forecast_weather/features/weather/data/models/weather_model.dart';

class WeatherRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  WeatherRepository(this._apiService, this._cacheService);

  Future<Option<WeatherModel>> getCachedWeather() async {
    try {
      final weather = _cacheService.getCachedWeather();
      return optionOf(weather);
    } catch (e) {
      return none();
    }
  }

  Future<Option<ForecastModel>> getCachedForecast() async {
    try {
      final forecast = _cacheService.getCachedForecast();
      return optionOf(forecast);
    } catch (e) {
      return none();
    }
  }

  Option<DateTime> getLastUpdateTime() {
    return optionOf(_cacheService.getLastUpdateTime());
  }

  Option<String> getLastCity() {
    return optionOf(_cacheService.getLastCity());
  }

  Future<Either<Failure, (WeatherModel, ForecastModel)>> fetchWeather(
    String cityName,
  ) async {
    try {
      final results = await Future.wait([
        _apiService.getCurrentWeather(cityName),
        _apiService.getForecast(cityName),
      ]);

      final weather = results[0] as WeatherModel;
      final forecast = results[1] as ForecastModel;

      await Future.wait([
        _cacheService.cacheWeather(weather),
        _cacheService.cacheForecast(forecast),
        _cacheService.cacheLastCity(cityName),
      ]);

      return Right((weather, forecast));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }

  Future<Either<Failure, (WeatherModel, ForecastModel)>> fetchWeatherByCoords(
    double lat,
    double lon,
  ) async {
    try {
      final results = await Future.wait([
        _apiService.getCurrentWeatherByCoords(lat, lon),
        _apiService.getForecastByCoords(lat, lon),
      ]);

      final weather = results[0] as WeatherModel;
      final forecast = results[1] as ForecastModel;

      await Future.wait([
        _cacheService.cacheWeather(weather),
        _cacheService.cacheForecast(forecast),
        _cacheService.cacheLastCity(weather.cityName),
      ]);

      return Right((weather, forecast));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ApiException catch (e) {
      return Left(ApiFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: $e'));
    }
  }
}
