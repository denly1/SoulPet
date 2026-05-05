import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:soulpet/core/di/injection.dart';
import 'package:soulpet/data/datasources/local/auth_local_datasource.dart';
import 'package:soulpet/features/splash/presentation/splash_screen.dart';
import 'package:soulpet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/login_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/register_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_test_intro_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_test_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_result_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_manual_pick_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_setup_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/house_selection_screen.dart';
import 'package:soulpet/features/home/presentation/screens/home_screen.dart';
import 'package:soulpet/features/chat/presentation/screens/chat_screen.dart';
import 'package:soulpet/features/profile/presentation/screens/profile_screen.dart';
import 'package:soulpet/features/profile/presentation/screens/user_profile_setup_screen.dart';
import 'package:soulpet/features/shop/presentation/screens/shop_screen.dart';
import 'package:soulpet/features/shop/presentation/screens/inventory_screen.dart';
import 'package:soulpet/features/minigames/presentation/screens/minigames_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String userProfile = '/user-profile';
  static const String petTestIntro = '/pet-test-intro';
  static const String petTest = '/pet-test';
  static const String petResult = '/pet-result';
  static const String petManualPick = '/pet-manual-pick';
  static const String petSetup = '/pet-setup';
  static const String houseSelection = '/house-selection';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String shop = '/shop';
  static const String inventory = '/inventory';
  static const String minigames = '/minigames';
}

class AppRouter {
  // Routes that anyone can access without being logged in (landing/auth flow).
  static const _publicRoutes = <String>{
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  };

  // Routes that require a logged-in user but are part of the test flow, so
  // they're exempt from the "test must be done" check.
  static const _testRoutes = <String>{
    AppRoutes.petTestIntro,
    AppRoutes.petTest,
    AppRoutes.petResult,
    AppRoutes.petManualPick,
    AppRoutes.petSetup,
    AppRoutes.houseSelection,
  };

  /// Auth guard.
  ///
  /// Order of checks (each step blocks the next until satisfied):
  ///   1. Public routes — always allowed.
  ///   2. Logged-in?           → otherwise redirect to `/register`.
  ///   3. User-profile filled? → otherwise force `/user-profile`
  ///                              (and **stop here** so we don't fall through
  ///                              to the test-done check, which would bounce
  ///                              the user to `/pet-test-intro` and back).
  ///   4. On a test-flow route — allowed.
  ///   5. Pet-test done?       → otherwise redirect to `/pet-test-intro`.
  ///   6. Otherwise the main app is unlocked.
  static Future<String?> _guard(BuildContext context, GoRouterState state) async {
    final loc = state.matchedLocation;
    if (_publicRoutes.contains(loc)) return null;

    final auth = sl<AuthLocalDatasource>();
    final loggedIn = await auth.hasValidSession();
    if (!loggedIn) return AppRoutes.register;

    final profileDone = await auth.isUserProfileDone();
    if (!profileDone) {
      // Not filled in yet → only `/user-profile` is reachable. Returning
      // `null` here is critical: any other location would fall through to the
      // test-done check below and create a `/user-profile ⇄ /pet-test-intro`
      // loop, since `/pet-test-intro` would itself bounce back here.
      return loc == AppRoutes.userProfile ? null : AppRoutes.userProfile;
    }
    // Profile already filled → re-opening `/user-profile` would strand the
    // user on a finished form, so push them forward.
    if (loc == AppRoutes.userProfile) {
      final testDone = await auth.isPetTestDone();
      return testDone ? AppRoutes.home : AppRoutes.petTestIntro;
    }

    if (_testRoutes.contains(loc)) return null;

    final testDone = await auth.isPetTestDone();
    if (!testDone) return AppRoutes.petTestIntro;

    return null;
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: _guard,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.userProfile,
        builder: (context, state) => const UserProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.petTestIntro,
        builder: (context, state) => const PetTestIntroScreen(),
      ),
      GoRoute(
        path: AppRoutes.petTest,
        builder: (context, state) => const PetTestScreen(),
      ),
      GoRoute(
        path: AppRoutes.petResult,
        builder: (context, state) => const PetResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.petManualPick,
        builder: (context, state) => const PetManualPickScreen(),
      ),
      GoRoute(
        path: AppRoutes.petSetup,
        builder: (context, state) => const PetSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.houseSelection,
        builder: (context, state) => const HouseSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: AppRoutes.inventory,
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.minigames,
        builder: (context, state) => const MinigamesScreen(),
      ),
    ],
  );
}
