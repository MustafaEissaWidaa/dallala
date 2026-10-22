import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

enum ListTileTone { accent, success, neutral, danger }

/// A rounded group of [AppListTile]s separated by dividers (screen 34).
class AppListGroup extends StatelessWidget {
  const AppListGroup({super.key, required this.children, this.title});

  final List<Widget> children;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(
              bottom: AppSpacing.xs,
              start: AppSpacing.xxs,
            ),
            child: Text(
              title!,
              style: context.text.label.copyWith(color: c.inkMuted),
            ),
          ),
        Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.cardAll,
            side: BorderSide(color: c.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Settings-style row: tinted icon tile, title, optional subtitle and a
/// trailing value + chevron, or any custom [trailing] (e.g. a Switch).
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.icon,
    this.tone = ListTileTone.accent,
    this.subtitle,
    this.value,
    this.valueColor,
    this.trailing,
    this.onTap,
    this.showChevron = true,
  });

  final String title;
  final AppIcons? icon;
  final ListTileTone tone;
  final String? subtitle;

  /// Short trailing text such as «موثّق» or «الأبيض».
  final String? value;
  final Color? valueColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final (bg, fg) = switch (tone) {
      ListTileTone.accent => (c.terracottaSoft, c.terracotta),
      ListTileTone.success => (c.acaciaSoft, c.acacia),
      ListTileTone.neutral => (c.sandDeep, c.ink),
      ListTileTone.danger => (c.dangerSoft, c.danger),
    };
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 64),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: AppSizes.minTouch,
                  height: AppSizes.minTouch,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: AppRadius.controlAll,
                  ),
                  alignment: Alignment.center,
                  child: AppIcon(icon!, size: AppSizes.iconSm + 2, color: fg),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: t.bodyLg.copyWith(
                      fontWeight: FontWeight.w500,
                    )),
                    if (subtitle != null) Text(subtitle!, style: t.caption),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  value!,
                  style: t.body.copyWith(color: valueColor ?? c.inkMuted),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.xs),
                trailing!,
              ] else if (showChevron && onTap != null) ...[
                const SizedBox(width: AppSpacing.xs),
                AppIcon(
                  AppIcons.chevronForward,
                  size: AppSizes.iconSm,
                  color: c.inkMuted,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
