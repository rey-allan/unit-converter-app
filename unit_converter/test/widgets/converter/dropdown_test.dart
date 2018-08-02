import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/widgets/converter/dropdown.dart';

void main() {
  testWidgets('Displays a dropdown with units', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Dropdown(
              units: <Unit>[
                Unit(name: 'Celsius', conversion: 1.0),
                Unit(name: 'Fahrenheit', conversion: 2.0),
              ],
              onChangeHandler: (unit) => print('Unit: ${unit.name}'),
            ),
          ),
        )
    );

    expect(find.byType(DropdownButton), findsOneWidget);
    expect(find.byType(DropdownMenuItem), findsNWidgets(2));
  });

  testWidgets('Handler is called on selecting', (WidgetTester tester) async {
    Unit receivedUnit;

    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Dropdown(
              units: <Unit>[
                Unit(name: 'Celsius', conversion: 1.0),
                Unit(name: 'Fahrenheit', conversion: 2.0),
              ],
              onChangeHandler: (unit) => receivedUnit = unit,
            ),
          ),
        )
    );

    expect(receivedUnit, isNull);

    // Tap the dropdown to open the menu
    await tester.tap(find.byType(DropdownButton));
    await tester.pump();
    // Then tap the `Celsius` option
    await tester.tap(find.text('Celsius').last);
    await tester.pump();

    expect(receivedUnit.name, equals('Celsius'));
    expect(receivedUnit.conversion, equals(1.0));
  });
}