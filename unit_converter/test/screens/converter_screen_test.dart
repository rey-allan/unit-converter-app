import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/screens/converter_screen.dart';

void main() {
  testWidgets('Screen displays an AppBar and a ListView',
      (WidgetTester tester) async {
    final List<Unit> units = <Unit>[
      Unit(name: 'Unit 1', conversion: 1.0),
      Unit(name: 'Unit 2', conversion: 2.0),
      Unit(name: 'Unit 3', conversion: 3.0),
    ];

    await tester.pumpWidget(MaterialApp(
      home: ConverterScreen(
        name: 'Length',
        color: Colors.blueAccent,
        units: units,
      ),
    ));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
