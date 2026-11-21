import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HunterColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Holographic System Emblem
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: HunterColors.cyan, width: 1.5),
                    color: HunterColors.surfacePrimary,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: HunterColors.cyan,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'AWAKEN YOUR POTENTIAL',
                textAlign: TextAlign.center,
                style: HunterTypography.displayMedium.copyWith(letterSpacing: 1.0),
              ),
              const SizedBox(height: 12),
              Text(
                'Transform real-life physical training into an immersive RPG progression system. Exercise earns XP. Consistency builds your legend.',
                textAlign: TextAlign.center,
                style: HunterTypography.bodyMedium,
              ),
              const SizedBox(height: 32),
              // Holographic Notice
              HolographicCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: HunterColors.cyan, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A mysterious system has chosen you to undertake physical training quests.',
                        style: HunterTypography.bodySmall.copyWith(
                          color: HunterColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              HunterButton(
                label: 'INITIALIZE AS HUNTER',
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: 14),
              HunterButton(
                label: 'ACCESS EXISTING RECORD',
                variant: HunterButtonVariant.outline,
                onPressed: () => context.push('/login'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
