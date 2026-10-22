/// Number formatting for the app UI (spec §13): Eastern Arabic digits with
/// the Arabic thousands separator `٬` (U+066C). Implemented by hand so the
/// output never depends on the CLDR numbering system shipped with `intl`.
library;

const String _easternDigits = '٠١٢٣٤٥٦٧٨٩';
const String arabicThousandsSeparator = '٬';
const String arabicDecimalSeparator = '٫';

/// Sudanese pound suffix, written after the number.
const String currencySuffixAr = 'ج.س';

/// Converts every Latin digit in [input] to its Eastern Arabic form.
String toEasternDigits(String input) {
  final out = StringBuffer();
  for (final unit in input.codeUnits) {
    if (unit >= 0x30 && unit <= 0x39) {
      out.write(_easternDigits[unit - 0x30]);
    } else {
      out.writeCharCode(unit);
    }
  }
  return out.toString();
}

/// `45000` → `٤٥٬٠٠٠`. Pass [grouping] = false for years, phone parts, etc.
String formatNumberAr(num value, {int decimals = 0, bool grouping = true}) {
  final negative = value < 0;
  final fixed = value.abs().toStringAsFixed(decimals);
  final parts = fixed.split('.');
  var whole = parts[0];
  if (grouping && whole.length > 3) {
    final b = StringBuffer();
    final lead = whole.length % 3;
    if (lead > 0) b.write(whole.substring(0, lead));
    for (var i = lead; i < whole.length; i += 3) {
      if (b.isNotEmpty) b.write(arabicThousandsSeparator);
      b.write(whole.substring(i, i + 3));
    }
    whole = b.toString();
  }
  final body = parts.length > 1
      ? '$whole$arabicDecimalSeparator${parts[1]}'
      : whole;
  return toEasternDigits(negative ? '-$body' : body);
}

/// Whole Sudanese pounds → `٤٥٬٠٠٠ ج.س`.
String formatPrice(int amount) => '${formatNumberAr(amount)} $currencySuffixAr';

/// Signed amount for wallet history: `+٥٬٠٠٠ ج.س` / `-١٢٬٠٠٠ ج.س`.
String formatSignedPrice(int amount) {
  final sign = amount > 0 ? '+' : (amount < 0 ? '-' : '');
  return '$sign${formatPrice(amount.abs())}';
}

/// Page counter for galleries: `١ / ٦`.
String formatCounterAr(int current, int total) =>
    '${formatNumberAr(current)} / ${formatNumberAr(total)}';
