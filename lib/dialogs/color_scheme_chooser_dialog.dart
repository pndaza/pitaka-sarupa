import 'package:flutter/material.dart';

const _kDialogWidth = 400.0;

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? _kDialogWidth,
      height: height ?? double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [child],
      ),
    );
  }
}

Future<T?> showMyCustomeDialog<T>({
  required BuildContext context,
  required Widget child,
  double? width,
  double? height
}) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => CustomDialog(
        width: width,
        height: height,
        child: child,
      ),
    );
  
}