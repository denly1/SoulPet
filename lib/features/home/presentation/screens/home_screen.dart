import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/shared/widgets/liquid_glass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  static const _tabs = [
    _TabInfo(Icons.home_rounded, 'Главная'),
    _TabInfo(Icons.chat_bubble_outline_rounded, 'Чат'),
    _TabInfo(Icons.extension_outlined, 'Игры'),
    _TabInfo(Icons.storefront_outlined, 'Магазин'),
    _TabInfo(Icons.person_outline_rounded, 'Профиль'),
  ];

  Future<void> _logout() async {
    await sl<AuthLocalDatasource>().clearTokens();
    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer 0 — rich decorative background (the glass blurs THIS)
          const Positioned.fill(child: _DecorativeBackground()),
          // Layer 1 — UI content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildTabContent()),
                const SizedBox(height: 6),
                _buildBottomNav(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 14, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Привет!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          LiquidGlassCircle(
            size: 40,
            onTap: () {},
            child: Icon(Icons.notifications_none_rounded,
                color: AppColors.deepMoss, size: 20),
          ),
          const SizedBox(width: 8),
          LiquidGlassCircle(
            size: 40,
            onTap: () {},
            child: Icon(Icons.person_outline_rounded,
                color: AppColors.deepMoss, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Bottom navigation (glass pill bar) ──
  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LiquidGlassCard(
        borderRadius: 28,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_tabs.length, (i) {
            final isSelected = i == _selectedTab;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 16 : 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isSelected
                      ? AppColors.deepMoss.withValues(alpha: 0.15)
                      : Colors.transparent,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabs[i].icon,
                      size: 22,
                      color: isSelected
                          ? AppColors.deepMoss
                          : AppColors.textHint,
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        _tabs[i].label,
                        style: TextStyle(
                          color: AppColors.deepMoss,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Tab content ──
  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildPlaceholder(
          Icons.chat_bubble_outline_rounded,
          'Чат с питомцем',
          'Здесь появится возможность поговорить с питомцем',
        );
      case 2:
        return _buildPlaceholder(
          Icons.extension_outlined,
          'Мини-игры',
          'Игры и развлечения вместе с питомцем',
        );
      case 3:
        return _buildPlaceholder(
          Icons.storefront_outlined,
          'Магазин',
          'Еда, игрушки и украшения для дома',
        );
      case 4:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // ── Home tab — pet card with status + actions ──
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Main pet card — the "home" of the pet
          LiquidGlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet name & mood
                Row(
                  children: [
                    Text(
                      'Питомец',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.pets_rounded,
                        size: 20, color: AppColors.deepMoss),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Ждёт тебя дома',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // Pet avatar area (room placeholder)
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.softJade.withValues(alpha: 0.5),
                        AppColors.glassMint.withValues(alpha: 0.7),
                        AppColors.liquidGreen.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pets_rounded,
                            size: 64,
                            color: AppColors.deepMoss.withValues(alpha: 0.4)),
                        const SizedBox(height: 8),
                        Text(
                          'Дом питомца',
                          style: TextStyle(
                            color: AppColors.deepMoss.withValues(alpha: 0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Mood pill
                LiquidGlassPill(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sentiment_very_satisfied_rounded,
                          size: 18, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'Настроение  ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Отличное',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Satiety bar
                LiquidGlassPill(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.restaurant_rounded,
                          size: 16, color: AppColors.deepMoss),
                      const SizedBox(width: 8),
                      Text(
                        'Сытость',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 80,
                        height: 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.8,
                            backgroundColor:
                                AppColors.mistBorder.withValues(alpha: 0.4),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.deepMoss),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '80%',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Action buttons — feed / play / pet
                Row(
                  children: [
                    Expanded(
                        child: _buildActionCard(
                            Icons.restaurant_rounded, 'Покормить')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildActionCard(
                            Icons.sports_esports_rounded, 'Поиграть')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _buildActionCard(
                            Icons.favorite_rounded, 'Погладить')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Bottom row — schedule + AI chat preview
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Schedule card
              Expanded(
                child: LiquidGlassCard(
                  borderRadius: 22,
                  padding: const EdgeInsets.all(14),
                  dense: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 16, color: AppColors.deepMoss),
                          const SizedBox(width: 6),
                          Text(
                            'Расписание',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildScheduleRow('08:00', 'Утренняя прогулка'),
                      const SizedBox(height: 6),
                      _buildScheduleRow('20:00', 'Вечернее кормление'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // AI chat preview card
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedTab = 1),
                  child: LiquidGlassCard(
                    borderRadius: 22,
                    padding: const EdgeInsets.all(14),
                    dense: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome_rounded,
                                size: 16, color: AppColors.deepMoss),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Чат с питомцем',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Привет! Не забудь про вечернюю прогулку.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LiquidGlassPill(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_rounded,
                                  size: 14, color: AppColors.deepMoss),
                              const SizedBox(width: 4),
                              Text(
                                'Поговорить',
                                style: TextStyle(
                                  color: AppColors.deepMoss,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Action card (square glass button inside pet card) ──
  Widget _buildActionCard(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: LiquidGlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.symmetric(vertical: 14),
        dense: true,
        child: Column(
          children: [
            Icon(icon, color: AppColors.deepMoss, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Schedule row ──
  Widget _buildScheduleRow(String time, String title) {
    return Row(
      children: [
        Icon(Icons.access_time_rounded,
            size: 14, color: AppColors.textHint),
        const SizedBox(width: 6),
        Text(
          time,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.check_circle_rounded,
            size: 16, color: AppColors.success),
      ],
    );
  }

  // ── Profile tab ──
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 28),
          LiquidGlassCircle(
            size: 88,
            child: Icon(Icons.person_outline_rounded,
                size: 44, color: AppColors.deepMoss),
          ),
          const SizedBox(height: 14),
          Text(
            'Пользователь',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'user@soulpet.app',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 28),
          _buildMenuItem(
            icon: Icons.edit_outlined,
            title: 'Редактировать профиль',
            subtitle: 'Имя, аватар, настройки',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.pets_outlined,
            title: 'Мой питомец',
            subtitle: 'Характер, стадия роста',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Инвентарь',
            subtitle: 'Еда, игрушки, предметы',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            title: 'Выйти из аккаунта',
            subtitle: '',
            onTap: _logout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Placeholder tab ──
  Widget _buildPlaceholder(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LiquidGlassCircle(
            size: 100,
            child: Icon(icon, size: 46, color: AppColors.deepMoss),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),
          LiquidGlassPill(
            child: Text(
              'Скоро',
              style: TextStyle(
                color: AppColors.deepMoss,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Menu item (glass row) ──
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        dense: true,
        child: Row(
          children: [
            LiquidGlassCircle(
              size: 42,
              child: Icon(icon, color: AppColors.deepMoss, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}

class _TabInfo {
  final IconData icon;
  final String label;
  const _TabInfo(this.icon, this.label);
}

/// Rich decorative background with green blobs, gradients, and leaf-like shapes.
/// This provides the colourful content that glass cards blur and tint.
class _DecorativeBackground extends StatelessWidget {
  const _DecorativeBackground();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFD6EDDC),
            Color(0xFFE8F5EC),
            Color(0xFFF2F8F4),
            Color(0xFFE0EDE4),
          ],
          stops: [0.0, 0.3, 0.65, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(
        size: size,
        painter: _FoliagePainter(),
      ),
    );
  }
}

/// Paints decorative green blobs and highlights to simulate foliage.
class _FoliagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Large soft green blobs (top-left, bottom-right, center)
    final blobs = [
      _Blob(Offset(w * 0.10, h * 0.05), w * 0.45, const Color(0x3068B880)),
      _Blob(Offset(w * 0.85, h * 0.12), w * 0.38, const Color(0x2890C9A0)),
      _Blob(Offset(w * 0.50, h * 0.40), w * 0.55, const Color(0x187DB893)),
      _Blob(Offset(w * 0.15, h * 0.75), w * 0.42, const Color(0x2A7EC29A)),
      _Blob(Offset(w * 0.80, h * 0.80), w * 0.50, const Color(0x2269A87B)),
      _Blob(Offset(w * 0.40, h * 0.95), w * 0.35, const Color(0x1C5E9A72)),
      // Warm accent
      _Blob(Offset(w * 0.70, h * 0.55), w * 0.30, const Color(0x14A8D4B8)),
      // Top-right light
      _Blob(Offset(w * 0.95, h * 0.02), w * 0.30, const Color(0x20E0F0E6)),
    ];

    for (final blob in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [blob.color, blob.color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: blob.center, radius: blob.radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      canvas.drawCircle(blob.center, blob.radius, paint);
    }

    // Small bright leaf-like dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      final dx = rng.nextDouble() * w;
      final dy = rng.nextDouble() * h;
      final r = 3.0 + rng.nextDouble() * 8;
      dotPaint.color = Color.fromRGBO(
        100 + rng.nextInt(50),
        170 + rng.nextInt(50),
        120 + rng.nextInt(40),
        0.15 + rng.nextDouble() * 0.15,
      );
      canvas.drawCircle(Offset(dx, dy), r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Blob {
  final Offset center;
  final double radius;
  final Color color;
  const _Blob(this.center, this.radius, this.color);
}
