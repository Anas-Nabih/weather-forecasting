import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../utils/constants.dart';

class NetworkClient {
  late final Dio _dio;

  Dio get dio => _dio;

  NetworkClient({String? baseUrl}) {
    final url = baseUrl ?? dotenv.env['OPENWEATHER_BASE_URL'] ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: url,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
      ),
    );

    // LogInterceptor is often useful in dev, keeping the setup as requested.
    // _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
