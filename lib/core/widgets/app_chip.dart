import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

/// Pill chip (radius 999) for localities, sub-categories and filter values.
/// Selected chips fill with terracotta.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
    this.onRemove,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final AppIcons? icon;

  /// Shows a close icon — used for active-filter chips.
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onTerracotta : c.ink;
    return _PillShell(
      background: selected ? c.terracotta : c.surface,
      border: selected ? c.terracotta : c.line,
      onTap: onTap,
      selected: selected,
      children: [
        if (icon != null) ...[
          AppIcon(icon!, size: AppSizes.iconSm, color: fg),
          const SizedBox(width: AppSpacing.xxs + 2),
        ],
        Text(label, style: context.text.label.copyWith(color: fg)),
        if (onRemove != null) ...[
          const SizedBox(width: AppSpacing.xxs + 2),
          InkResponse(
            onTap: onRemove,
            radius: AppSizes.minTouch / 2,
            child: AppIcon(AppIcons.close, size: AppSizes.iconSm, color: fg),
          ),
        ],
      ],
    );
  }
}

/// Filter-bar chip. `primary` renders the dark «الفلاتر» button; the others
/// show a chevron because they open a picker (screen 46).
class AppFilterChip extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    this.onTap,
    this.primary = false,
    this.active = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool primary;

  /// A value is set for this filter — outline turns terracotta.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = primary ? c.sand : (active ? c.terracotta : c.ink);
    return _PillShell(
      background: primary ? c.ink : (active ? c.terracottaSoft : c.surface),
      border: primary ? c.ink : (active ? c.terracotta : c.line),
      onTap: onTap,
      children: [
        if (primary) ...[
          AppIcon(AppIcons.filter, size: AppSizes.iconSm + 2, color: fg),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(label, style: context.text.label.copyWith(color: fg)),
        if (!primary) ...[
          const SizedBox(width: AppSpacing.xxs + 2),
          AppIcon(AppIcons.chevronDown, size: AppSizes.iconSm, color: fg),
        ],
      ],
    );
  }
}

/// Small sand-deep chip for listing attributes («١٢٠ ألف كم», «ديزل»).
class AttributeChip extends StatelessWidget {
  const AttributeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.sm - 2,
        vertical: AppSpacing.xxs - 1,
      ),
      decoration: BoxDecoration(
        color: c.sandDeep,
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: context.text.caption.copyWith(color: c.ink),
        maxLines: 1,
      ),
    );
  }
}

class _PillShell extends StatelessWidget {
  const _PillShell({
    required this.background,
    required this.border,
    required this.children,
    this.onTap,
    this.selected,
  });

  final Color background;
  final Color border;
  final List<Widget> children;
  final VoidCallback? onTap;
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: Material(
        color: background,
        shape: StadiumBorder(side: BorderSide(color: border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTouch),
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: children),
            ),
          ),
        ),
      ),
    );
  }
}
