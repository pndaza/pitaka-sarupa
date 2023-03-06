import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    // this.controller,
    this.onChanged,
    this.hint,
  });
  // final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autocorrect: false,
        controller: controller,
        textInputAction: TextInputAction.search,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          // clear button
          suffixIcon: suffix(),
          contentPadding: const EdgeInsets.all(8),
          hintStyle: const TextStyle(color: Colors.grey),
          hintText: widget.hint,
        ),
      ),
    );
  }

  Widget? suffix() {
    return ValueListenableBuilder(valueListenable: controller, builder: (_,text,__){
          if (controller.text.isEmpty) {
      return const SizedBox.shrink();
    }
    return IconButton(
      onPressed: () {
        controller.clear();
        widget.onChanged?.call('');
      },
      icon: const Icon(Icons.close),
    );
    });
    

  }
}
