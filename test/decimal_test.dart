import 'package:decimal_type/decimal_type.dart';
import 'package:test/test.dart';

void main() {
  group('Decimal', () {
    group("Parse from String", () {
      test('Parse from String empty value', () {
        expect(Decimal.fromString('').toString(), '0');
      });
      test('Parse from String regular values', () {
        expect(Decimal.fromString('123').toString(), '123');
        expect(Decimal.fromString('123.45').toString(), '123.45');
        expect(Decimal.fromString('123.456').toString(), '123.456');
      });

      test('Parse from String negative values', () {
        expect(Decimal.fromString('-123').toString(), '-123');
        expect(Decimal.fromString('-123.45').toString(), '-123.45');
        expect(Decimal.fromString('-123.456').toString(), '-123.456');
      });
      test('Parse from String 0. values', () {
        expect(Decimal.fromString('0').toString(), '0');
        expect(Decimal.fromString('0.01').toString(), '0.01');
        expect(Decimal.fromString('0.0025').toString(), '0.0025');
        expect(Decimal.fromString('-0').toString(), '0');
        expect(Decimal.fromString('-0.01').toString(), '-0.01');
        expect(Decimal.fromString('-0.0025').toString(), '-0.0025');
      });
      test('Parse from String throws on invalid values', () {
        expect(() => Decimal.fromString('123.45.67'), throwsArgumentError);
        expect(() => Decimal.fromString('abc'), throwsFormatException);
      });
      test('Parse from String fixes leading and trailing blank spaces', () {
        expect(Decimal.fromString(' 123').toString(), '123');
        expect(Decimal.fromString('123 ').toString(), '123');
        expect(Decimal.fromString(' 123 ').toString(), '123');
      });
    });

    group("Parse from Int", () {
      test('Parse from Int regular values', () {
        expect(Decimal.fromInt(123).toString(), '123');
        expect(Decimal.fromInt(12345).toString(), '12345');
      });

      test('Parse from Int negative values', () {
        expect(Decimal.fromInt(-123).toString(), '-123');
        expect(Decimal.fromInt(-12345).toString(), '-12345');
      });
    });

    group("Parse from Double", () {
      test('Parse from Double regular values', () {
        expect(Decimal.fromDouble(123.45, decimalPrecision: 2).toString(),
            '123.45');
        expect(Decimal.fromDouble(123.456, decimalPrecision: 3).toString(),
            '123.456');
        expect(Decimal.fromDouble(123.456, decimalPrecision: 2).toString(),
            '123.46');
      });

      test('Parse from Double negative values', () {
        expect(Decimal.fromDouble(-123.45, decimalPrecision: 2).toString(),
            '-123.45');
        expect(Decimal.fromDouble(-123.456, decimalPrecision: 3).toString(),
            '-123.456');
        expect(Decimal.fromDouble(-123.456, decimalPrecision: 2).toString(),
            '-123.46');
      });

      test('Parse from Double 0. values', () {
        expect(
            Decimal.fromDouble(0.01, decimalPrecision: 2).toString(), '0.01');
        expect(Decimal.fromDouble(0.0025, decimalPrecision: 4).toString(),
            '0.0025');
        expect(
            Decimal.fromDouble(-0.01, decimalPrecision: 2).toString(), '-0.01');
        expect(Decimal.fromDouble(-0.0025, decimalPrecision: 4).toString(),
            '-0.0025');
      });
    });

    group("comparisons", () {
      test('Equality', () {
        expect(Decimal.fromInt(123), Decimal.fromInt(123));
        expect(Decimal.fromInt(-123), Decimal.fromInt(-123));
        expect(Decimal.fromDouble(123.45, decimalPrecision: 2),
            Decimal.fromDouble(123.45, decimalPrecision: 2));
        expect(Decimal.fromDouble(-123.45, decimalPrecision: 2),
            Decimal.fromDouble(-123.45, decimalPrecision: 2));
        expect(Decimal.fromDouble(123.450, decimalPrecision: 3),
            Decimal.fromDouble(123.45, decimalPrecision: 2));
      });

      test('Inequality', () {
        expect(Decimal.fromInt(123) != Decimal.fromInt(456), true);
        expect(Decimal.fromInt(-123) != Decimal.fromInt(123), true);
        expect(Decimal.fromInt(123) != Decimal.fromInt(-123), true);
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) !=
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            true);
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) !=
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            true);
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) !=
                Decimal.fromDouble(12.345, decimalPrecision: 3),
            true);
      });

      test('Less than', () {
        expect(Decimal.fromInt(123) < Decimal.fromInt(456), true);
        expect(Decimal.fromInt(-123) < Decimal.fromInt(123), true);
        expect(
            Decimal.fromString('123.45') < Decimal.fromString('123.46'), true);
        expect(Decimal.fromString('123.45') < Decimal.fromString('123.450'),
            false);
        expect(Decimal.fromString('123.45') < Decimal.fromString('123.4501'),
            true);
      });

      test('Less than or equal', () {
        expect(Decimal.fromInt(123) <= Decimal.fromInt(456), true);
        expect(Decimal.fromInt(-123) <= Decimal.fromInt(123), true);
        expect(
            Decimal.fromString('123.45') <= Decimal.fromString('123.46'), true);
        expect(Decimal.fromString('123.45') <= Decimal.fromString('123.450'),
            true);
        expect(Decimal.fromString('123.45') <= Decimal.fromString('123.4501'),
            true);
      });

      test('Greater than', () {
        expect(Decimal.fromInt(123) > Decimal.fromInt(456), false);
        expect(Decimal.fromInt(-123) > Decimal.fromInt(123), false);
        expect(
            Decimal.fromString('123.45') > Decimal.fromString('123.46'), false);
        expect(Decimal.fromString('123.45') > Decimal.fromString('123.450'),
            false);
        expect(Decimal.fromString('123.45') > Decimal.fromString('123.4501'),
            false);
      });

      test('Greater than or equal', () {
        expect(Decimal.fromInt(123) >= Decimal.fromInt(456), false);
        expect(Decimal.fromInt(-123) >= Decimal.fromInt(123), false);
        expect(Decimal.fromString('123.45') >= Decimal.fromString('123.46'),
            false);
        expect(Decimal.fromString('123.45') >= Decimal.fromString('123.450'),
            true);
        expect(Decimal.fromString('123.45') >= Decimal.fromString('123.4501'),
            false);
      });
    });

    group("operations", () {
      test('Addition integers', () {
        expect(Decimal.fromInt(123) + Decimal.fromInt(456),
            Decimal.fromInt(123 + 456));
        expect(Decimal.fromInt(123) + Decimal.fromInt(-456),
            Decimal.fromInt(123 + -456));
        expect(Decimal.fromInt(-123) + Decimal.fromInt(456),
            Decimal.fromInt(-123 + 456));
        expect(Decimal.fromInt(-123) + Decimal.fromInt(-456),
            Decimal.fromInt(-123 + -456));
      });

      test('Addition doubles', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) +
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(580.23, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) +
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromDouble(-333.33, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) +
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(333.33, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) +
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromDouble(-580.23, decimalPrecision: 2));
      });

      test('Addition doubles with different decimal precision', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) +
                Decimal.fromDouble(456.781, decimalPrecision: 3),
            Decimal.fromDouble(580.231, decimalPrecision: 3));
        expect(
            Decimal.fromDouble(123.451, decimalPrecision: 3) +
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(580.231, decimalPrecision: 3));

        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) +
                Decimal.fromDouble(-456.781, decimalPrecision: 3),
            Decimal.fromDouble(-333.331, decimalPrecision: 3));
        expect(
            Decimal.fromDouble(-123.451, decimalPrecision: 3) +
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(333.329, decimalPrecision: 3));
      });

      test('Subtraction integers', () {
        expect(
            Decimal.fromInt(123) - Decimal.fromInt(456), Decimal.fromInt(-333));
        expect(
            Decimal.fromInt(123) - Decimal.fromInt(-456), Decimal.fromInt(579));
        expect(Decimal.fromInt(-123) - Decimal.fromInt(456),
            Decimal.fromInt(-579));
        expect(Decimal.fromInt(-123) - Decimal.fromInt(-456),
            Decimal.fromInt(333));
      });

      test('Subtraction doubles', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) -
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(-333.33, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) -
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromDouble(580.23, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) -
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(-580.23, decimalPrecision: 2));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) -
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromDouble(333.33, decimalPrecision: 2));
      });

      test('Subtraction doubles with different decimal precision', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) -
                Decimal.fromDouble(456.781, decimalPrecision: 3),
            Decimal.fromDouble(-333.331, decimalPrecision: 3));
        expect(
            Decimal.fromDouble(123.451, decimalPrecision: 3) -
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(-333.329, decimalPrecision: 3));

        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) -
                Decimal.fromDouble(-456.781, decimalPrecision: 3),
            Decimal.fromDouble(580.231, decimalPrecision: 3));
        expect(
            Decimal.fromDouble(-123.451, decimalPrecision: 3) -
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromDouble(-580.231, decimalPrecision: 3));
      });

      test('Multiplication integers', () {
        expect(Decimal.fromInt(123) * Decimal.fromInt(456),
            Decimal.fromInt(123 * 456));
        expect(Decimal.fromInt(123) * Decimal.fromInt(-456),
            Decimal.fromInt(123 * -456));
        expect(Decimal.fromInt(-123) * Decimal.fromInt(456),
            Decimal.fromInt(-123 * 456));
        expect(Decimal.fromInt(-123) * Decimal.fromInt(-456),
            Decimal.fromInt(-123 * -456));
      });

      test('Multiplication doubles', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) *
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromString("56389.491"));
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) *
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromString("-56389.491"));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) *
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromString("-56389.491"));
        expect(
            Decimal.fromDouble(-123.45, decimalPrecision: 2) *
                Decimal.fromDouble(-456.78, decimalPrecision: 2),
            Decimal.fromString("56389.491"));
      });

      test('Multiplication doubles with different decimal precision', () {
        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) *
                Decimal.fromDouble(456.781, decimalPrecision: 3),
            Decimal.fromString("56389.61445"));
        expect(
            Decimal.fromDouble(123.451, decimalPrecision: 3) *
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromString("56389.94778"));

        expect(
            Decimal.fromDouble(123.45, decimalPrecision: 2) *
                Decimal.fromDouble(-456.781, decimalPrecision: 3),
            Decimal.fromString("-56389.61445"));
        expect(
            Decimal.fromDouble(-123.451, decimalPrecision: 3) *
                Decimal.fromDouble(456.78, decimalPrecision: 2),
            Decimal.fromString("-56389.94778"));
      });

      test('Division integers', () {
        expect(Decimal.fromInt(50) / Decimal.fromInt(2), Decimal.fromInt(25));
        expect(Decimal.fromInt(-50) / Decimal.fromInt(2), Decimal.fromInt(-25));
        expect(Decimal.fromInt(50) / Decimal.fromInt(-2), Decimal.fromInt(-25));
        expect(Decimal.fromInt(-50) / Decimal.fromInt(-2), Decimal.fromInt(25));

        expect(Decimal.fromInt(5) / Decimal.fromInt(2),
            Decimal.fromDouble(2.5, decimalPrecision: 2));
        expect(Decimal.fromInt(-5) / Decimal.fromInt(2),
            Decimal.fromDouble(-2.5, decimalPrecision: 2));
        expect(Decimal.fromInt(5) / Decimal.fromInt(-2),
            Decimal.fromDouble(-2.5, decimalPrecision: 2));
        expect(Decimal.fromInt(-5) / Decimal.fromInt(-2),
            Decimal.fromDouble(2.5, decimalPrecision: 2));
      });

      test('Division doubles', () {
        expect(
            Decimal.fromDouble(50.10, decimalPrecision: 1) /
                Decimal.fromDouble(2.1, decimalPrecision: 1),
            Decimal.fromString("23.85714285714285765039"));
        expect(
            Decimal.fromDouble(-50.10, decimalPrecision: 1) /
                Decimal.fromDouble(2.1, decimalPrecision: 1),
            Decimal.fromString("-23.85714285714285765039"));
        expect(
            Decimal.fromDouble(50.10, decimalPrecision: 1) /
                Decimal.fromDouble(-2.1, decimalPrecision: 1),
            Decimal.fromString("-23.85714285714285765039"));
        expect(
            Decimal.fromDouble(-50.10, decimalPrecision: 1) /
                Decimal.fromDouble(-2.1, decimalPrecision: 1),
            Decimal.fromString("23.85714285714285765039"));
      });

      test('Division doubles with different decimal precision', () {
        expect(
            Decimal.fromDouble(50.10, decimalPrecision: 1) /
                Decimal.fromDouble(2.11, decimalPrecision: 2),
            Decimal.fromString("23.74407582938388472371"));
      });
    });

    group("toString", () {
      test('toString with extra trailing zeros', () {
        expect(Decimal.fromDouble(123.45, decimalPrecision: 3).toString(),
            '123.45');
        expect(Decimal.fromDouble(-123.45, decimalPrecision: 3).toString(),
            '-123.45');
        expect(Decimal.fromDouble(123.405, decimalPrecision: 3).toString(),
            '123.405');
        expect(
            Decimal.fromDouble(123.000, decimalPrecision: 3).toString(), '123');
      });
    });
  });
}
