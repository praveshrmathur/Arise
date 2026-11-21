import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/holographic_card.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../../../core/widgets/system_toast.dart';
import '../../auth/providers/auth_provider.dart';
import '../../hunter_status/providers/hunter_stats_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _healthSyncEnabled = true;
  bool _hapticFeedback = true;
  bool _aiAssistance = true;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final stats = ref.watch(hunterStatsProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: HunterAppBar(
        title: 'System Settings',
        subtitle: 'Hunter configuration & telemetry',
        rank: stats.rank,
        level: stats.level,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // User ID Card
            HolographicCard(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HunterColors.surfaceSecondary,
                      border: Border.all(color: HunterColors.cyan, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: HunterColors.cyan, size: 28),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.hunterName ?? 'Awakened Hunter',
                          style: HunterTypography.displaySmall.copyWith(fontSize: 16),
                        ),
                        Text(
                          user?.email ?? 'hunter@system.rpg',
                          style: HunterTypography.bodySmall.copyWith(color: HunterColors.textMuted),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: HunterColors.cyan.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'TIER: ${(user?.subscriptionTier ?? 'free').toUpperCase()}',
                            style: HunterTypography.systemSub.copyWith(
                              fontSize: 9,
                              color: HunterColors.cyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Subscription Section
            Text('MEMBERSHIP PROTOCOL', style: HunterTypography.systemSub),
            const SizedBox(height: 8),
            HolographicCard(
              borderColor: HunterColors.warning.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'HUNTER LICENSE: FREE',
                        style: HunterTypography.systemSub.copyWith(
                          color: HunterColors.warning,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: HunterColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'STANDARD ACCESS',
                          style: HunterTypography.systemSub.copyWith(
                            color: HunterColors.warning,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Free tier includes daily AI quests, standard XP progression, complete exercise codex, and local logging. Optional Hunter Pass adds advanced Gemini AI coaching programs.',
                    style: HunterTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Health & Hardware Integrations
            Text('BIOMETRIC HARDWARE & TELEMETRY', style: HunterTypography.systemSub),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: HunterColors.surfacePrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: HunterColors.borderThin),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _healthSyncEnabled,
                    activeColor: HunterColors.cyan,
                    title: Text('Health Connect / Apple HealthKit', style: HunterTypography.bodyMedium),
                    subtitle: Text('Sync steps, walking distance and calories', style: HunterTypography.bodySmall),
                    onChanged: (val) {
                      setState(() => _healthSyncEnabled = val);
                      SystemToast.show(
                        context,
                        title: 'Telemetry Updated',
                        message: val ? 'Health service linked.' : 'Health sync disabled.',
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _aiAssistance,
                    activeColor: HunterColors.cyan,
                    title: Text('Gemini AI Quest Adaptation', style: HunterTypography.bodyMedium),
                    subtitle: Text('Personalize daily missions using fatigue data', style: HunterTypography.bodySmall),
                    onChanged: (val) => setState(() => _aiAssistance = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: _hapticFeedback,
                    activeColor: HunterColors.cyan,
                    title: Text('Haptic Vibration Feedback', style: HunterTypography.bodyMedium),
                    subtitle: Text('Tactile responses on quest completions', style: HunterTypography.bodySmall),
                    onChanged: (val) => setState(() => _hapticFeedback = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account Actions
            Text('OPERATOR COMMANDS', style: HunterTypography.systemSub),
            const SizedBox(height: 8),
            HunterButton(
              label: 'RE-CALIBRATE ONBOARDING',
              variant: HunterButtonVariant.secondary,
              onPressed: () => context.push('/onboarding'),
            ),
            const SizedBox(height: 10),
            HunterButton(
              label: 'DISCONNECT SESSION (LOGOUT)',
              variant: HunterButtonVariant.outline,
              onPressed: () async {
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/welcome');
                }
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '${AppConstants.appName} v${AppConstants.appVersion}\n${AppConstants.appTagline}',
                textAlign: TextAlign.center,
                style: HunterTypography.bodySmall.copyWith(
                  color: HunterColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
