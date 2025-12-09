import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/forecast.dart';

import '../../data/repos/weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherCubit(this._weatherRepository) : super(const WeatherState());

  Future<void> init() async {
    await loadCachedData();
  }

  Future<void> loadCachedData() async {
    final weatherOpt = await _weatherRepository.getCachedWeather();
    final forecastOpt = await _weatherRepository.getCachedForecast();
    final lastUpdateOpt = _weatherRepository.getLastUpdateTime();

    weatherOpt.fold(() => null, (weather) {
      forecastOpt.fold(() => null, (forecast) {
        lastUpdateOpt.fold(() => null, (lastUpdate) {
          emit(
            state.copyWith(
              status: WeatherStatus.success,
              currentWeather: weather,
              forecast: forecast,
              lastUpdateTime: lastUpdate,
            ),
          );
        });
      });
    });
  }

  Future<void> fetchWeather(String cityName, {bool silently = false}) async {
    if (cityName.isEmpty) {
      emit(
        state.copyWith(
          status: WeatherStatus.failure,
          errorMessage: 'Please enter a city name',
        ),
      );
      return;
    }

    if (!silently) {
      emit(state.copyWith(status: WeatherStatus.loading));
    }

    final result = await _weatherRepository.fetchWeather(cityName);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: WeatherStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (data) {
        final (weather, forecast) = data;
        emit(
          state.copyWith(
            status: WeatherStatus.success,
            currentWeather: weather,
            forecast: forecast,
            lastUpdateTime: DateTime.now(),
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    if (state.currentWeather == null) return;
    await fetchWeather(state.currentWeather!.cityName, silently: true);
  }

  List<ForecastItem> get getDailyForecasts {
    if (state.forecast == null) return [];
    return state.forecast!.getDailyForecasts(days: 7);
  }
}
