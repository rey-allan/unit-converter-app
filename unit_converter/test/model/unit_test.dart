import 'package:test/test.dart';

import 'package:unit_converter/model/unit.dart';

void main() {
  test('fromJson creates the correct Unit instance', () {
    final Map json = {
      'name': 'MyUnit',
      'conversion': 24.0,
    };

    final Unit convertedUnit = Unit.fromJson(json);

    expect(convertedUnit.name, equals('MyUnit'));
    expect(convertedUnit.conversion, equals(24.0));
  });
}