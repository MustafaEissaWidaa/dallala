import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import '../theme/app_tokens.dart';
import '../utils/formatters.dart';
import 'app_icon.dart';

/// Labelled text input (radius 14, surface fill). Shows a live
/// character counter in Eastern Arabic digits when [maxLength] is set.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.textDirection,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final bool autofocus;

  /// Force a direction, e.g. LTR for phone numbers.
  final TextDirection? textDirection;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.text;
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null || widget.maxLength != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                if (widget.label != null)
                  Expanded(child: Text(widget.label!, style: t.label)),
                if (widget.maxLength != null)
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, value, _) => Text(
                      formatCounterAr(value.text.characters.length,
                              widget.maxLength!)
                          .replaceAll(' ', ''),
                      style: t.caption,
                    ),
                  ),
              ],
            ),
          ),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          textDirection: widget.textDirection,
          style: t.bodyLg,
          cursorColor: c.terracotta,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            // Our own counter is shown next to the label.
            counterText: '',
            constraints: const BoxConstraints(minHeight: AppSizes.inputHeight),
          ),
        ),
      ],
    );
  }
}

/// Pill-shaped search field (radius 999) used on Home, Categories and Search.
/// When [onTap] is set it renders read-only and acts as a button.
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    const border = OutlineInputBorder(
      borderRadius: AppRadius.pillAll,
      borderSide: BorderSide.none,
    );
    return Container(
      height: AppSizes.searchBarHeight,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: AppRadius.pillAll,
        border: Border.all(color: c.line),
      ),
      child: TextField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        autofocus: autofocus,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
        style: t.bodyLg,
        cursorColor: c.terracotta,
        decoration: InputDecoration(
          hintText: hint,
          filled: false,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
          contentPadding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.sm,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: AppSpacing.md,
              end: AppSpacing.xs,
            ),
            child: AppIcon(AppIcons.search, color: c.inkMuted),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: AppSizes.minTouch,
            minHeight: AppSizes.minTouch,
          ),
        ),
      ),
    );
  }
}
