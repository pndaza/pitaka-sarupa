import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.title,
    this.trailing,
  });
  final Widget title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(child: title),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
