import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'clients/pref_client.dart';
import 'controllers/theme_controller.dart';
import 'services/theme_service.dart';
import 'services/theme_service_prefs.dart';
import 'utils/platform_util.dart';
import 'utils/window_config.dart';

const _defaultSize = Size(1080, 720);
const _minSize = Size(400, 300);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    final windowConfig = await WindowConfig.loadWindowConfig();
    await windowManager.ensureInitialized();

    final double? left = windowConfig?['left'];
    final double? top = windowConfig?['top'];
    final double? width = windowConfig?['width'];
    final double? height = windowConfig?['height'];
    final bool isMaximized = windowConfig?['isMaximized'] == 1.0;

    Size size;
    bool center;
    if (width != null && height != null) {
      size = Size(width, height);
      center = (left == null || top == null);
    } else {
      size = _defaultSize;
      center = true;
    }

    WindowOptions windowOptions = WindowOptions(
      size: size,
      center: center,
      minimumSize: _minSize,
      skipTaskbar: false,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      if (isMaximized) {
        await windowManager.maximize();
      } else if (left != null && top != null && width != null && height != null) {
        await windowManager.setBounds(Rect.fromLTWH(left, top, width, height));
      }

      await windowManager.show();
      await windowManager.focus();
    });
  }

  // https://github.com/tekartik/sqflite/blob/master/sqflite_common_ffi/doc/using_ffi_instead_of_sqflite.md
  // sqflite only supports iOS/Android/MacOS
  // so  sqflite_common_ffi will be used for windows and linux

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await PrefClient.init();
  ThemeService themeService = ThemeServicePrefs();
  await themeService.init();
  ThemeController themeController = ThemeController(themeService);
  await themeController.loadThemes();
  runApp(MyApp(themeController: themeController));
}
