import 'package:dallala/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatNumberAr', () {
    test('uses Eastern Arabic digits and the ٬ separator', () {
      expect(formatNumberAr(0), '٠');
      expect(formatNumberAr(999), '٩٩٩');
      expect(formatNumberAr(1000), '١٬٠٠٠');
      expect(formatNumberAr(45000), '٤٥٬٠٠٠');
      expect(formatNumberAr(45000000), '٤٥٬٠٠٠٬٠٠٠');
      expect(formatNumberAr(123456), '١٢٣٬٤٥٦');
    });

    test('supports negatives, decimals and no grouping', () {
      expect(formatNumberAr(-12000), '-١٢٬٠٠٠');
      expect(formatNumberAr(2.5, decimals: 1), '٢٫٥');
      expect(formatNumberAr(2018, grouping: false), '٢٠١٨');
    });
  });

  test('formatPrice writes the currency after the number', () {
    expect(formatPrice(45000), '٤٥٬٠٠٠ ج.س');
    expect(formatPrice(12000), '١٢٬٠٠٠ ج.س');
  });

  test('formatSignedPrice prefixes credits and debits', () {
    expect(formatSignedPrice(5000), '+٥٬٠٠٠ ج.س');
    expect(formatSignedPrice(-12000), '-١٢٬٠٠٠ ج.س');
  });

  test('formatCounterAr renders gallery counters', () {
    expect(formatCounterAr(1, 6), '١ / ٦');
  });

  test('toEasternDigits leaves other characters untouched', () {
    expect(toEasternDigits('+249 912'), '+٢٤٩ ٩١٢');
  });
}
