import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/theme_controller.dart';
import '../../../data/theme_datas.dart';

class SchemeChooser extends StatefulWidget {
  const SchemeChooser({super.key});

  @override
  State<SchemeChooser> createState() => _SchemeChooserState();
}

class _SchemeChooserState extends State<SchemeChooser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.extent(maxCrossAxisExtent: 64, children: [
        for (var i = 0; i < schemeDataList.length; i++)
          ThemeGridItem(
            schemeData: schemeDataList[i],
            schemeDataIndex: i,
            isSelected: i == context.read<ThemeController>().schemeDataIndex,
            onSelect: () => setState(() {
              context.read<ThemeController>().onColorSchemeChanged(i);
            }),
          )
      ]),
    );
  }
}

class ThemeGridItem extends StatelessWidget {
  const ThemeGridItem(
      {super.key,
      required this.schemeData,
      required this.schemeDataIndex,
      required this.isSelected,
      this.onSelect});
  final FlexSchemeData schemeData;
  final int schemeDataIndex;
  final bool isSelected;
  final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return FlexThemeModeOptionButton(
      onSelect: onSelect,
      flexSchemeColor: FlexSchemeColor(
        primary:
            isDarkMode ? schemeData.dark.primary : schemeData.light.primary,
        primaryContainer: isDarkMode
            ? schemeData.dark.primaryContainer
            : schemeData.light.primaryContainer,
        secondary:
            isDarkMode ? schemeData.dark.secondary : schemeData.light.secondary,
        secondaryContainer: isDarkMode
            ? schemeData.dark.secondaryContainer
            : schemeData.light.secondaryContainer,
      ),
      selected: isSelected,
      height: 16,
      width: 16,
      padding: const EdgeInsets.all(1),
    );
  }
}
