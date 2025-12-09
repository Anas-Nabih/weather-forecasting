import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../features/weather/data/models/forecast_model.dart';
import '../../features/weather/data/models/weather_model.dart';
import '../errors/app_exception.dart';
import '../utils/constants.dart';

class ApiService {
  final Dio _dio;
  final String _apiKey;
  final bool _useMockData;

  ApiService(this._dio, {String? apiKey, bool? useMockData})
    : _apiKey = apiKey ?? dotenv.env['OPENWEATHER_API_KEY'] ?? '',
      _useMockData =
          useMockData ?? (dotenv.env['USE_MOCK_DATA']?.toLowerCase() == 'true');

  // ==================== Current Weather ====================

  Future<WeatherModel> getCurrentWeather(String cityName) async {
    if (_useMockData) {
      return _getMockWeather(cityName);
    }

    try {
      final response = await _dio.get(
        ApiConstants.currentWeatherEndpoint,
        queryParameters: {'q': cityName, 'appid': _apiKey},
      );

      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoords(double lat, double lon) async {
    if (_useMockData) {
      return _getMockWeather('Current Location');
    }

    try {
      final response = await _dio.get(
        ApiConstants.currentWeatherEndpoint,
        queryParameters: {'lat': lat, 'lon': lon, 'appid': _apiKey},
      );

      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Forecast ====================

  /// Fetch 5-day/3-hour forecast
  Future<ForecastModel> getForecast(String cityName) async {
    if (_useMockData) {
      return _getMockForecast(cityName);
    }

    try {
      final response = await _dio.get(
        ApiConstants.forecastEndpoint,
        queryParameters: {'q': cityName, 'appid': _apiKey},
      );

      return ForecastModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetch forecast by coordinates
  Future<ForecastModel> getForecastByCoords(double lat, double lon) async {
    if (_useMockData) {
      return _getMockForecast('Current Location');
    }

    try {
      final response = await _dio.get(
        ApiConstants.forecastEndpoint,
        queryParameters: {'lat': lat, 'lon': lon, 'appid': _apiKey},
      );

      return ForecastModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Geocoding ====================

  /// Search cities by name
  Future<List<Map<String, dynamic>>> searchCities(String query) async {
    if (_useMockData) {
      // Mock data implementation if needed
      return [];
    }

    try {
      final response = await _dio.get(
        ApiConstants.geocodingEndpoint,
        queryParameters: {'q': query, 'limit': 5, 'appid': _apiKey},
      );

      return List<Map<String, dynamic>>.from(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ==================== Error Handling ====================

  AppException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('Connection timeout');
    }

    if (error.type == DioExceptionType.connectionError) {
      return const NetworkException('No internet connection');
    }

    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      return ApiException.fromStatusCode(statusCode ?? 500);
    }

    return const ApiException('An unexpected error occurred');
  }

  // ==================== Mock Data (for dev flavor) ====================

  WeatherModel _getMockWeather(String cityName) {
    return WeatherModel(
      cityName: cityName,
      country: 'XX',
      temperature: 293.15,
      // 20°C
      feelsLike: 291.15,
      humidity: 65,
      windSpeed: 5.5,
      pressure: 1013,
      condition: 'Clear',
      description: 'clear sky',
      conditionId: 800,
      icon: '01d',
      dateTime: DateTime.now(),
      lat: 0,
      lon: 0,
    );
  }

  ForecastModel _getMockForecast(String cityName) {
    final now = DateTime.now();
    final forecasts = List.generate(40, (index) {
      return ForecastItemModel(
        dateTime: now.add(Duration(hours: index * 3)),
        temperature: 288.15 + (index % 10) * 2,
        // Varying temps
        feelsLike: 286.15 + (index % 10) * 2,
        humidity: 60 + (index % 20),
        windSpeed: 3.0 + (index % 5),
        pressure: 1010 + (index % 10),
        condition: index % 3 == 0 ? 'Clouds' : 'Clear',
        description: index % 3 == 0 ? 'few clouds' : 'clear sky',
        conditionId: index % 3 == 0 ? 801 : 800,
        icon: index % 3 == 0 ? '02d' : '01d',
        pop: (index % 10) / 10,
      );
    });

    return ForecastModel(
      cityName: cityName,
      country: 'XX',
      forecasts: forecasts,
    );
  }
}
