import 'package:go_router/go_router.dart';
import 'package:soulpet/features/splash/presentation/splash_screen.dart';
import 'package:soulpet/features/onboarding/presentation/onboarding_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/login_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/register_screen.dart';
import 'package:soulpet/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_test_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_result_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/pet_setup_screen.dart';
import 'package:soulpet/features/pet_test/presentation/screens/house_selection_screen.dart';
import 'package:soulpet/features/home/presentation/screens/home_screen.dart';
import 'package:soulpet/features/chat/presentation/screens/chat_screen.dart';
import 'package:soulpet/features/profile/presentation/screens/profile_screen.dart';
import 'package:soulpet/features/shop/presentation/screens/shop_screen.dart';
import 'package:soulpet/features/shop/presentation/screens/inventory_screen.dart';
import 'package:soulpet/features/minigames/presentation/screens/minigames_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String petTest = '/pet-test';
  static const String petResult = '/pet-result';
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
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
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
        path: AppRoutes.petTest,
        builder: (context, state) => const PetTestScreen(),
      ),
      GoRoute(
        path: AppRoutes.petResult,
        builder: (context, state) => const PetResultScreen(),
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
