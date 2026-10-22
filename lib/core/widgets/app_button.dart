import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

enum AppButtonVariant {
  /// Terracotta fill — the main action on a screen.
  primary,

  /// Surface fill with a line border.
  secondary,

  /// Terracotta-soft fill with terracotta text.
  soft,

  /// Acacia fill — call / success actions.
  success,

  /// Danger-soft fill with danger text — sign out, delete.
  danger,

  /// No fill — inline links such as «تعديل».
  text,
}

enum AppButtonSize { regular, small }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppIcons? icon;
  final bool loading;

  /// Stretch to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final (bg, fg, pressed, border) = _palette(c);
    final enabled = onPressed != null && !loading;
    final height = size == AppButtonSize.regular
        ? AppSizes.buttonHeight
        : AppSizes.buttonHeightSm;
    final textStyle = size == AppButtonSize.regular
        ? t.label.copyWith(fontSize: 16, color: fg)
        : t.label.copyWith(color: fg);

    final child = loading
        ? SizedBox.square(
            dimension: AppSizes.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: fg,
              backgroundColor: Colors.transparent,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                AppIcon(icon!, size: AppSizes.iconSm + 2, color: fg),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    final button = Semantics(
      button: true,
      enabled: enabled,
      label: loading ? label : null,
      child: Opacity(
        opacity: onPressed == null ? 0.45 : 1,
        child: Material(
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.controlAll,
            side: border == null ? BorderSide.none : BorderSide(color: border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            highlightColor: pressed,
            splashColor: pressed,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height,
                minWidth: AppSizes.minTouch,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md + AppSpacing.xxs,
                ),
                child: Center(widthFactor: 1, child: child),
              ),
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  (Color bg, Color fg, Color pressed, Color? border) _palette(AppColors c) =>
      switch (variant) {
        AppButtonVariant.primary => (
            c.terracotta,
            c.onTerracotta,
            c.terracottaPress,
            null,
          ),
        AppButtonVariant.secondary => (c.surface, c.ink, c.sandDeep, c.line),
        AppButtonVariant.soft => (
            c.terracottaSoft,
            c.terracotta,
            c.terracotta.withValues(alpha: 0.12),
            null,
          ),
        AppButtonVariant.success => (
            c.acacia,
            c.onAcacia,
            c.ink.withValues(alpha: 0.12),
            null,
          ),
        AppButtonVariant.danger => (
            c.dangerSoft,
            c.danger,
            c.danger.withValues(alpha: 0.12),
            null,
          ),
        AppButtonVariant.text => (
            Colors.transparent,
            c.terracotta,
            c.terracottaSoft,
            null,
          ),
      };
}

/// Square 44×44 icon button on a surface tile (back, share, favourite, bell).
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
    this.background,
    this.showDot = false,
    this.bordered = true,
  });

  final AppIcons icon;
  final VoidCallback? onPressed;

  /// Also used as the semantics label.
  final String tooltip;
  final Color? color;
  final Color? background;

  /// Small terracotta dot (e.g. unread notifications).
  final bool showDot;
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background ?? c.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.controlAll,
          side: bordered ? BorderSide(color: c.line) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: AppSizes.minTouch,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppIcon(icon, color: color ?? c.ink),
                if (showDot)
                  PositionedDirectional(
                    top: AppSpacing.sm - 2,
                    end: AppSpacing.sm - 2,
                    child: Container(
                      width: AppSizes.dot,
                      height: AppSizes.dot,
                      decoration: BoxDecoration(
                        color: c.terracotta,
                        shape: BoxShape.circle,
                        border: Border.all(color: c.surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
