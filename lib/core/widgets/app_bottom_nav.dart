import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import '../utils/formatters.dart';
import 'app_badge.dart';
import 'app_icon.dart';

/// Bottom navigation: Home, Categories, floating (+), Chats, Profile.
/// Tab indices are 0–3; the (+) calls [onAddTap] and is not a tab.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
    this.unreadChats = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddTap;
  final int unreadChats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = AppLocalizations.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSizes.bottomNavHeight,
          child: Row(
            children: [
              _NavItem(
                icon: AppIcons.navHome,
                label: l.navHome,
                selected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: AppIcons.navCategories,
                label: l.navCategories,
                selected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              Expanded(child: Center(child: _AddButton(onTap: onAddTap))),
              _NavItem(
                icon: AppIcons.chat,
                label: l.navChats,
                selected: currentIndex == 2,
                onTap: () => onTap(2),
                badge: unreadChats > 0 ? formatNumberAr(unreadChats) : null,
              ),
              _NavItem(
                icon: AppIcons.user,
                label: l.navProfile,
                selected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final AppIcons icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.terracotta : c.inkMuted;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        excludeSemantics: true,
        child: InkResponse(
          onTap: onTap,
          containedInkWell: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppIcon(icon, color: color),
                  if (badge != null)
                    PositionedDirectional(
                      top: -AppSpacing.xs,
                      end: -AppSpacing.sm,
                      child: CountBadge(label: badge!),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                label,
                style: context.text.caption.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating (+) — the only element with the terracotta shadow.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Transform.translate(
      offset: const Offset(0, -AppSpacing.md),
      child: Semantics(
        button: true,
        label: AppLocalizations.of(context).navAddAd,
        excludeSemantics: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.cardAll,
            boxShadow: AppShadows.fab(c),
          ),
          child: Material(
            color: c.terracotta,
            borderRadius: AppRadius.cardAll,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              highlightColor: c.terracottaPress,
              child: SizedBox.square(
                dimension: AppSizes.fab,
                child: Center(
                  child: AppIcon(
                    AppIcons.plus,
                    size: AppSizes.icon + 8,
                    color: c.onTerracotta,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
