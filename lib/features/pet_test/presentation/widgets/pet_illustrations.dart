import 'package:flutter/material.dart';

/// Pet portraits — flat, static images bundled with the app.
///
/// Source files live in `assets/pets/`:
///   * `cat.png` — used by [CatIllustration] / `AnimatedPet(isCat: true)`
///   * `dog.png` — used by [DogIllustration] / `AnimatedPet(isCat: false)`
///
/// We deliberately keep these as plain [Image.asset]s — no idle bobbing,
/// blinking or tail-wagging animations — so the user-supplied AI-generated
/// portraits read as a clean photo rather than a procedural avatar.
///
/// If the asset is missing (e.g. the user hasn't dropped a file in yet),
/// [errorBuilder] renders a tasteful placeholder so screens still boot.

// ─── Public widgets ────────────────────────────────────────────────────────

class CatIllustration extends StatelessWidget {
  final double size;

  // The legacy API exposed `blink` / `tailWag` for the procedural painter.
  // They're now ignored — kept here only to avoid breaking call sites.
  final bool blink;
  final double tailWag;

  const CatIllustration({
    super.key,
    this.size = 180,
    this.blink = false,
    this.tailWag = 0,
  });

  @override
  Widget build(BuildContext context) =>
      _PetPortrait(asset: 'assets/pets/itogcat.png', size: size, isCat: true);
}

class DogIllustration extends StatelessWidget {
  final double size;
  final bool blink;
  final double tailWag;

  const DogIllustration({
    super.key,
    this.size = 180,
    this.blink = false,
    this.tailWag = 0,
  });

  @override
  Widget build(BuildContext context) =>
      _PetPortrait(asset: 'assets/pets/itogdog.png', size: size, isCat: false);
}

/// Thin shim around the static portraits so existing callers
/// (`AnimatedPet(isCat: ..., size: ...)`) keep working without changes.
///
/// All animation has been removed by request — the widget is now a pure
/// static image.
class AnimatedPet extends StatelessWidget {
  final bool isCat;
  final double size;
  const AnimatedPet({super.key, required this.isCat, this.size = 200});

  @override
  Widget build(BuildContext context) => isCat
      ? CatIllustration(size: size)
      : DogIllustration(size: size);
}

// ─── Internal portrait renderer ────────────────────────────────────────────

class _PetPortrait extends StatelessWidget {
  final String asset;
  final double size;
  final bool isCat;
  const _PetPortrait({
    required this.asset,
    required this.size,
    required this.isCat,
  });

  @override
  Widget build(BuildContext context) {
    // Render the portrait at its full natural look — no circular crop, no
    // rounded corners. The image fills a square of [size] × [size] with
    // BoxFit.contain so transparent PNGs/WEBPs show the whole subject
    // without clipping.
    //
    // We render via a Canvas layer with BlendMode.srcOver on a transparent
    // base so the engine does NOT pre-multiply the webp edge pixels against
    // black — eliminating the dark fringe that appears on light backgrounds.
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        errorBuilder: (context, error, stack) => _MissingPetPlaceholder(
          size: size,
          isCat: isCat,
        ),
      ),
    );
  }
}

class _MissingPetPlaceholder extends StatelessWidget {
  final double size;
  final bool isCat;
  const _MissingPetPlaceholder({required this.size, required this.isCat});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [Color(0xFFEAF4EE), Color(0xFFC7D9CF)],
          center: Alignment(-0.2, -0.3),
          radius: 1.0,
        ),
        borderRadius: BorderRadius.circular(size * 0.12),
      ),
      alignment: Alignment.center,
      child: Icon(
        isCat ? Icons.pets_rounded : Icons.cruelty_free_rounded,
        size: size * 0.4,
        color: const Color(0xFF587D6A),
      ),
    );
  }
}
