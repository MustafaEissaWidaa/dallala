import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import 'app_badge.dart';
import 'app_chip.dart';
import 'category_visuals.dart';

/// Display data for a listing card. Strings arrive pre-formatted
/// (formatPrice / formatNumberAr) so the card never formats numbers itself.
class ListingCardData {
  const ListingCardData({
    required this.title,
    required this.priceLabel,
    required this.locationLabel,
    required this.timeLabel,
    required this.visual,
    this.image,
    this.attributes = const [],
    this.featuredLabel,
    this.oldPriceLabel,
    this.faded = false,
    this.statusBadge,
  });

  final String title;
  final String priceLabel;
  final String locationLabel;
  final String timeLabel;
  final CategoryVisual visual;

  /// Cover thumbnail; null shows [ListingPlaceholder].
  final ImageProvider? image;
  final List<String> attributes;

  /// Shows the gum «مميّز» badge when non-null.
  final String? featuredLabel;

  /// Struck-through previous price (price-drop on favourites).
  final String? oldPriceLabel;

  /// Sold / removed listings render faded.
  final bool faded;
  final Widget? statusBadge;
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.data, required this.radius});

  final ListingCardData data;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (data.image != null)
            Image(
              image: data.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => ListingPlaceholder(visual: data.visual),
            )
          else
            ListingPlaceholder(visual: data.visual),
          if (data.featuredLabel != null)
            PositionedDirectional(
              top: AppSpacing.xs,
              start: AppSpacing.xs,
              child: AppBadge(
                label: data.featuredLabel!,
                tone: AppBadgeTone.featured,
              ),
            ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.data});

  final ListingCardData data;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        Text(data.priceLabel, style: t.price),
        if (data.oldPriceLabel != null)
          Text(
            data.oldPriceLabel!,
            style: t.caption.copyWith(decoration: TextDecoration.lineThrough),
          ),
      ],
    );
  }
}

/// Horizontal result card (screen 46): thumbnail at the start, details after.
class ListingCardHorizontal extends StatelessWidget {
  const ListingCardHorizontal({super.key, required this.data, this.onTap});

  final ListingCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Opacity(
      opacity: data.faded ? 0.55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardAll,
          boxShadow: AppShadows.card(c),
        ),
        child: Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.cardAll,
            side: BorderSide(color: c.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: AppSizes.listingThumb,
                      height: AppSizes.listingThumb,
                      child: _Thumb(data: data, radius: AppRadius.controlAll),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PriceLine(data: data),
                          Text(
                            data.title,
                            style: t.label.copyWith(fontSize: 15),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (data.attributes.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Wrap(
                              spacing: AppSpacing.xxs + 2,
                              runSpacing: AppSpacing.xxs,
                              children: [
                                for (final a in data.attributes)
                                  AttributeChip(label: a),
                              ],
                            ),
                          ],
                          const Spacer(),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  data.locationLabel,
                                  style: t.caption,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (data.statusBadge != null) ...[
                                const SizedBox(width: AppSpacing.xxs),
                                Flexible(child: data.statusBadge!),
                              ],
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                data.timeLabel,
                                style: t.caption,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Vertical card for the 2-column Home grid and the featured carousel.
class ListingCardGrid extends StatelessWidget {
  const ListingCardGrid({super.key, required this.data, this.onTap});

  final ListingCardData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    return Opacity(
      opacity: data.faded ? 0.55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: AppRadius.cardAll,
          boxShadow: AppShadows.card(c),
        ),
        child: Material(
          color: c.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.cardAll,
            side: BorderSide(color: c.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: _Thumb(data: data, radius: BorderRadius.zero),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PriceLine(data: data),
                      Text(
                        data.title,
                        style: t.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        data.locationLabel,
                        style: t.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
