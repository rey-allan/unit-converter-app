import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';
import 'package:unit_converter/infrastructure/currency_provider_impl.dart';
import 'package:unit_converter/model/unit.dart';

void main() {
  group('getUnits', () {
    test('returns units on successful response', () async {
      final json = '{"results":{"USD":{"name":"USD"}, "MXN":{"name":"MXN"}}}';
      final httpClient =
          MockClient((request) => Future.value(http.Response(json, 200)));

      final units =
          await CurrencyProviderImpl(httpClient: httpClient).getUnits();

      expect(units.length, equals(2));
      expect(units[0].name, equals('MXN'));
      expect(units[1].name, equals('USD'));
    });

    test('throws exception on unsuccessful response', () {
      final httpClient =
          MockClient((request) => Future.value(http.Response('{}', 501)));

      expect(CurrencyProviderImpl(httpClient: httpClient).getUnits(),
          throwsException);
    });
  });

  group('convert', () {
    final Unit from = Unit(name: 'USD', conversion: 1.0);
    final Unit to = Unit(name: 'MXN', conversion: 1.0);

    test('returns converted value on successful response', () async {
      final json = '{"USD_MXN":18.0}';
      final httpClient =
          MockClient((request) => Future.value(http.Response(json, 200)));

      final value = await CurrencyProviderImpl(httpClient: httpClient)
          .convert(from, to, 500.0);

      // 500.0 * 18.0 (conversion rate)
      expect(value, equals(9000.0));
    });

    test('throws exception on unsuccessful response', () {
      final httpClient =
          MockClient((request) => Future.value(http.Response('{}', 501)));

      expect(
          CurrencyProviderImpl(httpClient: httpClient).convert(from, to, 1.0),
          throwsException);
    });
  });
}
