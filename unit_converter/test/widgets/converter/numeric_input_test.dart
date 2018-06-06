import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/widgets/converter/numeric_input.dart';

void main() {
  testWidgets('Displays a TextField with a label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: NumericInput(
            label: 'Input',
            onChangeHandler: (value) => print('Value: $value'),
          ),
        ),
      )
    );

    expect(find.byType(TextField), findsOneWidget);

    final TextField textField = tester.widget(find.byType(TextField));
    final InputDecoration inputDecoration = textField.decoration;

    expect(inputDecoration.labelText, equals('Input'));
  });

  testWidgets('Handler is called on valid input change',
      (WidgetTester tester) async {
    double receivedValue = 0.0;

    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NumericInput(
              label: 'Input',
              onChangeHandler: (value) => receivedValue = value,
            ),
          ),
        )
    );

    expect(receivedValue, equals(0.0));

    await tester.enterText(find.byType(TextField), '24.0');
    await tester.pump();

    expect(receivedValue, equals(24.0));
  });

  testWidgets('Handler is not called on invalid input change',
      (WidgetTester tester) async {
    double receivedValue = 0.0;

    await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: NumericInput(
              label: 'Input',
              onChangeHandler: (value) => receivedValue = value,
            ),
          ),
        )
    );

    expect(receivedValue, equals(0.0));

    await tester.enterText(find.byType(TextField), ',');
    await tester.pump();

    expect(receivedValue, equals(0.0));
  });

  testWidgets('Widget displays error text with invalid input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: NumericInput(
            label: 'Input',
            onChangeHandler: (value) => print('Value: $value'),
          ),
        ),
      )
    );

    TextField textField = tester.widget(find.byType(TextField));
    InputDecoration inputDecoration = textField.decoration;

    expect(inputDecoration.errorText, equals(null));

    await tester.enterText(find.byType(TextField), ',');
    await tester.pump();

    textField = tester.widget(find.byType(TextField));
    inputDecoration = textField.decoration;

    expect(inputDecoration.errorText, equals('Invalid number'));
  });

  testWidgets('Widget does not display error text with empty input',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: NumericInput(
            label: 'Input',
            onChangeHandler: (value) => print('Value: $value'),
          ),
        ),
      )
    );

    // First enter an invalid number
    await tester.enterText(find.byType(TextField), ',');
    await tester.pump();

    // Then simulate erasing the invalid number
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();

    TextField textField = tester.widget(find.byType(TextField));
    InputDecoration inputDecoration = textField.decoration;

    expect(inputDecoration.errorText, equals(null));
  });
}