import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final t = AppTextStyles.from(c);
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.terracotta,
      onPrimary: c.onTerracotta,
      primaryContainer: c.terracottaSoft,
      onPrimaryContainer: c.terracotta,
      secondary: c.gum,
      onSecondary: c.ink,
      secondaryContainer: c.gumSoft,
      onSecondaryContainer: c.gumText,
      tertiary: c.acacia,
      onTertiary: c.onAcacia,
      tertiaryContainer: c.acaciaSoft,
      onTertiaryContainer: c.acacia,
      error: c.danger,
      onError: c.surface,
      errorContainer: c.dangerSoft,
      onErrorContainer: c.danger,
      surface: c.surface,
      onSurface: c.ink,
      onSurfaceVariant: c.inkMuted,
      surfaceContainerHighest: c.sandDeep,
      surfaceContainerHigh: c.sandDeep,
      surfaceContainer: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainerLowest: c.surface,
      outline: c.line,
      outlineVariant: c.line,
      shadow: c.shadow,
      scrim: c.shadow,
      inverseSurface: c.ink,
      onInverseSurface: c.sand,
      inversePrimary: c.terracottaSoft,
      surfaceTint: Colors.transparent,
    );

    const controlShape = RoundedRectangleBorder(
      borderRadius: AppRadius.controlAll,
    );
    OutlineInputBorder inputBorder(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: AppRadius.controlAll,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.body,
      scaffoldBackgroundColor: c.sand,
      canvasColor: c.sand,
      dividerColor: c.line,
      splashFactory: InkRipple.splashFactory,
      extensions: [c, t],
      textTheme: TextTheme(
        displayLarge: t.display,
        displayMedium: t.display,
        displaySmall: t.titleLg,
        headlineLarge: t.titleLg,
        headlineMedium: t.titleLg,
        headlineSmall: t.title,
        titleLarge: t.title,
        titleMedium: t.label,
        titleSmall: t.label,
        bodyLarge: t.bodyLg,
        bodyMedium: t.body,
        bodySmall: t.caption,
        labelLarge: t.label,
        labelMedium: t.caption,
        labelSmall: t.caption,
      ),
      iconTheme: IconThemeData(color: c.ink, size: AppSizes.icon),
      appBarTheme: AppBarTheme(
        backgroundColor: c.sand,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: t.title,
        systemOverlayStyle: brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),
      dividerTheme: DividerThemeData(
        color: c.line,
        thickness: AppSizes.border,
        space: AppSizes.border,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        hintStyle: t.bodyLg.copyWith(color: c.inkMuted),
        labelStyle: t.label.copyWith(color: c.inkMuted),
        floatingLabelStyle: t.label.copyWith(color: c.terracotta),
        errorStyle: t.caption.copyWith(color: c.danger),
        helperStyle: t.caption,
        counterStyle: t.caption,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xxs,
        ),
        border: inputBorder(c.line),
        enabledBorder: inputBorder(c.line),
        focusedBorder: inputBorder(c.terracotta, 1.5),
        errorBorder: inputBorder(c.danger),
        focusedErrorBorder: inputBorder(c.danger, 1.5),
        disabledBorder: inputBorder(c.line),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.terracotta,
          foregroundColor: c.onTerracotta,
          minimumSize: const Size(AppSizes.minTouch, AppSizes.buttonHeight),
          shape: controlShape,
          textStyle: t.label.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.ink,
          minimumSize: const Size(AppSizes.minTouch, AppSizes.buttonHeight),
          side: BorderSide(color: c.line),
          shape: controlShape,
          textStyle: t.label.copyWith(fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.terracotta,
          minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch),
          shape: controlShape,
          textStyle: t.label,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.surface : c.inkMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.acacia : c.sandDeep,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.acacia : c.line,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.terracotta : c.surface,
        ),
        checkColor: WidgetStatePropertyAll(c.onTerracotta),
        side: BorderSide(color: c.line, width: 1.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.terracotta : c.inkMuted,
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: c.terracotta,
        inactiveTrackColor: c.sandDeep,
        thumbColor: c.terracotta,
        overlayColor: c.terracotta.withValues(alpha: 0.12),
        rangeThumbShape: const RoundRangeSliderThumbShape(),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.terracotta,
        linearTrackColor: c.sandDeep,
        circularTrackColor: c.sandDeep,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.line,
        dragHandleSize: const Size(
          AppSizes.sheetHandleWidth,
          AppSizes.sheetHandleHeight,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheetTop),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardAll),
        titleTextStyle: t.title,
        contentTextStyle: t.body,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.ink,
        contentTextStyle: t.body.copyWith(color: c.sand),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.controlAll),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: c.terracotta,
        unselectedLabelColor: c.inkMuted,
        indicatorColor: c.terracotta,
        dividerColor: c.line,
        labelStyle: t.label,
        unselectedLabelStyle: t.label.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

extension AppThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTextStyles get text => Theme.of(this).extension<AppTextStyles>()!;
}
