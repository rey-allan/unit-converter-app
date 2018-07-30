import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/model/category.dart';
import 'package:unit_converter/model/unit.dart';
import 'package:unit_converter/screens/converter_screen.dart';
import 'package:unit_converter/widgets/converter/dropdown.dart';
import 'package:unit_converter/widgets/converter/numeric_input.dart';
import 'package:unit_converter/widgets/converter/numeric_output.dart';

void main() {
  final List<Unit> units = <Unit>[
    Unit(name: 'Unit 1', conversion: 1.0),
    Unit(name: 'Unit 2', conversion: 2.0),
    Unit(name: 'Unit 3', conversion: 3.0),
  ];

  testWidgets('Screen displays an input/output group with arrows',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ConverterScreen(
          category: Category(
            name: 'Length',
            color: Colors.blueAccent,
            units: units,
            iconLocation: 'assets/icon/length.png',
          ),
        ),
      ),
    ));

    expect(find.byType(NumericInput), findsOneWidget);
    expect(find.byType(NumericOutput), findsOneWidget);
    expect(find.byType(Dropdown), findsNWidgets(2));
    expect(find.byIcon(Icons.compare_arrows), findsOneWidget);
  });

  testWidgets('Input is converted when changed with default units',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ConverterScreen(
          category: Category(
            name: 'Length',
            color: Colors.blueAccent,
            units: units,
            iconLocation: 'assets/icon/length.png',
          ),
        ),
      ),
    ));

    NumericOutput output = tester.widget(find.byType(NumericOutput));
    expect(output.value, isNull);

    await tester.enterText(find.byType(NumericInput), '24');
    await tester.pump();

    output = tester.widget(find.byType(NumericOutput));
    // The conversion happens using the default 'Unit 1'
    expect(output.value, equals(24.0));
  });

  testWidgets('Input is converted when "From" unit is changed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ConverterScreen(
          category: Category(
            name: 'Length',
            color: Colors.blueAccent,
            units: units,
            iconLocation: 'assets/icon/length.png',
          ),
        ),
      ),
    ));

    NumericOutput output = tester.widget(find.byType(NumericOutput));
    expect(output.value, isNull);

    await tester.enterText(find.byType(NumericInput), '24');
    await tester.pump();

    // Tap the 'From' dropdown from the input group to open the menu
    // This dropdown should be the first available widget
    await tester.tap(find.byType(Dropdown).first);
    await tester.pump();
    // Change to 'Unit 2' option
    await tester.tap(find.text('Unit 2').last);
    await tester.pump();

    output = tester.widget(find.byType(NumericOutput));
    // The conversion happens from 'Unit 2' to 'Unit 1', so the value is halved
    expect(output.value, equals(12.0));
  });

  testWidgets('Input is converted when "To" unit is changed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Material(
        child: ConverterScreen(
          category: Category(
            name: 'Length',
            color: Colors.blueAccent,
            units: units,
            iconLocation: 'assets/icon/length.png',
          ),
        ),
      ),
    ));

    NumericOutput output = tester.widget(find.byType(NumericOutput));
    expect(output.value, isNull);

    await tester.enterText(find.byType(NumericInput), '24');
    await tester.pump();

    // Tap the 'To' dropdown from the output group to open the menu
    // This dropdown should be the last available widget
    await tester.tap(find.byType(Dropdown).last);
    await tester.pump();
    // Change to 'Unit 3' option
    await tester.tap(find.text('Unit 3').last);
    await tester.pump();

    output = tester.widget(find.byType(NumericOutput));
    // The conversion happens from 'Unit 1' to 'Unit 3', so the value is tripled
    expect(output.value, equals(72.0));
  });
}
