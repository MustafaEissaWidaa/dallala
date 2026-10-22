import 'package:dallala/app.dart';
import 'package:dallala/core/l10n/generated/app_localizations.dart';
import 'package:dallala/core/storage/app_prefs.dart';
import 'package:dallala/core/theme/app_theme.dart';
import 'package:dallala/features/gallery/presentation/component_gallery_screen.dart';
import 'package:dallala/features/home/presentation/home_stub_screen.dart';
import 'package:dallala/features/onboarding/presentation/onboarding_stub_screen.dart';
import 'package:dallala/features/splash/presentation/dallala_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderScope> _scope(Map<String, Object> prefs, Widget child) async {
  SharedPreferences.setMockInitialValues(prefs);
  final instance = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(instance)],
    child: child,
  );
}

/// The splash loops its loading dots forever, so pumpAndSettle never
/// settles; advance frame by frame instead.
Future<void> _runSplash(WidgetTester tester) async {
  for (var i = 0; i < 60; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  group('splash routing', () {
    testWidgets('first launch → onboarding', (tester) async {
      await tester.pumpWidget(await _scope({}, const DallalaApp()));
      expect(find.byType(DallalaSplash), findsOneWidget);
      // 2400 ms animation + 700 ms hold + transitions.
      await _runSplash(tester);
      expect(find.byType(OnboardingStubScreen), findsOneWidget);
      expect(find.byType(DallalaSplash), findsNothing);
    });

    testWidgets('returning user → home', (tester) async {
      await tester.pumpWidget(
        await _scope({'seen_onboarding': true}, const DallalaApp()),
      );
      await _runSplash(tester);
      expect(find.byType(HomeStubScreen), findsOneWidget);
    });

    testWidgets('app is Arabic and right-to-left', (tester) async {
      await tester.pumpWidget(await _scope({}, const DallalaApp()));
      final ctx = tester.element(find.byType(DallalaSplash));
      expect(Directionality.of(ctx), TextDirection.rtl);
      expect(Localizations.localeOf(ctx).languageCode, 'ar');
    });
  });

  for (final (name, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    testWidgets('component gallery renders in $name theme', (tester) async {
      tester.view.physicalSize = const Size(390 * 3, 844 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        await _scope(
          {},
          MaterialApp(
            theme: theme,
            locale: const Locale('ar'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const ComponentGalleryScreen(),
          ),
        ),
      );
      await tester.pump();

      // Scroll the whole gallery so every section builds and lays out.
      final list = find.byType(Scrollable).first;
      for (var i = 0; i < 40; i++) {
        await tester.drag(list, const Offset(0, -400));
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(tester.takeException(), isNull);
      final ctx = tester.element(find.byType(ComponentGalleryScreen));
      expect(Theme.of(ctx).brightness, theme.brightness);
      expect(ctx.colors.sand, theme.scaffoldBackgroundColor);
    });
  }
}
