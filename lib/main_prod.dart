import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/service_locator.dart';
import 'main.dart';

/// Production flavor entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await setupLocator();

  runApp(const WeatherForecastApp(flavor: 'prod'));
}
