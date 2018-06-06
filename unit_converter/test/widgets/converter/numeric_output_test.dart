import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/widgets/converter/numeric_output.dart';

void main() {
  testWidgets('Displays a value with a label', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NumericOutput(
              label: 'Output',
              value: 24.0,
            ),
          ),
        )
    );

    expect(find.text("24"), findsOneWidget);

    final InputDecorator decorator = tester.widget(find.byType(InputDecorator));
    final InputDecoration inputDecoration = decorator.decoration;

    expect(inputDecoration.labelText, equals('Output'));
  });

  testWidgets('Defaults to empty with no value', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NumericOutput(
              label: 'Output',
            ),
          ),
        )
    );

    expect(find.text(""), findsOneWidget);
  });

  testWidgets('Removes trailing zeros from value', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NumericOutput(
              label: 'Output',
              value: 24.000000,
            ),
          ),
        )
    );

    expect(find.text("24"), findsOneWidget);
  });
}