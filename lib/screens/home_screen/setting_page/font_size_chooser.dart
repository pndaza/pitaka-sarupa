import 'package:flutter/material.dart';

class FontSizeChooser extends StatefulWidget {
  const FontSizeChooser({
    super.key,
    required this.fontSize,
    this.onChanged,
  });
  final double fontSize;
  final ValueChanged<double>? onChanged;

  @override
  State<FontSizeChooser> createState() => _FontSizeChooserState();
}

class _FontSizeChooserState extends State<FontSizeChooser> {
  late double fontSize;
  @override
  void initState() {
    super.initState();
    fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => setState(() {
            // fontSize--;
            widget.onChanged?.call(--fontSize);
          }),
          icon: const Icon(Icons.remove),
        ),
        Text(
          fontSize.round().toString(),
        ),
        IconButton(
          onPressed: () => setState(() {
            // fontSize++;
            widget.onChanged?.call(++fontSize);
          }),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
