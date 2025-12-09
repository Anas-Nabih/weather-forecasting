import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forecast_weather/core/widgets/section_header.dart';
import 'package:forecast_weather/features/theme/presentation/view_model/theme_cubit.dart';
import 'package:forecast_weather/features/theme/presentation/view_model/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SectionHeader(title: 'Appearance'),
          BlocBuilder<ThemeCubit, ThemeState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            builder: (context, state) {
              final isDarkMode = state.isDarkMode;
              return SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: Text(
                  isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                ),
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                value: isDarkMode,
                onChanged: (value) =>
                    context.read<ThemeCubit>().setTheme(value),
              );
            },
          ),
        ],
      ),
    );
  }
}
