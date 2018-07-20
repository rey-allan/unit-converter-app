import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    // Connects to the app
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      // Closes the connection
      driver.close();
    }
  });

  test('Unit Converter is displayed on start', () async {
    await driver.waitFor(find.byType('ConverterScreen'));
  });

  test('User can select a category by tapping', () async {
    await _selectCategory(driver, 'Mass');
  });

  test('User can convert a number by entering it as input', () async {
    await _selectCategory(driver, 'Length');
    await _enterNumber(driver, 24.0);

    // Input should have been converted with the default 1-1 conversion
    await _validateOutputEquals(driver, '24');
  });

  test('User can change the "From" conversion unit', () async {
    await _selectCategory(driver, 'Area');
    await _enterNumber(driver, 34.0);

    await driver.tap(find.byValueKey('driver-from-dropdown'));
    await driver.tap(find.text('Area Unit 2'));

    // The conversion happens from 'Unit 2' to 'Unit 1', so the value is halved
    await _validateOutputEquals(driver, '17');
  });

  test('User can change the "To" conversion unit', () async {
    await _selectCategory(driver, 'Volume');
    await _enterNumber(driver, 10.0);

    await driver.tap(find.byValueKey('driver-to-dropdown'));
    await driver.tap(find.text('Volume Unit 3'));

    // The conversion happens from 'Unit 1' to 'Unit 3', so the value is tripled
    await _validateOutputEquals(driver, '30');
  });
}

Future<Null> _selectCategory(FlutterDriver driver, String category) async {
  // Make sure to close the front panel
  await driver.tap(find.byType("IconButton"));
  // Now, tap the `category`
  await driver.tap(find.text(category));
  // Make sure the user has navigated to the [ConverterScreen]
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
