import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../data/theme_datas.dart';
import '../services/theme_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this.themeService);
  final ThemeService themeService;

  Future<void> loadThemes() async {
    // themeService.init();
    _currentschemeDataIndex = await themeService.loadColorSchemeIndex();
    _currentThemeMode = await themeService.loadThemeMode();
    _currentFontSize = await themeService.loadFontSize();
  }

  late int _currentschemeDataIndex;
  late ThemeMode _currentThemeMode;
  late double _currentFontSize;

  // thememode.system
    int get schemeDataIndex => _currentschemeDataIndex;
  FlexSchemeData get themeData => schemeDataList[_currentschemeDataIndex];
  ThemeMode get themeMode => _currentThemeMode;
  double get fontSize => _currentFontSize;

  Future<void> onColorSchemeChanged(int index) async {
    await themeService.saveColorSchemeIndex(index);
    _currentschemeDataIndex = index;
    notifyListeners();
  }

  Future<void> onThemeModeChanged(ThemeMode themeMode) async {
    await themeService.saveThemeMode(themeMode);
    _currentThemeMode = themeMode;
    notifyListeners();
  }

  Future<void> onFontSizeChanged(double fontSize) async {
    await themeService.saveFontSize(fontSize);
    _currentFontSize = fontSize;
    notifyListeners();
  }
}
