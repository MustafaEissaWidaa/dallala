import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_button.dart';
import 'app_icon.dart';

/// Shared layout for the empty / error / offline states every screen needs.
class _StateLayout extends StatelessWidget {
  const _StateLayout({
    required this.illustration,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final Widget illustration;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            illustration,
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: t.title, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                body!,
                style: t.body.copyWith(color: context.colors.inkMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: AppIcons.refresh,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconIllustration extends StatelessWidget {
  const _IconIllustration(this.icon, {required this.bg, required this.fg});

  final AppIcons icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        width: AppSizes.emptyIllustration * 0.6,
        height: AppSizes.emptyIllustration * 0.6,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.cardAll,
        ),
        alignment: Alignment.center,
        child: AppIcon(icon, size: AppSizes.icon * 2, color: fg),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.title,
    this.body,
    this.icon = AppIcons.search,
    this.actionLabel,
    this.onAction,
  });

  final String? title;
  final String? body;
  final AppIcons icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    return _StateLayout(
      illustration: _IconIllustration(icon, bg: c.sandDeep, fg: c.inkMuted),
      title: title ?? l.stateEmptyTitle,
      body: body ?? l.stateEmptyBody,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Never shows technical details — only a friendly message and «حاول تاني».
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.onRetry, this.title, this.body});

  final VoidCallback onRetry;
  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    return _StateLayout(
      illustration: _IconIllustration(
        AppIcons.shieldAlert,
        bg: c.dangerSoft,
        fg: c.danger,
      ),
      title: title ?? l.stateErrorTitle,
      body: body ?? l.stateErrorBody,
      actionLabel: l.actionRetry,
      onAction: onRetry,
    );
  }
}

/// Offline screen (design 32): banner, illustration, message, then
/// «حاول مرة تانية» and an optional «افتح المفضلة» pinned to the bottom.
class OfflineState extends StatelessWidget {
  const OfflineState({super.key, required this.onRetry, this.onOpenFavorites});

  final VoidCallback onRetry;
  final VoidCallback? onOpenFavorites;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = context.text;
    return Padding(
      padding: const EdgeInsetsDirectional.all(AppSpacing.md),
      child: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/05-Backgrounds/svg/offline-illustration.svg',
                      height: AppSizes.emptyIllustration * 1.5,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l.stateOfflineTitle,
                      style: t.titleLg,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l.stateOfflineBody,
                      style: t.bodyLg.copyWith(color: context.colors.inkMuted),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppButton(
            label: l.actionTryAgain,
            icon: AppIcons.refresh,
            onPressed: onRetry,
          ),
          if (onOpenFavorites != null) ...[
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: l.actionOpenFavorites,
              variant: AppButtonVariant.secondary,
              onPressed: onOpenFavorites,
            ),
          ],
        ],
      ),
    );
  }
}

/// Rounded ink banner «أنت غير متصل بالإنترنت» with a danger dot
/// (design 32). Also shown above cached content while offline.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: AppSizes.minTouch + 8),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: c.headerInk,
          borderRadius: AppRadius.cardAll,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.dot + 2,
              height: AppSizes.dot + 2,
              decoration: BoxDecoration(
                color: c.danger,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppLocalizations.of(context).stateOfflineBanner,
                style: context.text.label.copyWith(color: c.onHeaderInk),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
