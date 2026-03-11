import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({this.isLoading = false, this.error, this.isAuthenticated = false});
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState();
  }

  Future<bool> login(String email, String password) async {
    state = AuthState(isLoading: true);
    await Future.delayed(const Duration(seconds: 2));
    if (email.isNotEmpty && password.length >= 6) {
      state = AuthState(isLoading: false, isAuthenticated: true);
      return true;
    } else {
      state = AuthState(isLoading: false, error: 'Invalid email or password');
      return false;
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(() {
  return AuthController();
});
