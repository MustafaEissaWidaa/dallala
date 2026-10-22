import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Pulses its sand-deep children together. Wrap a whole skeleton layout in
/// one [SkeletonScope] so every [SkeletonBox] shares a single animation.
class SkeletonScope extends StatefulWidget {
  const SkeletonScope({super.key, required this.child});

  final Widget child;

  @override
  State<SkeletonScope> createState() => _SkeletonScopeState();
}

class _SkeletonScopeState extends State<SkeletonScope>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppDurations.skeletonPulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      child: ExcludeSemantics(
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.55).animate(
            CurvedAnimation(parent: _c, curve: Curves.easeInOut),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 14,
    this.radius = AppRadius.badge,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.sandDeep,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Loading placeholder matching [ListingCardHorizontal].
class SkeletonListingCard extends StatelessWidget {
  const SkeletonListingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsetsDirectional.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: c.line),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(
            width: AppSizes.listingThumb,
            height: AppSizes.listingThumb,
            radius: AppRadius.control,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.xxs),
                SkeletonBox(width: 110, height: 20),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(height: 16),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    SkeletonBox(width: 56, height: 22, radius: AppRadius.pill),
                    SizedBox(width: AppSpacing.xxs + 2),
                    SkeletonBox(width: 44, height: 22, radius: AppRadius.pill),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(width: 90, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading placeholder matching [ListingCardGrid].
class SkeletonGridCard extends StatelessWidget {
  const SkeletonGridCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AppRadius.cardAll,
        border: Border.all(color: c.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: SkeletonBox(radius: 0),
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 80, height: 18),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(height: 14),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(width: 60, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
