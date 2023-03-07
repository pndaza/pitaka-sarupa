import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/theme_controller.dart';
import 'data/constants.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.themeController});
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeController,
      child: Consumer<ThemeController>(builder: (context, themeController, __) {
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
                textScaleFactor: textScaleFactor,
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
