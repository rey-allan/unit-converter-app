import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// There is currently no way to control the orientation of the device
// programmatically, so no driver tests can be created to test the behavior
// of changes between these two orientations, e.g. input values being persisted.
// See: https://github.com/flutter/flutter/issues/10307
// See: https://github.com/flutter/flutter/issues/6380
// See: https://github.com/flutter/flutter/issues/6381

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
    await _selectCategory(driver, 'Time');
    await _enterNumber(driver, 60.0);

    await driver.tap(find.byValueKey('driver-from-dropdown'));
    await driver.tap(find.text('Minute'));

    // The conversion happens from 'Minutes' to 'Seconds': 60 min => 3600 sec
    await _validateOutputEquals(driver, '3600');
  });

  test('User can change the "To" conversion unit', () async {
    await _selectCategory(driver, 'Digital Storage');
    await _enterNumber(driver, 10.0);

    await driver.tap(find.byValueKey('driver-to-dropdown'));
    await driver.tap(find.text('Kilobyte'));

    // The conversion happens from 'Megabyte' to 'Kilobyte': 10 MB => 10,000 KB
    await _validateOutputEquals(driver, '10000');
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
