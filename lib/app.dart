import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'controllers/theme_controller.dart';
import 'data/constants.dart';
import 'screens/home_screen.dart';
import 'utils/platform_util.dart';
import 'utils/window_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    if (isDesktop) {
      windowManager.addListener(this);
      windowManager.setPreventClose(true);
    }
  }

  @override
  void dispose() {
    if (isDesktop) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() async {
    try {
      final isMaximized = await windowManager.isMaximized();

      if (!isMaximized) {
        final position = await windowManager.getPosition();
        final size = await windowManager.getSize();
        await WindowConfig.saveWindowConfig({
          'left': position.dx,
          'top': position.dy,
          'width': size.width,
          'height': size.height,
          'isMaximized': 0.0,
        });
      } else {
        await WindowConfig.saveWindowConfig({
          'isMaximized': 1.0,
        });
      }

      await windowManager.destroy();
    } catch (e) {
      debugPrint('Error on window close: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.themeController,
      child: Consumer<ThemeController>(builder: (context, themeController, _) {
        var fontSize = themeController.fontSize;
        var textScaleFactor = fontSize / 16;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FlexColorScheme.light(
                  fontFamily: mmFontPyidaungsu,
                  useMaterial3: true,
                  colors: themeController.themeData.light)
              .toTheme,
          darkTheme: FlexColorScheme.dark(
                  fontFamily: mmFontPyidaungsu,
                  useMaterial3: true,
                  colors: themeController.themeData.dark)
              .toTheme,
          themeMode: themeController.themeMode,
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                textScaler: TextScaler.linear(textScaleFactor),
              ),
              child: child!,
            );
          },
          home: const HomeScreen(),
        );
      }),
    );
  }
}
