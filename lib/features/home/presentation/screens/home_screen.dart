import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _actionsVisible = false;

  Future<void> _logout() async {
    await sl<AuthLocalDatasource>().clearTokens();
    if (mounted) context.go(AppRoutes.login);
  }

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ProfileSheet(onLogout: _logout),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2F0E7),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                // ── Top status pills ──
                _TopBar(onProfile: () => _showProfile(context)),
                const SizedBox(height: 14),

                // ── Central pet home area (takes remaining space) ──
                Expanded(
                  child: _PetHomeArea(),
                ),
                const SizedBox(height: 14),

                // ── Action circles row ──
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    final fade = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    );
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(fade);
                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: _actionsVisible
                      ? _ActionRow(
                          key: const ValueKey('actions'),
                          onChat: () => context.push(AppRoutes.chat),
                        )
                      : const SizedBox(
                          key: ValueKey('actions-hidden'),
                          height: 0,
                        ),
                ),
                const SizedBox(height: 14),

                // ── Big paw pill ──
                _PawPill(
                  onTap: () {
                    setState(() {
                      _actionsVisible = !_actionsVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Top bar with status pills ─────────────────────────────────────────────────

class _TopBar extends StatefulWidget {
  final VoidCallback onProfile;
  const _TopBar({required this.onProfile});

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  late final String _time;

  @override
  void initState() {
    super.initState();
    _time = DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Pill(child: Text(_time,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w700))),
        const SizedBox(width: 7),
        _Pill(child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.monetization_on_rounded, size: 13, color: AppColors.deepMoss),
          const SizedBox(width: 4),
          const Text('423', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 7),
        _Pill(child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.mail_outline_rounded, size: 13, color: AppColors.deepMoss),
          const SizedBox(width: 4),
          const Text('2', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ])),
        const Spacer(),
        _Pill(child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.wb_sunny_outlined, size: 13, color: AppColors.deepMoss),
          const SizedBox(width: 4),
          const Text('19°C', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
        ])),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: widget.onProfile,
          child: LiquidGlassCircle(
            size: 40,
            child: const Icon(Icons.person_rounded, size: 20, color: AppColors.deepMoss),
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final Widget child;
  const _Pill({required this.child});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      child: child,
    );
  }
}

// ── Pet home central area ─────────────────────────────────────────────────────

class _PetHomeArea extends StatelessWidget {
  const _PetHomeArea();

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      borderRadius: 32,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pet home icon
          LiquidGlassCircle(
            size: 96,
            child: const Icon(Icons.home_rounded, size: 46, color: AppColors.deepMoss),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pet Home',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Mood: Excellent 😊',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const _StatusBar(label: 'Hunger', value: 0.75,
              color: AppColors.liquidGreen, icon: Icons.restaurant_rounded),
          const SizedBox(height: 10),
          const _StatusBar(label: 'Happiness', value: 0.88,
              color: AppColors.deepMoss, icon: Icons.favorite_rounded),
          const SizedBox(height: 10),
          const _StatusBar(label: 'Energy', value: 0.60,
              color: AppColors.softJade, icon: Icons.bolt_rounded),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;

  const _StatusBar({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 8),
        SizedBox(
          width: 72,
          child: Text(label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 7,
              backgroundColor: AppColors.frostedSage,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(value * 100).toInt()}%',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ── 5 action circles row ─────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final VoidCallback onChat;
  const _ActionRow({super.key, required this.onChat});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem(Icons.extension_rounded, 'Games', () {}),
      _ActionItem(Icons.pets_rounded, 'Buddy', () {}),
      _ActionItem(Icons.smart_toy_rounded, 'Conversate', onChat),
      _ActionItem(Icons.restaurant_rounded, 'Food', () {}),
      _ActionItem(Icons.shopping_bag_outlined, 'Shop', () {}),
    ];

    return LiquidGlassCard(
      borderRadius: 28,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          return GestureDetector(
            onTap: item.onTap,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlassCircle(
                  size: 56,
                  child: Icon(item.icon, size: 24, color: AppColors.deepMoss),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionItem(this.icon, this.label, this.onTap);
}

// ── Big paw pill ─────────────────────────────────────────────────────────────

class _PawPill extends StatelessWidget {
  final VoidCallback? onTap;
  const _PawPill({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        borderRadius: 50,
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
        child: const Icon(Icons.pets_rounded, size: 30, color: AppColors.deepMoss),
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
              child: Icon(Icons.person_rounded, size: 40, color: AppColors.deepMoss),
            ),
            const SizedBox(height: 14),
            Text('My Profile',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('Soul Pet user',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 28),
            _SheetItem(icon: Icons.settings_outlined, label: 'Settings',
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 12),
            _SheetItem(icon: Icons.notifications_outlined, label: 'Notifications',
                onTap: () => Navigator.pop(context)),
            const SizedBox(height: 12),
            _SheetItem(icon: Icons.help_outline_rounded, label: 'Help',
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
                    Text('Sign Out',
                        style: TextStyle(color: AppColors.error, fontSize: 15, fontWeight: FontWeight.w600)),
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
                style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}
