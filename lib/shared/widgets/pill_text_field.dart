import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// A frosted-glass, pill-shaped text input with a leading icon and a smooth
/// focus state. Designed for short identity fields (nickname, age, pet name).
///
/// * Outer shell uses [LiquidGlassCard] with `borderRadius=50` so the field
///   matches the rest of the primary CTAs.
/// * Border switches to [AppColors.deepMoss] when focused, and to red when the
///   form validation fails.
/// * The `prefixIcon` lives in a small softly-tinted circle for extra polish.
class PillTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const PillTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  State<PillTextField> createState() => _PillTextFieldState();
}

class _PillTextFieldState extends State<PillTextField> {
  late final FocusNode _focusNode;
  // Tracks the current validation error so we can render it ourselves
  // below the pill (the built-in [InputDecorator] error is collapsed to
  // zero height — see `errorStyle` further down).
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;
    final hasError = _errorText != null;
    final accent = hasError
        ? AppColors.error
        : (focused ? AppColors.deepMoss : Colors.white.withValues(alpha: 0.55));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              if (focused)
                BoxShadow(
                  color: AppColors.deepMoss.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
            ],
          ),
          child: LiquidGlassCard(
            borderRadius: 50,
            padding: EdgeInsets.zero,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: accent,
                  width: focused || hasError ? 1.6 : 1,
                ),
              ),
              child: TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,
                keyboardType: widget.keyboardType,
                textCapitalization: widget.textCapitalization,
                inputFormatters: widget.inputFormatters,
                onChanged: widget.onChanged,
                validator: (v) {
                  final res = widget.validator?.call(v);
                  // Defer setState until after this build pass — Flutter
                  // validates synchronously inside `Form.validate()`, and
                  // calling setState here would assert.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    if (res != _errorText) setState(() => _errorText = res);
                  });
                  return res;
                },
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: TextStyle(color: AppColors.textHint, fontSize: 15),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 6, 0),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: focused
                            ? AppColors.deepMoss.withValues(alpha: 0.16)
                            : AppColors.softJade.withValues(alpha: 0.45),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        widget.icon,
                        color: AppColors.deepMoss,
                        size: 18,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 34,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  // Collapse the built-in error display — we render our own
                  // below so it gets proper indentation and breathing room.
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  filled: false,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
            ),
          ),
        ),
        // Custom error label — animated so it eases in/out without jumping
        // the form's layout. Indented to line up with the field's text
        // (just past the icon circle) instead of starting at the pill's edge.
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topLeft,
          child: hasError
              ? Padding(
                  padding: const EdgeInsets.only(left: 22, top: 6, right: 12),
                  child: Text(
                    _errorText!,
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }
}
