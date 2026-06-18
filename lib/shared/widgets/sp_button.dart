import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';

class SpButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final Color? color;
  final double height;

  const SpButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.color,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color ?? AppColors.primaryLight, width: 1.5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _child(color ?? AppColors.primaryLight),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _child(AppColors.textLight),
      ),
    );
  }

  Widget _child(Color textColor) {
    if (loading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          color: textColor.withValues(alpha: 0.8),
          strokeWidth: 2.5,
        ),
      );
    }
    return Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Nunito',
      ),
    );
  }
}
