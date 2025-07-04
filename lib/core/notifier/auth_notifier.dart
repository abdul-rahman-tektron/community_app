import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final String role;
  final int? lastStatusCode;
  final bool isInitialized;

  AuthState({required this.isLoggedIn, required this.role, this.lastStatusCode, this.isInitialized = false});

  AuthState copyWith({bool? isLoggedIn, String? role, int? lastStatusCode, bool? isInitialized}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      role: role ?? this.role,
      lastStatusCode: lastStatusCode ?? this.lastStatusCode,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false, role: '', isInitialized: false)) {
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 1));

    final bool loggedIn = false;

    state = state.copyWith(isLoggedIn: loggedIn, role: loggedIn ? 'user' : '', isInitialized: true);
  }

  void login(String role) {
    state = state.copyWith(isLoggedIn: true, role: role);
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false, role: '');
  }

  void handleStatusCode(int code) {
    state = state.copyWith(lastStatusCode: code);

    if (code == 401) {
      logout();
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
