import 'dart:math' as math;

import 'package:dallala/core/theme/app_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.x contrast ratio.
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) => v <= 0.03928
        ? v / 12.92
        : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final la = lum(a), lb = lum(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

void main() {
  for (final (name, c) in [
    ('light', AppColors.light),
    ('dark', AppColors.dark),
  ]) {
    group('$name theme text pairs meet 4.5:1', () {
      final pairs = <String, (Color fg, Color bg)>{
        'ink / sand': (c.ink, c.sand),
        'ink / surface': (c.ink, c.surface),
        'ink / sand-deep': (c.ink, c.sandDeep),
        'ink-muted / sand': (c.inkMuted, c.sand),
        'ink-muted / surface': (c.inkMuted, c.surface),
        'ink-muted / sand-deep': (c.inkMuted, c.sandDeep),
        'on-terracotta / terracotta': (c.onTerracotta, c.terracotta),
        'on-terracotta / terracotta-press': (c.onTerracotta, c.terracottaPress),
        'terracotta (price) / surface': (c.terracotta, c.surface),
        'terracotta / sand': (c.terracotta, c.sand),
        'terracotta / terracotta-soft': (c.terracotta, c.terracottaSoft),
        'on-gum / gum': (c.onGum, c.gum),
        'gum-text / gum-soft': (c.gumText, c.gumSoft),
        'acacia / acacia-soft': (c.acacia, c.acaciaSoft),
        'on-acacia / acacia': (c.onAcacia, c.acacia),
        'danger / danger-soft': (c.danger, c.dangerSoft),
        'danger / surface': (c.danger, c.surface),
        'on-header / header': (c.onHeaderInk, c.headerInk),
        'sand / ink (snackbar)': (c.sand, c.ink),
      };
      pairs.forEach((label, pair) {
        test(label, () {
          expect(contrast(pair.$1, pair.$2), greaterThanOrEqualTo(4.5));
        });
      });
    });
  }
}
