import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme_service.dart';

const _schemeNameKey = 'color_scheme_name';
const _schemeNameValue = 3;
const _themeModeKey = 'theme_mode';
// const _themeModeValue = ThemeMode.system;
const _fontSizeKey = 'font_size';
const _fontSizeValue = 20.0;

class ThemeServicePrefs implements ThemeService {
  late final SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<int> loadColorSchemeIndex() async {
    return _prefs.getInt(_schemeNameKey) ?? _schemeNameValue;
  }

  @override
  Future<double> loadFontSize() async {
    return _prefs.getDouble(_fontSizeKey) ?? _fontSizeValue;
  }

  @override
  Future<ThemeMode> loadThemeMode() async {
    final int index = _prefs.getInt(_themeModeKey) ?? 0;
    return ThemeMode.values[index];
  }

  @override
  Future<void> saveFontSize(double fontSize) async {
    _prefs.setDouble(_fontSizeKey, fontSize);
  }

  @override
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    _prefs.setInt(_themeModeKey, themeMode.index);
  }

  @override
  Future<void> saveColorSchemeIndex(int index) async {
    _prefs.setInt(_schemeNameKey, index);
  }
}
