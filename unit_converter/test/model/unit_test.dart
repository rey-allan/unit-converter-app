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

  test('Units are sortable by name', () {
    final units = <Unit>[
      Unit(name: 'Length', conversion: 1.0),
      Unit(name: 'Currency', conversion: 1.0),
      Unit(name: 'Mass', conversion: 1.0),
    ];

    units.sort();

    expect(units[0].name, equals('Currency'));
    expect(units[1].name, equals('Length'));
    expect(units[2].name, equals('Mass'));
  });
}