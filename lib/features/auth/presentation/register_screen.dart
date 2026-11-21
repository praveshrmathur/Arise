import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _hunterNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _hunterNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _hunterNameController.text.trim(),
        );

    if (success && mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: const HunterAppBar(
        title: 'New Hunter Registration',
        subtitle: 'Bind system to your biometric ID',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text('SYSTEM AWAKENING', style: HunterTypography.systemTitle),
                const SizedBox(height: 8),
                Text(
                  'Every legend begins with a name. Register your profile to begin receiving daily physical challenges.',
                  style: HunterTypography.bodyMedium,
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _hunterNameController,
                  style: HunterTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Hunter Codename (e.g. IronFist, Jin)',
                    prefixIcon: Icon(Icons.person_pin, color: HunterColors.cyan),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Hunter codename required' : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: HunterTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.alternate_email, color: HunterColors.cyan),
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: HunterTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Passcode (Min 6 characters)',
                    prefixIcon: Icon(Icons.lock_outline, color: HunterColors.cyan),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                ),
                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    authState.errorMessage!,
                    style: HunterTypography.bodySmall.copyWith(color: HunterColors.danger),
                  ),
                ],
                const SizedBox(height: 32),
                HunterButton(
                  label: 'COMMENCE AWAKENING',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already awakened? ', style: HunterTypography.bodyMedium),
                    GestureDetector(
                      onTap: () => context.pushReplacement('/login'),
                      child: Text(
                        'Access System',
                        style: HunterTypography.bodyMedium.copyWith(
                          color: HunterColors.cyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
