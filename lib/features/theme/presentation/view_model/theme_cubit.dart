import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/theme_repository.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeCubit(this._themeRepository) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = _themeRepository.isDarkMode();
    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> setTheme(bool isDark) async {
    await _themeRepository.setDarkMode(isDark);
    emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> toggleTheme() async {
    final isDark = !state.isDarkMode;
    await setTheme(isDark);
  }
}
