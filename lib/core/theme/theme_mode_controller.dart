import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/app_prefs.dart';

part 'theme_mode_controller.g.dart';

/// Light / dark / system. Follows the system setting by default.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ref.watch(appPrefsProvider).themeMode;

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await ref.read(appPrefsProvider).setThemeMode(mode);
  }
}
