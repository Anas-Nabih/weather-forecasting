import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forecast_weather/core/helper/app_bloc_observer.dart';

import 'core/di/service_locator.dart';
import 'main.dart';

/// Development flavor entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  await dotenv.load(fileName: '.env');

  await setupLocator();
  runApp(const WeatherForecastApp(flavor: 'prod'));
}
