import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/constants/app_colors.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/core/router/app_router.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  static const _tabs = [
    _TabInfo(Icons.spa_outlined, 'Главная'),
    _TabInfo(Icons.forum_outlined, 'Чат'),
    _TabInfo(Icons.local_mall_outlined, 'Магазин'),
    _TabInfo(Icons.extension_outlined, 'Игры'),
    _TabInfo(Icons.account_circle_outlined, 'Профиль'),
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
        // Side nav in landscape
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
          _GlassCircle(
            size: 40,
            child: Icon(Icons.spa_rounded,
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
          _GlassCircle(
            size: 36,
            onTap: () {},
            child: Icon(Icons.tune_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
          const SizedBox(width: 8),
          _GlassCircle(
            size: 36,
            onTap: _logout,
            child: Icon(Icons.logout_rounded,
                color: AppColors.textSecondary, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Floating round glass nav icons (bottom, no bar) ──
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
                width: 1.5,
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
            Icons.forum_outlined, 'AI Чат', 'Общение с питомцем через AI');
      case 2:
        return _buildPlaceholder(Icons.local_mall_outlined, 'Магазин',
            'Предметы и аксессуары для питомца');
      case 3:
        return _buildPlaceholder(Icons.extension_outlined, 'Мини-игры',
            'Игры для развлечения питомца');
      case 4:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  // ── Home tab ──
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Welcome glass card
          _GlassCard(
            child: Column(
              children: [
                Text(
                  'Добро пожаловать!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Заботься о своём питомце',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                _GlassCircle(
                  size: 110,
                  child: Icon(Icons.spa_rounded,
                      size: 52,
                      color: AppColors.deepMoss.withValues(alpha: 0.45)),
                ),
                const SizedBox(height: 14),
                Text(
                  'Твой питомец',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _GlassMenuItem(
            icon: Icons.favorite_outline_rounded,
            title: 'Здоровье',
            subtitle: 'Отслеживай состояние питомца',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _GlassMenuItem(
            icon: Icons.forum_outlined,
            title: 'AI Чат',
            subtitle: 'Общайся с помощником',
            onTap: () => setState(() => _selectedTab = 1),
          ),
          const SizedBox(height: 10),
          _GlassMenuItem(
            icon: Icons.lightbulb_outline_rounded,
            title: 'Советы и статьи',
            subtitle: 'Полезная информация',
            onTap: () {},
          ),
          const SizedBox(height: 20),
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
          _GlassCircle(
            size: 88,
            child: Icon(Icons.account_circle_outlined,
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
          _GlassMenuItem(
            icon: Icons.edit_outlined,
            title: 'Редактировать профиль',
            subtitle: 'Имя, аватар, настройки',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _GlassMenuItem(
            icon: Icons.spa_outlined,
            title: 'Мой питомец',
            subtitle: 'Информация о питомце',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _GlassMenuItem(
            icon: Icons.inventory_2_outlined,
            title: 'Инвентарь',
            subtitle: 'Предметы и аксессуары',
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _GlassMenuItem(
            icon: Icons.logout_rounded,
            title: 'Выйти',
            subtitle: 'Выход из аккаунта',
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
          _GlassCircle(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: AppColors.glassBlurSigmaSmall,
                sigmaY: AppColors.glassBlurSigmaSmall,
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: AppColors.glassGradient,
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(
                  'Скоро',
                  style: TextStyle(
                    color: AppColors.deepMoss,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable glass widgets ──

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigma,
          sigmaY: AppColors.glassBlurSigma,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: AppColors.glassGradient,
            border: Border.all(color: AppColors.glassBorder, width: 0.8),
            boxShadow: AppColors.glassShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  final double size;
  final Widget child;
  final VoidCallback? onTap;
  const _GlassCircle({required this.size, required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppColors.glassBlurSigmaSmall,
          sigmaY: AppColors.glassBlurSigmaSmall,
        ),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.glassGradientStrong,
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: AppColors.glassShadow,
          ),
          child: Center(child: child),
        ),
      ),
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

class _GlassMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _GlassMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppColors.glassBlurSigma,
            sigmaY: AppColors.glassBlurSigma,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: AppColors.glassGradient,
              border: Border.all(color: AppColors.glassBorder, width: 0.8),
              boxShadow: AppColors.glassShadow,
            ),
            child: Row(
              children: [
                _GlassCircle(
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
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint, size: 22),
              ],
            ),
          ),
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
