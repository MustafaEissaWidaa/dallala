import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/theme_mode_controller.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/category_visuals.dart';
import '../../../core/widgets/listing_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../../../core/widgets/state_views.dart';

/// Every reusable widget, in the active theme. Switch light/dark at the top.
class ComponentGalleryScreen extends ConsumerStatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  ConsumerState<ComponentGalleryScreen> createState() =>
      _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState
    extends ConsumerState<ComponentGalleryScreen> {
  int _locality = 0;
  int _navIndex = 0;
  bool _dataSaver = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final mode = ref.watch(themeModeControllerProvider);
    final setMode = ref.read(themeModeControllerProvider.notifier).setMode;

    return Scaffold(
      appBar: AppBar(title: Text(l.galleryTitle)),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _navIndex,
        unreadChats: 3,
        onTap: (i) => setState(() => _navIndex = i),
        onAddTap: () {},
      ),
      body: ListView(
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final (m, label) in [
                (ThemeMode.light, l.themeLight),
                (ThemeMode.dark, l.themeDark),
                (ThemeMode.system, l.themeSystem),
              ])
                AppChip(
                  label: label,
                  selected: mode == m,
                  onTap: () => setMode(m),
                ),
            ],
          ),

          _Section(l.gallerySectionColors),
          _ColorSwatches(colors: c),

          _Section(l.gallerySectionTypography),
          _TypeSamples(l: l),

          _Section(l.gallerySectionButtons),
          AppButton(label: l.galleryButtonPrimary, onPressed: () {}),
          const _Gap(),
          AppButton(
            label: l.galleryButtonSecondary,
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
          const _Gap(),
          AppButton(
            label: l.galleryButtonSoft,
            variant: AppButtonVariant.soft,
            icon: AppIcons.edit,
            onPressed: () {},
          ),
          const _Gap(),
          AppButton(
            label: l.galleryButtonSuccess,
            variant: AppButtonVariant.success,
            icon: AppIcons.call,
            onPressed: () {},
          ),
          const _Gap(),
          AppButton(
            label: l.galleryButtonDanger,
            variant: AppButtonVariant.danger,
            icon: AppIcons.logout,
            onPressed: () {},
          ),
          const _Gap(),
          AppButton(
            label: l.galleryButtonLoading,
            loading: _loading,
            onPressed: () async {
              setState(() => _loading = true);
              await Future<void>.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => _loading = false);
            },
          ),
          const _Gap(),
          AppButton(label: l.galleryButtonDisabled, onPressed: null),
          const _Gap(),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppButton(
                label: l.actionTopUp,
                size: AppButtonSize.small,
                expand: false,
                onPressed: () {},
              ),
              AppButton(
                label: l.galleryButtonText,
                variant: AppButtonVariant.text,
                size: AppButtonSize.small,
                expand: false,
                onPressed: () {},
              ),
              AppIconButton(
                icon: AppIcons.arrowBack,
                tooltip: l.actionBack,
                onPressed: () {},
              ),
              AppIconButton(
                icon: AppIcons.bell,
                tooltip: l.navHome,
                showDot: true,
                onPressed: () {},
              ),
              AppIconButton(
                icon: AppIcons.share,
                tooltip: l.actionShare,
                onPressed: () {},
              ),
            ],
          ),

          _Section(l.gallerySectionInputs),
          AppSearchBar(hint: l.searchHint),
          const _Gap(),
          AppTextField(
            label: l.galleryInputLabel,
            hint: l.galleryInputHint,
            maxLength: 70,
          ),
          const _Gap(),
          AppTextField(
            label: l.galleryInputLabel,
            hint: l.galleryInputHint,
            errorText: l.galleryInputError,
          ),
          const _Gap(),
          AppTextField(
            label: l.galleryInputPhoneLabel,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            prefix: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppSpacing.md,
              ),
              child: Text(
                '+249',
                style: context.text.bodyLg.copyWith(color: c.inkMuted),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),

          _Section(l.gallerySectionChips),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final (i, name) in [
                l.galleryChipLocality1,
                l.galleryChipLocality2,
                l.galleryChipLocality3,
              ].indexed)
                AppChip(
                  label: name,
                  selected: _locality == i,
                  onTap: () => setState(() => _locality = i),
                ),
              AppChip(
                label: l.galleryChipLocality1,
                icon: AppIcons.location,
                onRemove: () {},
              ),
            ],
          ),
          const _Gap(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                AppFilterChip(label: l.actionFilters, primary: true, onTap: () {}),
                const SizedBox(width: AppSpacing.xs),
                AppFilterChip(label: l.galleryChipMake, active: true, onTap: () {}),
                const SizedBox(width: AppSpacing.xs),
                AppFilterChip(label: l.galleryChipYear, onTap: () {}),
              ],
            ),
          ),
          const _Gap(),
          Wrap(
            spacing: AppSpacing.xxs + 2,
            children: [
              AttributeChip(label: l.galleryChipAttr1),
              AttributeChip(label: l.galleryChipAttr2),
              AttributeChip(label: l.galleryChipAttr3),
            ],
          ),

          _Section(l.gallerySectionBadges),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              AppBadge(label: l.badgeFeatured, tone: AppBadgeTone.featured),
              AppBadge(
                label: l.badgeVerified,
                tone: AppBadgeTone.success,
                icon: AppIcons.shieldCheck,
              ),
              AppBadge(label: l.badgePending, tone: AppBadgeTone.pending),
              AppBadge(label: l.badgeRejected, tone: AppBadgeTone.danger),
              AppBadge(
                label: l.badgePriceDropped,
                tone: AppBadgeTone.accent,
                icon: AppIcons.priceDrop,
              ),
              AppBadge(label: l.badgeMostPopular, tone: AppBadgeTone.accent),
              AppBadge(label: l.badgeSold),
              CountBadge(label: formatNumberAr(3)),
              const AppIcon(AppIcons.verifiedBadge),
            ],
          ),

          _Section(l.gallerySectionCards),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.galleryCardTitle, style: context.text.label),
                      Text(formatPrice(18000), style: context.text.titleLg),
                      Text(l.galleryCardBody, style: context.text.caption),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppButton(
                  label: l.actionTopUp,
                  size: AppButtonSize.small,
                  expand: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const _Gap(),
          SectionHeader(
            title: l.gallerySectionListings,
            actionLabel: l.actionClear,
            onAction: () {},
          ),

          _Section(l.gallerySectionCategories),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.8,
            children: [
              CategoryTile(
                visual: CategoryVisual.cars,
                name: l.galleryCatCars,
                countLabel: formatNumberAr(520),
                onTap: () {},
              ),
              CategoryTile(
                visual: CategoryVisual.livestock,
                name: l.galleryCatLivestock,
                countLabel: formatNumberAr(864),
                onTap: () {},
              ),
              CategoryTile(
                visual: CategoryVisual.realEstate,
                name: l.galleryCatRealEstate,
                countLabel: formatNumberAr(412),
                onTap: () {},
              ),
            ],
          ),
          const _Gap(),
          Row(
            children: [
              for (final v in [
                CategoryVisual.cars,
                CategoryVisual.realEstate,
                CategoryVisual.crops,
              ]) ...[
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadius.controlAll,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ListingPlaceholder(visual: v),
                    ),
                  ),
                ),
                if (v != CategoryVisual.crops)
                  const SizedBox(width: AppSpacing.sm),
              ],
            ],
          ),

          _Section(l.gallerySectionListings),
          ListingCardHorizontal(
            onTap: () {},
            data: ListingCardData(
              title: l.galleryListingTitle1,
              priceLabel: formatPrice(45000000),
              locationLabel: l.locationLine(
                l.galleryListingLocality,
                l.galleryListingNeighborhood,
              ),
              timeLabel: l.timeAgoHours(formatNumberAr(3)),
              visual: CategoryVisual.cars,
              featuredLabel: l.badgeFeatured,
              attributes: [
                l.galleryChipAttr1,
                l.galleryChipAttr2,
                l.galleryChipAttr3,
              ],
            ),
          ),
          const _Gap(),
          ListingCardHorizontal(
            data: ListingCardData(
              title: l.galleryListingTitle2,
              priceLabel: formatPrice(180000),
              oldPriceLabel: formatPrice(210000),
              locationLabel: l.galleryListingLocality,
              timeLabel: l.timeAgoHours(formatNumberAr(5)),
              visual: CategoryVisual.livestock,
              statusBadge: AppBadge(
                label: l.badgePriceDropped,
                tone: AppBadgeTone.accent,
              ),
            ),
          ),
          const _Gap(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListingCardGrid(
                  onTap: () {},
                  data: ListingCardData(
                    title: l.galleryListingTitle1,
                    priceLabel: formatPrice(45000000),
                    locationLabel: l.galleryListingLocality,
                    timeLabel: '',
                    visual: CategoryVisual.cars,
                    featuredLabel: l.badgeFeatured,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ListingCardGrid(
                  data: ListingCardData(
                    title: l.galleryListingTitle2,
                    priceLabel: formatPrice(180000),
                    locationLabel: l.galleryListingLocality,
                    timeLabel: '',
                    visual: CategoryVisual.livestock,
                    faded: true,
                  ),
                ),
              ),
            ],
          ),

          _Section(l.gallerySectionLists),
          AppListGroup(
            children: [
              AppListTile(
                icon: AppIcons.shieldCheck,
                tone: ListTileTone.success,
                title: l.galleryListPhone,
                value: l.badgeVerified,
                valueColor: c.acacia,
                onTap: () {},
              ),
              AppListTile(
                icon: AppIcons.location,
                title: l.galleryListLocality,
                value: l.galleryChipLocality1,
                onTap: () {},
              ),
              AppListTile(
                icon: AppIcons.dataSaver,
                title: l.galleryListDataSaver,
                subtitle: l.galleryListDataSaverSub,
                trailing: Switch(
                  value: _dataSaver,
                  onChanged: (v) => setState(() => _dataSaver = v),
                ),
              ),
            ],
          ),

          _Section(l.gallerySectionIcons),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final icon in AppIcons.values)
                Tooltip(
                  message: icon.file,
                  child: AppIcon(icon),
                ),
            ],
          ),

          _Section(l.gallerySectionSkeletons),
          const SkeletonScope(
            child: Column(
              children: [
                SkeletonListingCard(),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: SkeletonGridCard()),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(child: SkeletonGridCard()),
                  ],
                ),
              ],
            ),
          ),

          _Section(l.gallerySectionStates),
          _StateFrame(child: EmptyState(onAction: () {})),
          const _Gap(),
          _StateFrame(child: ErrorState(onRetry: () {})),
          const _Gap(),
          _StateFrame(
            height: 640,
            child: OfflineState(onRetry: () {}, onOpenFavorites: () {}),
          ),

          _Section(l.gallerySectionSheets),
          AppButton(
            label: l.gallerySheetOpen,
            variant: AppButtonVariant.secondary,
            onPressed: () => showAppSheet<void>(
              context,
              title: l.gallerySheetTitle,
              builder: (context) => Text(
                l.gallerySheetBody,
                style: context.text.body,
              ),
              footerBuilder: (context) => AppButton(
                label: l.actionConfirm,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          top: AppSpacing.xl,
          bottom: AppSpacing.sm,
        ),
        child: Text(title, style: context.text.titleLg),
      );
}

