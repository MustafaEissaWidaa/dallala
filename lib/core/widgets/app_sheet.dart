import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';

/// Opens a themed modal bottom sheet with a title, scrollable body and an
/// optional sticky footer (e.g. «اعرض [N] إعلان»).
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  WidgetBuilder? footerBuilder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _SheetBody(
      title: title,
      builder: builder,
      footerBuilder: footerBuilder,
    ),
  );
}

class _SheetBody extends StatelessWidget {
  const _SheetBody({
    required this.title,
    required this.builder,
    this.footerBuilder,
  });

  final String title;
  final WidgetBuilder builder;
  final WidgetBuilder? footerBuilder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: AppSpacing.screen,
            child: Text(title, style: context.text.title),
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: SingleChildScrollView(
              padding: AppSpacing.screen,
              child: builder(context),
            ),
          ),
          if (footerBuilder != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(AppSpacing.md),
                  child: footerBuilder!(context),
                ),
              ),
            )
          else
            const SafeArea(top: false, child: SizedBox(height: AppSpacing.md)),
        ],
      ),
    );
  }
}
