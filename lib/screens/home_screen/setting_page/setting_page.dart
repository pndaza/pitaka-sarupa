import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'font_size_chooser.dart';
import 'package:provider/provider.dart';

import '../../../controllers/theme_controller.dart';
import 'setting_title.dart';
import 'theme_grid.dart';
import 'theme_mode_switch.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('အပြင်အဆင်', textScaleFactor: 1.0),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SettingTile(
              title: const Text('အရောင်'),
              trailing: FlexThemeModeOptionButton(
                onSelect: () async {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            title: const Center(child: Text('အရောင်ရွေးရန်')),
                            content: Builder(
                              builder: (context) {
                                return const SizedBox(
                                  width: 350,
                                  height: 350,
                                  child: SchemeChooser(),
                                );
                              },
                            ),
                            actions: [
                              Center(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size(100, 48),
                                  ),
                                  child: const Text('ပိတ်'),
                                ),
                              )
                            ],
                          ));
                },
                flexSchemeColor: FlexSchemeColor(
                  primary: theme.colorScheme.primary,
                  primaryContainer: theme.colorScheme.primaryContainer,
                  secondary: theme.colorScheme.secondary,
                  secondaryContainer: theme.colorScheme.secondaryContainer,
                ),
                selected: true,
                height: 16,
                width: 16,
                padding: const EdgeInsets.all(1),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: SettingTile(
                title: const Text('နောက်ခံ'),
                trailing: ThemeModeSwitch(
                  themeMode: themeController.themeMode,
                  onChanged: themeController.onThemeModeChanged,
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: SettingTile(
              title: const Text('စာလုံးအရွယ်အစား'),
              trailing: FontSizeChooser(
                fontSize: themeController.fontSize,
                onChanged: themeController.onFontSizeChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
