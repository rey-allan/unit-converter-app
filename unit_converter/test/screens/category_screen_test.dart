import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_converter/screens/category_screen.dart';
import 'package:unit_converter/screens/converter_screen.dart';
import 'package:unit_converter/widgets/backdrop.dart';

void main() {
  testWidgets('Screen displays a Backdrop', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CategoryScreen(),
      )
    );

    expect(find.byType(Backdrop), findsOneWidget);
  });

  testWidgets('Unit Converter for Length is displayed by default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: CategoryScreen(),
        )
    );

    expect(find.byType(ConverterScreen), findsOneWidget);
    // It should find two widgets with text 'Length': the category in the menu,
    // and the title of the current unit converter screen
    expect(find.text('Length'), findsNWidgets(2));
  });

  // FIXME: Currently being skipped due to `RenderFlex` overflow exception
  testWidgets('Unit Converter is changed when a category is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(
          home: CategoryScreen(),
        )
    );

    // Initially only one widget should exist in the category list
    expect(find.text('Time'), findsOneWidget);

    // First, close the current unit converter screen by tapping the close menu
    await tester.tap(find.byType(IconButton));
    // Wait for all animations to finish
    await tester.pumpAndSettle();

    // Now, tap the 'Time' category and wait for all animations to finish
    await tester.tap(find.text('Time'));
    await tester.pumpAndSettle();

    expect(find.byType(ConverterScreen), findsOneWidget);
    // Now, it should find two widgets with text 'Time': the category in the
    // menu, and the title of the new unit converter screen
    expect(find.text('Time'), findsNWidgets(2));
  }, skip: true);
}
