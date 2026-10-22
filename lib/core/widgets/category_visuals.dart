import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_icon.dart';

enum PlaceholderTone { terracotta, earth, olive }

/// Visuals for a category `icon_key` (from `categories.icon_key`).
enum CategoryVisual {
  cars('cars', AppIcons.car, PlaceholderTone.terracotta),
  livestock('livestock', AppIcons.livestock, PlaceholderTone.olive),
  realEstate('real_estate', AppIcons.realEstate, PlaceholderTone.earth),
  crops('crops', AppIcons.crops, PlaceholderTone.olive),
  rickshaws('rickshaws', AppIcons.rickshaw, PlaceholderTone.terracotta),
  electronics('electronics', AppIcons.electronics, PlaceholderTone.earth),
  furniture('furniture', AppIcons.furniture, PlaceholderTone.earth),
  jobs('jobs', AppIcons.jobs, PlaceholderTone.terracotta),
  services('services', AppIcons.services, PlaceholderTone.olive),
  other('other', AppIcons.navCategories, PlaceholderTone.earth);

  const CategoryVisual(this.key, this.icon, this.tone);

  final String key;
  final AppIcons icon;
  final PlaceholderTone tone;

  static CategoryVisual fromKey(String? key) => values.firstWhere(
        (v) => v.key == key,
        orElse: () => CategoryVisual.other,
      );
}

extension PlaceholderToneColors on PlaceholderTone {
  (Color bg, Color icon) colors(AppColors c) => switch (this) {
        PlaceholderTone.terracotta => (
            c.placeholderTerracotta,
            c.placeholderTerracottaIcon,
          ),
        PlaceholderTone.earth => (c.placeholderEarth, c.placeholderEarthIcon),
        PlaceholderTone.olive => (c.placeholderOlive, c.placeholderOliveIcon),
      };
}

/// Terracotta-soft tile (radius 18) with the category icon in terracotta.
class CategoryIconTile extends StatelessWidget {
  const CategoryIconTile({
    super.key,
    required this.icon,
    this.size = AppSizes.categoryTile,
  });

  final AppIcons icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: c.terracottaSoft,
        borderRadius: AppRadius.categoryTileAll,
      ),
      alignment: Alignment.center,
      child: AppIcon(icon, size: size * 0.5, color: c.terracotta),
    );
  }
}

/// Category grid cell: icon tile, name and active ad count.
class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.visual,
    required this.name,
    this.countLabel,
    this.onTap,
    this.carded = true,
  });

  final CategoryVisual visual;
  final String name;

  /// Pre-formatted (Eastern Arabic digits).
  final String? countLabel;
  final VoidCallback? onTap;

  /// Grid tiles sit on a card; the Home row shows the bare tile.
  final bool carded;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CategoryIconTile(icon: visual.icon),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          style: t.label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (countLabel != null)
          Text(countLabel!, style: t.caption, textAlign: TextAlign.center),
      ],
    );
    return Semantics(
      button: true,
      child: Material(
        color: carded ? c.surface : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardAll,
          side: carded ? BorderSide(color: c.line) : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// No-photo placeholder: soft per-category background with the thin-stroke
/// category icon (spec §11).
class ListingPlaceholder extends StatelessWidget {
  const ListingPlaceholder({super.key, required this.visual, this.iconSize});

  final CategoryVisual visual;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = visual.tone.colors(context.colors);
    return LayoutBuilder(
      builder: (context, box) {
        final shortest = box.biggest.shortestSide.isFinite
            ? box.biggest.shortestSide
            : AppSizes.listingThumb;
        return Container(
          color: bg,
          alignment: Alignment.center,
          child: AppIcon(
            visual.icon,
            size: iconSize ?? shortest * 0.42,
            color: fg,
          ),
        );
      },
    );
  }
}
