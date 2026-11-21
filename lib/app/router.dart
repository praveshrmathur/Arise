import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/hunter_bottom_nav.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/welcome_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/hunter_status/presentation/hunter_status_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/quests/presentation/quests_screen.dart';
import '../features/training/presentation/active_workout_screen.dart';
import '../features/training/presentation/exercise_library_screen.dart';
import '../features/training/presentation/training_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter hunterRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Auth & Onboarding Routes
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Training Sub-routes
    GoRoute(
      path: '/training/exercises',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExerciseLibraryScreen(),
    ),
    GoRoute(
      path: '/training/active',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ActiveWorkoutScreen(),
    ),

    // Primary 5-Tab Navigation Shell
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        int currentIndex = 0;
        final location = state.uri.path;
        if (location.startsWith('/quests')) {
          currentIndex = 1;
        } else if (location.startsWith('/training')) {
          currentIndex = 2;
        } else if (location.startsWith('/status')) {
          currentIndex = 3;
        } else if (location.startsWith('/profile')) {
          currentIndex = 4;
        } else {
          currentIndex = 0;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: HunterBottomNav(
            currentIndex: currentIndex,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/quests');
                  break;
                case 2:
                  context.go('/training');
                  break;
                case 3:
                  context.go('/status');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            },
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
        ),
        GoRoute(
          path: '/quests',
          pageBuilder: (context, state) => const NoTransitionPage(child: QuestsScreen()),
        ),
        GoRoute(
          path: '/training',
          pageBuilder: (context, state) => const NoTransitionPage(child: TrainingScreen()),
        ),
        GoRoute(
          path: '/status',
          pageBuilder: (context, state) => const NoTransitionPage(child: HunterStatusScreen()),
        ),
        GoRoute(
          path: '/profile',
          pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
        ),
      ],
    ),
  ],
);
