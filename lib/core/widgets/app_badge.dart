import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

enum AppBadgeTone {
  /// Gum fill, ink text — «مميّز».
  featured,

  /// Acacia-soft — «موثّق», success.
  success,

  /// Gum-soft — «قيد المراجعة», pending top-ups.
  pending,

  /// Danger-soft — «مرفوض», reports.
  danger,

  /// Terracotta-soft — «نزل السعر», «الأكثر طلباً».
  accent,

  /// Sand-deep — «اتباع», expired.
  neutral,
}

/// Small status label, radius 8.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.tone = AppBadgeTone.neutral,
    this.icon,
  });

  final String label;
  final AppBadgeTone tone;
  final AppIcons? icon;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _palette(context.colors);
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs / 2,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.badgeAll),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            AppIcon(icon!, size: AppSizes.iconSm - 4, color: fg),
            const SizedBox(width: AppSpacing.xxs),
          ],
          Flexible(
            child: Text(
              label,
              style: context.text.caption.copyWith(
                color: fg,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _palette(AppColors c) => switch (tone) {
        AppBadgeTone.featured => (c.gum, c.onGum),
        AppBadgeTone.success => (c.acaciaSoft, c.acacia),
        AppBadgeTone.pending => (c.gumSoft, c.gumText),
        AppBadgeTone.danger => (c.dangerSoft, c.danger),
        AppBadgeTone.accent => (c.terracottaSoft, c.terracotta),
        AppBadgeTone.neutral => (c.sandDeep, c.inkMuted),
      };
}

/// Count bubble for unread chats/messages.
class CountBadge extends StatelessWidget {
  const CountBadge({super.key, required this.label});

  /// Already formatted with Eastern Arabic digits.
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: c.terracotta,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: context.text.caption.copyWith(
          color: c.onTerracotta,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}
