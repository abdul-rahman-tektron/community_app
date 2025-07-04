import 'package:community_app/core/notifier/base_state.dart';
import 'package:community_app/utils/enums.dart';

class LoginState extends BaseState {
  final bool rememberMe;

  const LoginState({
    UserRole? userRole,
    bool isLoading = false,
    LoadingState loadingState = LoadingState.idle,
    this.rememberMe = false,
  }) : super(userRole: userRole ?? UserRole.tenant, isLoading: isLoading, loadingState: loadingState);

  LoginState copyWith({
    UserRole? userRole,
    bool? isLoading,
    LoadingState? loadingState,
    bool? rememberMe,
  }) {
    return LoginState(
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      loadingState: loadingState ?? this.loadingState,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}