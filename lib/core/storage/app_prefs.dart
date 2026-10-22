import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_prefs.g.dart';

/// Overridden in `main()` with the instance loaded before `runApp`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden');

@Riverpod(keepAlive: true)
AppPrefs appPrefs(Ref ref) => AppPrefs(ref.watch(sharedPreferencesProvider));

/// Typed access to local settings (spec §3: shared_preferences for settings).
class AppPrefs {
  AppPrefs(this._prefs);
  final SharedPreferences _prefs;

  static const _seenOnboarding = 'seen_onboarding';
  static const _themeMode = 'theme_mode';

  bool get seenOnboarding => _prefs.getBool(_seenOnboarding) ?? false;
  Future<void> setSeenOnboarding() => _prefs.setBool(_seenOnboarding, true);

  ThemeMode get themeMode => switch (_prefs.getString(_themeMode)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString(_themeMode, mode.name);
}
