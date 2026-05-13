import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/l10n/locale_provider.dart';
import 'package:soulpet/core/l10n/s.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _menuOpen = false;
  late final AnimationController _menuAnim;
  late final Animation<double> _menuFade;
  late final Animation<Offset> _menuSlide;

  @override
  void initState() {
    super.initState();
    LocaleProvider.instance.addListener(_onLocaleChanged);
    _menuAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _menuFade = CurvedAnimation(parent: _menuAnim, curve: Curves.easeOut);
    _menuSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _menuAnim, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    LocaleProvider.instance.removeListener(_onLocaleChanged);
    _menuAnim.dispose();
    super.dispose();
  }

  void _onLocaleChanged() => setState(() {});

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    if (_menuOpen) {
      _menuAnim.forward();
    } else {
      _menuAnim.reverse();
    }
  }

  Future<void> _logout() async {
    await sl<AuthLocalDatasource>().clearTokens();
    if (mounted) context.go(AppRoutes.login);
  }

  void _showProfile() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (_) => _ProfileSheet(onLogout: _logout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8EDE0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Pet home — fills entire safe area ──
              const Positioned.fill(
                child: _PetHomeArea(),
              ),

              // ── Top status bar — shown only when menu is open ──
              AnimatedBuilder(
                animation: _menuFade,
                builder: (_, __) => Opacity(
                  opacity: _menuFade.value,
                  child: IgnorePointer(
                    ignoring: !_menuOpen,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: _TopBar(onProfile: _showProfile),
                    ),
                  ),
                ),
              ),

              // ── Floating action bubbles — shown only when open ──
              Positioned(
                left: 0,
                right: 0,
                bottom: 88,
                child: SlideTransition(
                  position: _menuSlide,
                  child: FadeTransition(
                    opacity: _menuFade,
                    child: IgnorePointer(
                      ignoring: !_menuOpen,
                      child: _ActionBubbles(
                        onChat: () {
                          _toggleMenu();
                          context.push(AppRoutes.chat);
                        },
                        onClose: _toggleMenu,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Paw button at bottom center ──
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: _PawButton(
                    isOpen: _menuOpen,
                    onTap: _toggleMenu,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pet home — frameless, full screen ────────────────────────────────────────

class _PetHomeArea extends StatelessWidget {
  const _PetHomeArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LiquidGlassCircle(
          size: 110,
          child: const Icon(Icons.home_rounded, size: 52, color: AppColors.deepMoss),
        ),
        const SizedBox(height: 20),
        Text(
          S.petHome,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Top bar with status pills ─────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onProfile;
  const _TopBar({required this.onProfile});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH:mm').format(DateTime.now());
    return Row(
      children: [
        _SPill(child: Text(time,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w700))),
        const SizedBox(width: 6),
        _SPill(child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.monetization_on_rounded, size: 12, color: AppColors.deepMoss),
          SizedBox(width: 4),
          Text('423', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 6),
        _SPill(child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.mail_outline_rounded, size: 12, color: AppColors.deepMoss),
          SizedBox(width: 4),
          Text('2', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        ])),
        const Spacer(),
        _SPill(child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.wb_sunny_outlined, size: 12, color: AppColors.deepMoss),
          SizedBox(width: 4),
          Text('19°C', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onProfile,
          child: LiquidGlassCircle(
            size: 36,
            child: const Icon(Icons.person_rounded, size: 18, color: AppColors.deepMoss),
          ),
        ),
      ],
    );
  }
}

class _SPill extends StatelessWidget {
  final Widget child;
  const _SPill({required this.child});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 50,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: child,
    );
  }
}

// ── Action bubbles ────────────────────────────────────────────────────────────

class _ActionBubbles extends StatelessWidget {
  final VoidCallback onChat;
  final VoidCallback onClose;

  const _ActionBubbles({required this.onChat, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final items = [
      _BubbleItem(Icons.sports_esports_rounded, S.games, () {}),
      _BubbleItem(Icons.favorite_rounded, S.buddy, () {}),
      _BubbleItem(Icons.chat_bubble_rounded, S.chat, onChat),
      _BubbleItem(Icons.lunch_dining_rounded, S.food, () {}),
      _BubbleItem(Icons.storefront_rounded, S.shop, () {}),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: items.map((item) => _FloatingBubble(item: item)).toList(),
      ),
    );
  }
}

class _BubbleItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BubbleItem(this.icon, this.label, this.onTap);
}

class _FloatingBubble extends StatelessWidget {
  final _BubbleItem item;
  const _FloatingBubble({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LiquidGlassCircle(
            size: 58,
            child: Icon(item.icon, size: 26, color: AppColors.deepMoss),
          ),
          const SizedBox(height: 6),
          Text(
            item.label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Paw button ────────────────────────────────────────────────────────────────

class _PawButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;
  const _PawButton({required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        borderRadius: 50,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isOpen ? Icons.close_rounded : Icons.pets_rounded,
            key: ValueKey(isOpen),
            size: 26,
            color: AppColors.deepMoss,
          ),
        ),
      ),
    );
  }
}

// ── Profile bottom sheet ─────────────────────────────────────────────────────

class _ProfileSheet extends StatelessWidget {
  final VoidCallback onLogout;
  const _ProfileSheet({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: LiquidGlassCard(
        borderRadius: 32,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.mistBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            LiquidGlassCircle(
              size: 80,
              child: const Icon(Icons.person_rounded, size: 40, color: AppColors.deepMoss),
            ),
            const SizedBox(height: 14),
            Text(S.myProfile,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(S.userSubtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 28),
            _SheetItem(icon: Icons.settings_outlined, label: S.settings,
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 12),
            _SheetItem(icon: Icons.notifications_outlined, label: S.notifications,
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 12),
            _SheetItem(icon: Icons.help_outline_rounded, label: S.help,
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.25), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
                    const SizedBox(width: 10),
                    Text(S.signOut,
                        style: const TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SheetItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.deepMoss, size: 22),
            const SizedBox(width: 14),
            Text(label,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
