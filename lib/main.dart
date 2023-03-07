import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'clients/pref_client.dart';
import 'controllers/theme_controller.dart';
import 'services/theme_service.dart';
import 'services/theme_service_prefs.dart';

void main() async {
  // https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/using_ffi_instead_of_sqflite.md
  // sqflite only supports iOS/Android/MacOS
  // so  sqflite_common_ffi will be used for windows and linux

  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  // Required for async calls in `main`
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SharedPrefs instance.

  await PrefClient.init();
  ThemeService themeService = ThemeServicePrefs();
  await themeService.init();
  ThemeController themeController = ThemeController(themeService);
  await themeController.loadThemes();
  runApp(MyApp(themeController: themeController));
}
