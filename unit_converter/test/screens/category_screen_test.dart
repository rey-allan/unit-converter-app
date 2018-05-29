import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/screens/category_screen.dart';

void main() {
  testWidgets('Screen displays an AppBar and a ListView',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CategoryScreen(),
      )
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
