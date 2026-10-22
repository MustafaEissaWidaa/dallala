import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/gallery/presentation/component_gallery_screen.dart';
import '../../features/home/presentation/home_stub_screen.dart';
import '../../features/onboarding/presentation/onboarding_stub_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../theme/app_tokens.dart';

part 'app_router.g.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/';
  static const gallery = '/gallery';
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: AppDurations.pageFade,
      transitionsBuilder: (context, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    );

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _fadePage(state, const OnboardingStubScreen()),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            _fadePage(state, const HomeStubScreen()),
        routes: [
          // Developer tool: never routed in profile/release builds.
          if (kDebugMode)
            GoRoute(
              path: 'gallery',
              builder: (context, state) => const ComponentGalleryScreen(),
            ),
        ],
      ),
    ],
  );
}
