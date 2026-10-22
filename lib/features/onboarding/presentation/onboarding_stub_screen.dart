import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/storage/app_prefs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';

/// Temporary first-launch destination until Phase 3 builds onboarding.
/// It already stores `seen_onboarding=true` the way the real flow will.
class OnboardingStubScreen extends ConsumerWidget {
  const OnboardingStubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            children: [
              const Spacer(),
              Text(l.phaseStubOnboarding, style: context.text.titleLg),
              const Spacer(),
              AppButton(
                label: l.actionStart,
                onPressed: () async {
                  await ref.read(appPrefsProvider).setSeenOnboarding();
                  if (context.mounted) context.go(AppRoutes.home);
                },
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
