import 'package:flutter/material.dart';
import 'package:textf/textf.dart';

class TopicListTile extends StatelessWidget {
  const TopicListTile(
      {super.key, required this.enumText, this.highlightText, this.onTap});
  final String enumText;
  final String? highlightText;
  final VoidCallback? onTap;

  String _highlightedText() {
    final term = highlightText;
    if (term == null || term.isEmpty) return enumText;
    final escaped = term.replaceAll('=', '\\=');
    return enumText.replaceAll(term, '==$escaped==');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: TextfOptions(
          highlightStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
          child: Textf(
            _highlightedText(),
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
