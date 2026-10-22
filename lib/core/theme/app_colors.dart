import 'package:flutter/material.dart';

/// Dallala colour tokens (spec §4). Screens must read colours from here via
/// `context.colors` — never hard-code a [Color] inside a screen or widget.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.sand,
    required this.surface,
    required this.sandDeep,
    required this.line,
    required this.ink,
    required this.inkMuted,
    required this.terracotta,
    required this.terracottaPress,
    required this.terracottaSoft,
    required this.onTerracotta,
    required this.gum,
    required this.onGum,
    required this.gumSoft,
    required this.gumText,
    required this.acacia,
    required this.acaciaSoft,
    required this.onAcacia,
    required this.danger,
    required this.dangerSoft,
    required this.headerInk,
    required this.onHeaderInk,
    required this.placeholderTerracotta,
    required this.placeholderTerracottaIcon,
    required this.placeholderEarth,
    required this.placeholderEarthIcon,
    required this.placeholderOlive,
    required this.placeholderOliveIcon,
    required this.shadow,
  });

  final Color sand;
  final Color surface;
  final Color sandDeep;
  final Color line;
  final Color ink;
  final Color inkMuted;
  final Color terracotta;
  final Color terracottaPress;
  final Color terracottaSoft;

  /// Text/icons drawn on a terracotta fill.
  final Color onTerracotta;
  final Color gum;

  /// Text drawn on a gum fill (always dark, spec §4).
  final Color onGum;
  final Color gumSoft;
  final Color gumText;
  final Color acacia;
  final Color acaciaSoft;

  /// Text/icons drawn on an acacia fill.
  final Color onAcacia;
  final Color danger;
  final Color dangerSoft;

  /// Dark header (profile) and admin sidebar background, and its foreground.
  final Color headerInk;
  final Color onHeaderInk;

  /// Listing placeholder backgrounds (no photo) and their thin-stroke icon.
  final Color placeholderTerracotta;
  final Color placeholderTerracottaIcon;
  final Color placeholderEarth;
  final Color placeholderEarthIcon;
  final Color placeholderOlive;
  final Color placeholderOliveIcon;

  /// Base colour for soft card shadows.
  final Color shadow;

  static const light = AppColors(
    sand: Color(0xFFFBF6EE),
    surface: Color(0xFFFFFFFF),
    sandDeep: Color(0xFFF2E9DB),
    line: Color(0xFFE8DDCD),
    ink: Color(0xFF231A12),
    inkMuted: Color(0xFF6E5F50),
    terracotta: Color(0xFFB8431A),
    terracottaPress: Color(0xFF9C3812),
    terracottaSoft: Color(0xFFFDEDE4),
    onTerracotta: Color(0xFFFFFFFF),
    gum: Color(0xFFE9A23B),
    onGum: Color(0xFF231A12),
    gumSoft: Color(0xFFFCEFD6),
    gumText: Color(0xFF8A5A0B),
    acacia: Color(0xFF1E6B50),
    acaciaSoft: Color(0xFFDDF0E6),
    onAcacia: Color(0xFFFFFFFF),
    danger: Color(0xFFB42318),
    dangerSoft: Color(0xFFFDE8E6),
    headerInk: Color(0xFF231A12),
    onHeaderInk: Color(0xFFFBF6EE),
    placeholderTerracotta: Color(0xFFF0DCCB),
    placeholderTerracottaIcon: Color(0xFFB8431A),
    placeholderEarth: Color(0xFFEDE3D6),
    placeholderEarthIcon: Color(0xFF6E4A2E),
    placeholderOlive: Color(0xFFE6E4CC),
    placeholderOliveIcon: Color(0xFF5B5A2E),
    shadow: Color(0xFF231A12),
  );

  static const dark = AppColors(
    sand: Color(0xFF16130F),
    surface: Color(0xFF211C17),
    sandDeep: Color(0xFF2B241E),
    line: Color(0xFF3A3129),
    ink: Color(0xFFF5EDE2),
    inkMuted: Color(0xFFB8A895),
    terracotta: Color(0xFFF08A5D),
    terracottaPress: Color(0xFFF4A27C),
    terracottaSoft: Color(0xFF4A1E0E),
    onTerracotta: Color(0xFF16130F),
    gum: Color(0xFFF2B85B),
    onGum: Color(0xFF16130F),
    gumSoft: Color(0xFF3D2C10),
    gumText: Color(0xFFF2B85B),
    acacia: Color(0xFF5CC79A),
    acaciaSoft: Color(0xFF10301F),
    onAcacia: Color(0xFF16130F),
    danger: Color(0xFFF97066),
    dangerSoft: Color(0xFF3F1512),
    headerInk: Color(0xFF2B241E),
    onHeaderInk: Color(0xFFF5EDE2),
    placeholderTerracotta: Color(0xFF3A2218),
    placeholderTerracottaIcon: Color(0xFFF08A5D),
    placeholderEarth: Color(0xFF2E261F),
    placeholderEarthIcon: Color(0xFFCFAE8F),
    placeholderOlive: Color(0xFF2A2A1C),
    placeholderOliveIcon: Color(0xFFBDBB84),
    shadow: Color(0xFF000000),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      sand: l(sand, other.sand),
      surface: l(surface, other.surface),
      sandDeep: l(sandDeep, other.sandDeep),
      line: l(line, other.line),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      terracotta: l(terracotta, other.terracotta),
      terracottaPress: l(terracottaPress, other.terracottaPress),
      terracottaSoft: l(terracottaSoft, other.terracottaSoft),
      onTerracotta: l(onTerracotta, other.onTerracotta),
      gum: l(gum, other.gum),
      onGum: l(onGum, other.onGum),
      gumSoft: l(gumSoft, other.gumSoft),
      gumText: l(gumText, other.gumText),
      acacia: l(acacia, other.acacia),
      acaciaSoft: l(acaciaSoft, other.acaciaSoft),
      onAcacia: l(onAcacia, other.onAcacia),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      headerInk: l(headerInk, other.headerInk),
      onHeaderInk: l(onHeaderInk, other.onHeaderInk),
      placeholderTerracotta:
          l(placeholderTerracotta, other.placeholderTerracotta),
      placeholderTerracottaIcon:
          l(placeholderTerracottaIcon, other.placeholderTerracottaIcon),
      placeholderEarth: l(placeholderEarth, other.placeholderEarth),
      placeholderEarthIcon: l(placeholderEarthIcon, other.placeholderEarthIcon),
      placeholderOlive: l(placeholderOlive, other.placeholderOlive),
      placeholderOliveIcon: l(placeholderOliveIcon, other.placeholderOliveIcon),
      shadow: l(shadow, other.shadow),
    );
  }
}
