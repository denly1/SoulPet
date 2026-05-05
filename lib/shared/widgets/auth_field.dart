import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// Frosted-glass pill input used across the auth flow (login, register,
/// forgot-password). Visually similar to [PillTextField] but with a leading
/// icon that sits flush (no circle background) and an optional trailing
/// suffix icon — matching the existing auth-screen design.
///
/// Crucially, the validation error is rendered as a polished animated label
/// **below** the pill instead of using Flutter's built-in [InputDecorator]
/// error, which used to leak past the pill bounds and look cramped.
class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final bool disableAutofill;

  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.onChanged,
    this.disableAutofill = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late final FocusNode _focusNode;
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
        : (focused
            ? AppColors.deepMoss
            : Colors.white.withValues(alpha: 0.55));

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
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                onChanged: widget.onChanged,
                autofillHints: widget.disableAutofill ? const [] : null,
                enableSuggestions: !widget.disableAutofill,
                autocorrect: !widget.disableAutofill,
                validator: (v) {
                  final res = widget.validator?.call(v);
                  // Defer setState until after this build pass — Flutter
                  // validates synchronously inside `Form.validate()`.
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
                  hintStyle:
                      TextStyle(color: AppColors.textHint, fontSize: 15),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 4),
                    child: Icon(
                      widget.icon,
                      color: AppColors.deepMoss,
                      size: 20,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 24,
                  ),
                  suffixIcon: widget.suffixIcon != null
                      ? GestureDetector(
                          onTap: widget.onSuffixTap,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14, left: 4),
                            child: Icon(
                              widget.suffixIcon,
                              color: AppColors.textHint,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 38,
                    minHeight: 24,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  // Collapse the built-in error to zero — we render our own
                  // below so it sits cleanly inside the form's column.
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                  filled: false,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        // Custom error label — animated, indented to line up with the field's
        // text and constrained to the pill's width so multi-line errors wrap
        // instead of bleeding past the form's edges.
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topLeft,
          child: hasError
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: 22, top: 6, right: 12),
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
