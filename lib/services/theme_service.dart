import 'package:flutter/material.dart';

abstract class ThemeService {
  /// ThemeService implementations may override this method to perform needed
  /// initialization and setup work.
  Future<void> init();

  Future<ThemeMode> loadThemeMode();
  Future<void> saveThemeMode(ThemeMode themeMode);

  Future<int> loadColorSchemeIndex();
  Future<void> saveColorSchemeIndex(int index);

  Future<double> loadFontSize();
  Future<void> saveFontSize(double fontSize);
}
