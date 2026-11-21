import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_shadows.dart';
import '../../../app/theme/hunter_typography.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.isAuthenticated) {
      if (authState.user?.hasCompletedOnboarding == true) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    } else {
      context.go('/welcome');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HunterColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // System Rune / Monolith Emblem
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF00E5FF),
                        Color(0xFF101725),
                      ],
                    ),
                    border: Border.all(color: HunterColors.cyan, width: 2),
                    boxShadow: HunterShadows.cyanGlow(radius: 24, spread: 2),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bolt,
                      color: HunterColors.textPrimary,
                      size: 52,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'PROJECT HUNTER',
                  style: HunterTypography.displayLarge.copyWith(
                    letterSpacing: 3.0,
                    color: HunterColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '[ SYSTEM INITIALIZING... ]',
                  style: HunterTypography.systemTitle.copyWith(
                    fontSize: 12,
                    color: HunterColors.cyan,
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(
                  width: 140,
                  child: LinearProgressIndicator(
                    backgroundColor: HunterColors.surfaceSecondary,
                    valueColor: AlwaysStoppedAnimation<Color>(HunterColors.cyan),
                    minHeight: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
