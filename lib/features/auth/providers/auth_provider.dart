import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/supabase_service.dart';
import '../models/user_model.dart';

class AuthState {
  final HunterUserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    HunterUserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    state = state.copyWith(isLoading: true);
    // In dev / demo mode, auto-login with default hunter profile
    await Future.delayed(const Duration(milliseconds: 600));

    // Default Hunter Profile
    final defaultUser = HunterUserModel(
      id: 'hunter-demo-uuid-001',
      email: 'jinwoo@hunter.system',
      hunterName: 'Shadow Monarch',
      avatarUrl: null,
      hasCompletedOnboarding: true,
      subscriptionTier: 'free',
      createdAt: DateTime.now(),
    );

    state = AuthState(
      user: defaultUser,
      isAuthenticated: true,
      isLoading: false,
    );
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (SupabaseService.isConfigured && SupabaseService.client != null) {
        final res = await SupabaseService.client!.auth.signInWithPassword(
          email: email,
          password: password,
        );
        if (res.user != null) {
          final user = HunterUserModel(
            id: res.user!.id,
            email: res.user!.email ?? email,
            hunterName: res.user!.userMetadata?['hunter_name'] ?? 'Awakened Hunter',
            hasCompletedOnboarding: true,
            createdAt: DateTime.parse(res.user!.createdAt),
          );
          state = AuthState(user: user, isAuthenticated: true, isLoading: false);
          return true;
        }
      }

      // Offline / Demo Fallback
      await Future.delayed(const Duration(milliseconds: 500));
      final user = HunterUserModel(
        id: 'hunter-demo-uuid-001',
        email: email,
        hunterName: email.split('@').first.toUpperCase(),
        hasCompletedOnboarding: true,
        createdAt: DateTime.now(),
      );
      state = AuthState(user: user, isAuthenticated: true, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> registerWithEmail(String email, String password, String hunterName) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      if (SupabaseService.isConfigured && SupabaseService.client != null) {
        final res = await SupabaseService.client!.auth.signUp(
          email: email,
          password: password,
          data: {'hunter_name': hunterName},
        );
        if (res.user != null) {
          final user = HunterUserModel(
            id: res.user!.id,
            email: res.user!.email ?? email,
            hunterName: hunterName,
            hasCompletedOnboarding: false,
            createdAt: DateTime.now(),
          );
          state = AuthState(user: user, isAuthenticated: true, isLoading: false);
          return true;
        }
      }

      // Offline Demo registration
      await Future.delayed(const Duration(milliseconds: 500));
      final user = HunterUserModel(
        id: 'hunter-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        hunterName: hunterName,
        hasCompletedOnboarding: false,
        createdAt: DateTime.now(),
      );
      state = AuthState(user: user, isAuthenticated: true, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> completeOnboarding(String hunterName) async {
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(
        hunterName: hunterName,
        hasCompletedOnboarding: true,
      );
      state = state.copyWith(user: updatedUser);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    if (SupabaseService.isConfigured && SupabaseService.client != null) {
      await SupabaseService.client!.auth.signOut();
    }
    state = const AuthState(user: null, isAuthenticated: false, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
