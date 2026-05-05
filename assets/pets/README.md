# Pet portraits

Drop the realistic AI-generated portraits here:

- `cat.webp` — used everywhere `CatIllustration` / `AnimatedPet(isCat: true)` is rendered
- `dog.webp` — used everywhere `DogIllustration` / `AnimatedPet(isCat: false)` is rendered

`.png` works too — just update the `asset:` path inside `pet_illustrations.dart`.

Recommended:

- Square aspect ratio (1:1)
- 1024×1024 px or larger PNG with a transparent background
- Subject centred, looking slightly toward the camera
- Soft, warm lighting that fits the green liquid-glass app palette

When the files are missing, the app falls back to the chibi `CustomPainter`
artwork so the screens never break in dev.
