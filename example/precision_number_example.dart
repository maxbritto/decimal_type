import 'package:decimal_type/decimal_type.dart';

void main() {
  // Create a PrecisionNumber from a String
  final number1 = Decimal.fromString('123.456');
  final number2 = Decimal.fromString('789.012');
  final sum = number1 + number2;
  print(sum); // 912.468

  // Create a PrecisionNumber from a double
  final number3 = Decimal.fromDouble(123.456, decimalPrecision: 3);
  final number4 = Decimal.fromDouble(789.012, decimalPrecision: 3);
  final sum2 = number3 + number4;
  print(sum2); // 912.468
}
