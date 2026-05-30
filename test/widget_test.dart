import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Default test', (WidgetTester tester) async {
    await tester.pumpWidget(const _TestWidget());
    expect(find.text('test'), findsOneWidget);
  });
}

class _TestWidget extends StatelessWidget {
  const _TestWidget();
  @override
  Widget build(BuildContext context) {
    return const Text('test');
  }
}
