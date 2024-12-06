class Decimal implements Comparable<Decimal> {
  final BigInt _value;
  final int decimalPrecision;

  const Decimal(this._value, {required this.decimalPrecision});

  /// Create a Decimal from an integer value
  factory Decimal.fromInt(int value) {
    return Decimal(BigInt.from(value), decimalPrecision: 0);
  }

  /// Create a Decimal from a string value
  factory Decimal.fromString(String value) {
    value = value.trim();
    if (value.isEmpty) {
      return Decimal.fromInt(0);
    }
    final parts = value.split('.');
    if (parts.length == 1) {
      return Decimal.fromInt(int.parse(parts[0]));
    }
    if (parts.length > 2) {
      throw ArgumentError.value(value, 'value', 'Invalid number format');
    }
    // parts.length == 2
    final decimalPrecision = parts[1].length;
    final left = BigInt.parse(parts[0]);
    final right = BigInt.parse(parts[1]);
    final absoluteRawValue =
        left.abs() * BigInt.from(10).pow(decimalPrecision) + right.abs();
    return Decimal(value.startsWith("-") ? -absoluteRawValue : absoluteRawValue,
        decimalPrecision: decimalPrecision);
  }

  /// Create a Decimal from a double value
  /// [decimalPrecision] is the number of decimal digits to keep. Default is 20. Accepted values are between 0 and 20. Throws an ArgumentError if the value is not in the accepted range.
  factory Decimal.fromDouble(double value, {int decimalPrecision = 20}) {
    if (decimalPrecision < 0 || decimalPrecision > 20) {
      throw ArgumentError.value(decimalPrecision, 'decimalPrecision',
          'Invalid decimal precision : should be between 0 and 20, received $decimalPrecision');
    }
    final stringValue = value.toStringAsFixed(decimalPrecision);
    return Decimal.fromString(stringValue);
  }

  @override
  String toString() {
    if (decimalPrecision == 0) {
      return _value.toString();
    }
    final stringValue = _value.abs().toString();
    final prefix = _value.isNegative ? '-' : '';
    final length = stringValue.length;
    if (length <= decimalPrecision) {
      return '${prefix}0.${'0' * (decimalPrecision - length)}$stringValue';
    }

    return '$prefix${stringValue.substring(0, length - decimalPrecision)}.${stringValue.substring(length - decimalPrecision)}';
  }

  Decimal operator +(Decimal other) {
    if (decimalPrecision == other.decimalPrecision) {
      return Decimal(_value + other._value, decimalPrecision: decimalPrecision);
    }
    final biggestDecimalPrecision = decimalPrecision > other.decimalPrecision
        ? decimalPrecision
        : other.decimalPrecision;
    final thisValue = _value *
        BigInt.from(10).pow(biggestDecimalPrecision - decimalPrecision);
    final otherValue = other._value *
        BigInt.from(10).pow(biggestDecimalPrecision - other.decimalPrecision);
    return Decimal(thisValue + otherValue,
        decimalPrecision: biggestDecimalPrecision);
  }

  @override
  int compareTo(Decimal other) {
    if (decimalPrecision == other.decimalPrecision) {
      return _value.compareTo(other._value);
    }
    final thisValue = _value * BigInt.from(10).pow(other.decimalPrecision);
    final otherValue = other._value * BigInt.from(10).pow(decimalPrecision);
    return thisValue.compareTo(otherValue);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Decimal) {
      return compareTo(other) == 0;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => _value.hashCode;

  Decimal operator -() {
    return Decimal(-_value, decimalPrecision: decimalPrecision);
  }

  Decimal operator -(Decimal other) {
    if (decimalPrecision == other.decimalPrecision) {
      return Decimal(_value - other._value, decimalPrecision: decimalPrecision);
    }
    final biggestDecimalPrecision = decimalPrecision > other.decimalPrecision
        ? decimalPrecision
        : other.decimalPrecision;
    final thisValue = _value *
        BigInt.from(10).pow(biggestDecimalPrecision - decimalPrecision);
    final otherValue = other._value *
        BigInt.from(10).pow(biggestDecimalPrecision - other.decimalPrecision);
    return Decimal(thisValue - otherValue,
        decimalPrecision: biggestDecimalPrecision);
  }

  Decimal operator *(Decimal other) {
    final newValue = _value * other._value;
    return Decimal(newValue,
        decimalPrecision: decimalPrecision + other.decimalPrecision);
  }

  Decimal operator /(Decimal other) {
    final biggestDecimalPrecision = decimalPrecision > other.decimalPrecision
        ? decimalPrecision
        : other.decimalPrecision;
    final thisValue = _value *
        BigInt.from(10).pow((biggestDecimalPrecision - decimalPrecision) + 1);
    final otherValue = other._value *
        BigInt.from(10)
            .pow((biggestDecimalPrecision - other.decimalPrecision) + 1);

    return Decimal.fromDouble(thisValue / otherValue);
  }

  bool operator <(Decimal other) {
    return compareTo(other) < 0;
  }

  bool operator <=(Decimal other) {
    return compareTo(other) <= 0;
  }

  bool operator >(Decimal other) {
    return compareTo(other) > 0;
  }

  bool operator >=(Decimal other) {
    return compareTo(other) >= 0;
  }
}
