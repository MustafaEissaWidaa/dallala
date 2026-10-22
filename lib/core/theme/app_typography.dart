import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppFonts {
  /// Headings, prices and large numbers.
  static const String display = 'Readex Pro';

  /// Body and UI.
  static const String body = 'IBM Plex Sans Arabic';
}

/// Dallala type scale (spec §4), already coloured for the active theme.
@immutable
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.display,
    required this.titleLg,
    required this.title,
    required this.price,
    required this.bodyLg,
    required this.body,
    required this.label,
    required this.caption,
  });

  /// 34/42 · 700 · Readex Pro
  final TextStyle display;

  /// 24/32 · 700 · Readex Pro
  final TextStyle titleLg;

  /// 18/26 · 600
  final TextStyle title;

  /// 20/26 · 700 · Readex Pro · terracotta
  final TextStyle price;

  /// 16/26 · 400
  final TextStyle bodyLg;

  /// 14/22 · 400
  final TextStyle body;

  /// 14/20 · 600
  final TextStyle label;

  /// 12/18 · 500
  final TextStyle caption;

  factory AppTextStyles.from(AppColors c) {
    TextStyle s(
      String family,
      double size,
      double lineHeight,
      FontWeight weight,
      Color color,
    ) =>
        TextStyle(
          fontFamily: family,
          fontSize: size,
          height: lineHeight / size,
          fontWeight: weight,
          color: color,
          leadingDistribution: TextLeadingDistribution.even,
        );

    return AppTextStyles(
      display: s(AppFonts.display, 34, 42, FontWeight.w700, c.ink),
      titleLg: s(AppFonts.display, 24, 32, FontWeight.w700, c.ink),
      title: s(AppFonts.body, 18, 26, FontWeight.w600, c.ink),
      price: s(AppFonts.display, 20, 26, FontWeight.w700, c.terracotta),
      bodyLg: s(AppFonts.body, 16, 26, FontWeight.w400, c.ink),
      body: s(AppFonts.body, 14, 22, FontWeight.w400, c.ink),
      label: s(AppFonts.body, 14, 20, FontWeight.w600, c.ink),
      caption: s(AppFonts.body, 12, 18, FontWeight.w500, c.inkMuted),
    );
  }

  @override
  AppTextStyles copyWith() => this;

  @override
  AppTextStyles lerp(ThemeExtension<AppTextStyles>? other, double t) {
    if (other is! AppTextStyles) return this;
    TextStyle l(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return AppTextStyles(
      display: l(display, other.display),
      titleLg: l(titleLg, other.titleLg),
      title: l(title, other.title),
      price: l(price, other.price),
      bodyLg: l(bodyLg, other.bodyLg),
      body: l(body, other.body),
      label: l(label, other.label),
      caption: l(caption, other.caption),
    );
  }
}
