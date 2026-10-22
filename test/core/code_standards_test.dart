import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards spec §13: no hard-coded colours, no left/right, no inline copy.
void main() {
  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.endsWith('.g.dart'))
      .where((f) => !f.path.contains('l10n/generated'))
      // Supplied splash, used as-is.
      .where((f) => !f.path.endsWith('dallala_splash.dart'))
      .toList();

  List<String> violations(RegExp pattern, {bool Function(File)? skip}) => [
        for (final f in files)
          if (skip == null || !skip(f))
            for (final (i, line) in f.readAsLinesSync().indexed)
              if (!line.trimLeft().startsWith('//') && pattern.hasMatch(line))
                '${f.path}:${i + 1}: ${line.trim()}',
      ];

  test('colours are only defined in lib/core/theme', () {
    expect(
      violations(
        RegExp(r'\bColor\(0x|Colors\.(?!transparent)\w+'),
        skip: (f) => f.path.contains('lib/core/theme/'),
      ),
      isEmpty,
    );
  });

  test('layout uses directional APIs, never left/right', () {
    expect(
      violations(
        RegExp(
          r'EdgeInsets\.(only|fromLTRB)\(|Alignment\.(centerLeft|centerRight|topLeft|topRight|bottomLeft|bottomRight)'
          r'|\bPositioned\([^)]*\b(left|right):|TextAlign\.(left|right)\b|BorderRadius\.only\(',
        ),
      ),
      isEmpty,
    );
  });

  test('no Arabic copy outside app_ar.arb', () {
    expect(
      violations(
        RegExp(r'[؀-ۿ]'),
        // Digit/currency tables live in the formatter by design.
        skip: (f) => f.path.endsWith('core/utils/formatters.dart'),
      ),
      isEmpty,
    );
  });
}
