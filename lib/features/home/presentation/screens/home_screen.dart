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
    _TabInfo(Icons.home_outlined, 'Дом'),
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.warmGradient),
        child: SafeArea(
          child: isLandscape ? _buildLandscape() : _buildPortrait(),
        ),
      ),
    );
  }

  // ── Portrait layout ──
  Widget _buildPortrait() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: _buildTabContent()),
        const SizedBox(height: 8),
        _buildFloatingNav(),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Landscape layout ──
  Widget _buildLandscape() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_tabs.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: _buildNavIcon(i),
              );
            }),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ],
    );
  }

  // ── Header ──
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 4),
      child: Row(
        children: [
          LiquidGlassCircle(
            size: 40,
            child: Icon(Icons.pets_rounded,
                color: AppColors.deepMoss, size: 20),
          ),
          const SizedBox(width: 10),
          Text(
            'Soulpet',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          LiquidGlassCircle(
            size: 36,
            onTap: () {},
            child: Icon(Icons.notifications_none_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 8),
          LiquidGlassCircle(
            size: 36,
            onTap: () {},
            child: Icon(Icons.settings_outlined,
                color: AppColors.textSecondary, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Floating round glass nav icons ──
  Widget _buildFloatingNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_tabs.length, (i) => _buildNavIcon(i)),
      ),
    );
  }

  Widget _buildNavIcon(int i) {
    final isSelected = i == _selectedTab;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = i),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: isSelected ? 56 : 48,
            height: isSelected ? 56 : 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isSelected
                    ? [
                        AppColors.softJade.withValues(alpha: 0.7),
                        AppColors.liquidGreen.withValues(alpha: 0.35),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.5),
                        Colors.white.withValues(alpha: 0.18),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: isSelected
                    ? AppColors.deepMoss.withValues(alpha: 0.35)
                    : AppColors.glassBorder,
                width: 0.8,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.liquidGreen.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 1,
                      )
                    ]
                  : AppColors.glassShadow,
            ),
            child: Icon(
              _tabs[i].icon,
              size: isSelected ? 24 : 21,
              color: isSelected ? AppColors.deepMoss : AppColors.textHint,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _tabs[i].label,
            style: TextStyle(
              color: isSelected ? AppColors.deepMoss : AppColors.textHint,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
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

  // ── Home tab — pet's home (main screen per skeleton) ──
  Widget _buildHomeTab() {
    return Column(
      children: [
        // Pet's home — main area
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Room / interior placeholder
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.frostedSage.withValues(alpha: 0.4),
                        AppColors.glassMint.withValues(alpha: 0.6),
                        AppColors.pearlFog.withValues(alpha: 0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.weekend_outlined,
                          size: 48,
                          color: AppColors.liquidGreen.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Дом питомца',
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Pet placeholder (center of the room)
              LiquidGlassCircle(
                size: 130,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pets_rounded,
                        size: 52,
                        color: AppColors.deepMoss.withValues(alpha: 0.5)),
                    const SizedBox(height: 4),
                    Text(
                      'Питомец',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Pet speech bubble (occasional messages from pet)
              Positioned(
                top: 32,
                child: LiquidGlassPill(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome_rounded,
                          size: 14, color: AppColors.deepMoss),
                      const SizedBox(width: 6),
                      Text(
                        'Привет! Я рад тебя видеть.',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Action panel — feed / pet / play / talk
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.restaurant_outlined, 'Покормить'),
              _buildActionButton(Icons.favorite_outline_rounded, 'Погладить'),
              _buildActionButton(Icons.sports_esports_outlined, 'Поиграть'),
              _buildActionButton(Icons.chat_outlined, 'Поговорить'),
            ],
          ),
        ),
      ],
    );
  }

  // ── Action button for pet interactions ──
  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LiquidGlassCircle(
            size: 52,
            child: Icon(icon, color: AppColors.deepMoss, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ── Profile tab ──
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
