import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  /// Get theme
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;




}
