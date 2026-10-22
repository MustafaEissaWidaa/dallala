import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Spacing scale (spec §4). 16 is the screen side margin.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const double screenMargin = md;
  static const EdgeInsetsDirectional screen =
      EdgeInsetsDirectional.symmetric(horizontal: screenMargin);
}

/// Corner radii (spec §4).
abstract final class AppRadius {
  static const double badge = 8;
  static const double control = 14;
  static const double categoryTile = 18;
  static const double card = 20;
  static const double pill = 999;

  static const BorderRadius badgeAll = BorderRadius.all(Radius.circular(badge));
  static const BorderRadius controlAll =
      BorderRadius.all(Radius.circular(control));
  static const BorderRadius categoryTileAll =
      BorderRadius.all(Radius.circular(categoryTile));
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius sheetTop =
      BorderRadius.vertical(top: Radius.circular(card));
}

/// Fixed component sizes.
abstract final class AppSizes {
  static const double minTouch = 44;
  static const double icon = 24;
  static const double iconSm = 18;
  static const double iconStroke = 1.75;
  static const double buttonHeight = 52;
  static const double buttonHeightSm = 44;
  static const double inputHeight = 52;
  static const double searchBarHeight = 52;
  static const double categoryTile = 56;
  static const double fab = 60;
  static const double bottomNavHeight = 68;
  static const double avatar = 48;
  static const double listingThumb = 112;
  static const double sheetHandleWidth = 40;
  static const double sheetHandleHeight = 4;
  static const double border = 1;
  static const double dot = 8;
  static const double emptyIllustration = 160;
}

/// Shadows (spec §4): soft for cards, terracotta only for the floating (+).
abstract final class AppShadows {
  static List<BoxShadow> card(AppColors c) => [
        BoxShadow(
          color: c.shadow.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> fab(AppColors c) => [
        BoxShadow(
          color: c.terracotta.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration pageFade = Duration(milliseconds: 350);
  static const Duration skeletonPulse = Duration(milliseconds: 1100);
}
