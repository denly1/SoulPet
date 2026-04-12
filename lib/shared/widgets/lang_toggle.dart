import 'package:flutter/material.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

/// A pill-shaped EN/RU toggle button using LiquidGlassCard.
class LangToggle extends StatefulWidget {
  const LangToggle({super.key});

  @override
  State<LangToggle> createState() => _LangToggleState();
}

class _LangToggleState extends State<LangToggle> {
  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRu = LocaleProvider.instance.isRu;
    return GestureDetector(
      onTap: () => LocaleProvider.instance.toggle(),
      child: LiquidGlassCard(
        borderRadius: 50,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'EN',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isRu ? AppColors.textHint : AppColors.deepMoss,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 1,
              height: 14,
              color: AppColors.textHint.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 6),
            Text(
              'RU',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isRu ? AppColors.deepMoss : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
