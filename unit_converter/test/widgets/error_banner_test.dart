import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/widgets/error_banner.dart';

void main() {
  testWidgets('Widget has an icon and text', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ErrorBanner(),
      ),
    ));

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}