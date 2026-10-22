import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/widgets/app_button.dart';

/// Temporary Home until Phase 4. Links to the component gallery.
class HomeStubScreen extends StatelessWidget {
  const HomeStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                dark
                    ? 'assets/01-Logo/dallala-logo-reversed.svg'
                    : 'assets/01-Logo/dallala-logo.svg',
                height: AppSizes.emptyIllustration * 0.6,
                semanticsLabel: l.appName,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l.appTagline, style: context.text.title),
              const SizedBox(height: AppSpacing.xs),
              Text(l.phaseStubHome, style: context.text.caption),
              const Spacer(),
              if (kDebugMode)
                AppButton(
                  label: l.openComponentGallery,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go(AppRoutes.gallery),
                ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