class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: AppSpacing.sm);
}

class _StateFrame extends StatelessWidget {
  const _StateFrame({required this.child, this.height = 420});

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: context.colors.sand,
          borderRadius: AppRadius.cardAll,
          border: Border.all(color: context.colors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: child,
      );
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    final swatches = <(String, Color, Color)>[
      ('sand', c.sand, c.ink),
      ('surface', c.surface, c.ink),
      ('sand-deep', c.sandDeep, c.ink),
      ('line', c.line, c.ink),
      ('ink', c.ink, c.sand),
      ('ink-muted', c.inkMuted, c.sand),
      ('terracotta', c.terracotta, c.onTerracotta),
      ('terracotta-press', c.terracottaPress, c.onTerracotta),
      ('terracotta-soft', c.terracottaSoft, c.terracotta),
      ('gum', c.gum, c.onGum),
      ('gum-soft', c.gumSoft, c.gumText),
      ('acacia', c.acacia, c.onAcacia),
      ('acacia-soft', c.acaciaSoft, c.acacia),
      ('danger', c.danger, c.surface),
      ('danger-soft', c.dangerSoft, c.danger),
    ];
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final (name, bg, fg) in swatches)
          Container(
            width: 104,
            height: 56,
            padding: const EdgeInsetsDirectional.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: AppRadius.controlAll,
              border: Border.all(color: c.line),
            ),
            alignment: AlignmentDirectional.bottomStart,
            child: Text(
              name,
              style: context.text.caption.copyWith(color: fg),
              textDirection: TextDirection.ltr,
            ),
          ),
      ],
    );
  }
}

class _TypeSamples extends StatelessWidget {
  const _TypeSamples({required this.l});

  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.appName, style: t.display),
        Text(l.appTagline, style: t.titleLg),
        Text(l.galleryListingTitle1, style: t.title),
        Text(formatPrice(45000), style: t.price),
        Text(l.galleryCardBody, style: t.bodyLg),
        Text(l.galleryCardBody, style: t.body),
        Text(l.negotiable, style: t.label),
        Text(l.timeAgoHours(formatNumberAr(3)), style: t.caption),
      ],
    );
  }
}
