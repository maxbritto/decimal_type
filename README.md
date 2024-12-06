Add a `Decimal` type to your Flutter and Dart projects to handle operations on decimal numbers.

## Why

Operation on decimal numbers using the regular `double` type can lead to precision errors.
This is a general issue with floating point numbers, but it can be particularly problematic when working with money.
See https://stackoverflow.com/questions/588004/is-floating-point-math-broken for more information on this issue or https://stackoverflow.com/questions/70693686/double-multiplication-in-dart-gives-unusual-result for a specific example in Dart.

## How does this package work

Internally this package uses the `BigInt` type to store the decimal number as an integer and a regular `int` to count the number of decimal digits.
This way we can do all the computations using integers and only convert to a decimal number when needed in the `toString()` method.

## Getting started

Add the package to your `pubspec.yaml` by typing this value using your terminal in the root of your project:
```bash
dart pub add decimal_type
```

## Usage

Import the package in your Dart file:

```dart
import 'package:decimal_type/decimal_type.dart';
```

Create a new `Decimal` object:

```dart
final value1 = Decimal.fromString('10.5');
final value2 = Decimal.fromDouble(2.351, decimalPrecision: 3);

final sum = value1 + value2;
final difference = value1 - value2;
final product = value1 * value2;
final quotient = value1 / value2;

print(sum); // 12.851
print(difference); // 8.149
print(product); // 24.6855
print(quotient); // 4.46618460229689517860 (capped to 20 decimal digits)
```

## Additional information

When using division or creating a `Decimal` object from a `double`, you can specify the number of decimal digits to keep using the `decimalPrecision` parameter. This parameter defaults to 20 and accepts values between 0 and 20.
