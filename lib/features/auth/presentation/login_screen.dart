import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/hunter_colors.dart';
import '../../../app/theme/hunter_typography.dart';
import '../../../core/widgets/hunter_app_bar.dart';
import '../../../core/widgets/hunter_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'hunter@system.rpg');
  final _passwordController = TextEditingController(text: 'pass123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: HunterColors.background,
      appBar: const HunterAppBar(
        title: 'Hunter Verification',
        subtitle: 'Enter credentials to access System status',
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
                const SizedBox(height: 20),
                Text(
                  'ACCESS LOG',
                  style: HunterTypography.systemTitle,
                ),
                const SizedBox(height: 8),
                Text(
                  'Verify identity to synchronize player profile and quest database.',
                  style: HunterTypography.bodyMedium,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: HunterTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Hunter Code / Email',
                    prefixIcon: Icon(Icons.alternate_email, color: HunterColors.cyan),
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Valid email required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: HunterTypography.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Security Passcode',
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
                const SizedBox(height: 36),
                HunterButton(
                  label: 'AUTHORIZE ENTRY',
                  isLoading: authState.isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have a Hunter ID? ", style: HunterTypography.bodyMedium),
                    GestureDetector(
                      onTap: () => context.pushReplacement('/register'),
                      child: Text(
                        'Initialize Now',
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
