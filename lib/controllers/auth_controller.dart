import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth State
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({bool? isLoading, bool? isAuthenticated, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@nannak.com' && password == 'password') {
      state = state.copyWith(isLoading: false, isAuthenticated: true);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Invalid credentials. Use admin@nannak.com / password');
      return false;
    }
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
