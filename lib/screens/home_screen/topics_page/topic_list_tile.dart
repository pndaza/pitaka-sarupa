import 'package:flutter/material.dart';
import 'package:substring_highlight/substring_highlight.dart';

class TopicListTile extends StatelessWidget {
  const TopicListTile(
      {super.key, required this.enumText, this.highlightText, this.onTap});
  final String enumText;
  final String? highlightText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: ListTile(
        title: SubstringHighlight(
          text: enumText,
          textStyle:
              TextStyle(color: Theme.of(context).colorScheme.onBackground),
          term: highlightText,
          textStyleHighlight: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
