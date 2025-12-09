import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forecast_weather/features/weather/presentation/view/weather_screen.dart';

import 'core/di/service_locator.dart';
import 'core/routes/custom_navigator.dart';
import 'core/theme/app_theme.dart';
import 'features/theme/presentation/view_model/theme_cubit.dart';
import 'features/theme/presentation/view_model/theme_state.dart';

class WeatherForecastApp extends StatelessWidget {
  final String flavor;

  const WeatherForecastApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (_) => sl<ThemeCubit>(),
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                title: flavor == 'dev'
                    ? 'Weather Forecast DEV'
                    : 'Weather Forecast',
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: flavor == 'dev',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                home: child,
              );
            },
          ),
        );
      },
      child: const WeatherScreen(),
    );
  }
}
