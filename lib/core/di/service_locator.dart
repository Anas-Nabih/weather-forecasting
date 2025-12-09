import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:forecast_weather/core/services/api_service.dart';
import 'package:forecast_weather/core/services/cache_service.dart';
import 'package:forecast_weather/core/services/encryption_service.dart';
import 'package:forecast_weather/core/services/network_client.dart';
import 'package:forecast_weather/features/cities/data/repos/cities_repository.dart';
import 'package:forecast_weather/features/cities/presentation/view_model/cities_cubit.dart';
import 'package:forecast_weather/features/theme/data/repos/theme_repository.dart';
import 'package:forecast_weather/features/theme/presentation/view_model/theme_cubit.dart';
import 'package:forecast_weather/features/weather/data/repos/weather_repository.dart';
import 'package:forecast_weather/features/weather/presentation/view_model/weather_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  sl.registerSingleton<FlutterSecureStorage>(secureStorage);

  // ==================== Services ====================

  final encryptionService = EncryptionService(sl<FlutterSecureStorage>());
  await encryptionService.init();
  sl.registerSingleton<EncryptionService>(encryptionService);

  sl.registerSingleton<CacheService>(
    CacheService(sl<SharedPreferences>(), sl<EncryptionService>()),
  );

  sl.registerSingleton<NetworkClient>(NetworkClient());

  sl.registerSingleton<ApiService>(ApiService(sl<NetworkClient>().dio));

  // ==================== Repositories ====================

  sl.registerSingleton<WeatherRepository>(
    WeatherRepository(sl<ApiService>(), sl<CacheService>()),
  );

  sl.registerSingleton<ThemeRepository>(ThemeRepository(sl<CacheService>()));

  sl.registerSingleton<CitiesRepository>(CitiesRepository(sl<ApiService>()));

  // ==================== Cubits ====================

  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl<ThemeRepository>()));

  sl.registerSingleton<WeatherCubit>(WeatherCubit(sl<WeatherRepository>()));
  sl.registerFactory<CitiesCubit>(() => CitiesCubit(sl<CitiesRepository>()));
}

Future<void> resetLocator() async {
  await sl.reset();
}
