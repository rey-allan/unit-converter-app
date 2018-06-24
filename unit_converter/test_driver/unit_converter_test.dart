import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    // Connects to the app
    driver = await FlutterDriver.connect();
  });

  setUp(() async {
    // Make sure the user is on the main screen
    await driver.waitFor(find.byType('CategoryScreen'));
  });

  tearDownAll(() async {
    if (driver != null) {
      // Closes the connection
      driver.close();
    }
  });

  tearDown(() async {
    // Be sure to return to the main screen
    await driver.tap(find.byType('BackButton'));
  });

  test('User can select a category by tapping', () async {
    await driver.tap(find.text('Mass'));

    // User should have navigated to the [ConverterScreen] with title 'Mass'
    await driver.waitFor(find.byType('ConverterScreen'));
    await driver.waitFor(find.text('Mass'));
  });

  test('User can convert a number by entering it as input', () async {
    await _selectCategory(driver, 'Length');
    await _enterNumber(driver, 24.0);

    // Input should have been converted with the default 1-1 conversion
    await _validateOutputEquals(driver, '24');
  });

  test('User can change the "From" conversion unit', () async {
    await _selectCategory(driver, 'Area');
    await _enterNumber(driver, 24.0);

    await driver.tap(find.byValueKey('driver-from-dropdown'));
    await driver.tap(find.text('Area Unit 2'));

    // The conversion happens from 'Unit 2' to 'Unit 1', so the value is halved
    await _validateOutputEquals(driver, '12');
  });

  test('User can change the "To" conversion unit', () async {
    await _selectCategory(driver, 'Volume');
    await _enterNumber(driver, 24.0);

    await driver.tap(find.byValueKey('driver-to-dropdown'));
    await driver.tap(find.text('Volume Unit 3'));

    // The conversion happens from 'Unit 1' to 'Unit 3', so the value is tripled
    await _validateOutputEquals(driver, '72');
  });
}

Future<Null> _selectCategory(FlutterDriver driver, String category) async {
  await driver.tap(find.text(category));
  // Make sure the user has navigated to the converter screen
  await driver.waitFor(find.byType('ConverterScreen'));
}

Future<Null> _enterNumber(FlutterDriver driver, double number) async {
  // Tap the input text field so that it gets "focus" before entering text
  await driver.tap(find.byType('NumericInput'));
  await driver.enterText(number.toString());
}

Future<Null> _validateOutputEquals(FlutterDriver driver, String output) async {
  final String converted = await driver.getText(
      find.byValueKey('driver-numeric-output')
  );

  expect(converted, equals(output));
}
