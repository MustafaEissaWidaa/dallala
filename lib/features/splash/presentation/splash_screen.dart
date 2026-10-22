import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import 'dallala_splash.dart';

/// Hosts the supplied [DallalaSplash] unchanged.
///
/// `DallalaSplash` finishes with `Navigator.pushReplacement`. Running it in a
/// nested [Navigator] keeps that imperative call away from go_router's page
/// stack; the replacement route then hands over to the router.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (_) => PageRouteBuilder<void>(
        pageBuilder: (_, _, _) =>
            DallalaSplash(nextScreen: (_) => const _SplashExit()),
      ),
    );
  }
}

class _SplashExit extends ConsumerStatefulWidget {
  const _SplashExit();

  @override
  ConsumerState<_SplashExit> createState() => _SplashExitState();
}

class _SplashExitState extends ConsumerState<_SplashExit> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final seen = ref.read(appPrefsProvider).seenOnboarding;
      context.go(seen ? AppRoutes.home : AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: Theme.of(context).scaffoldBackgroundColor);
}
