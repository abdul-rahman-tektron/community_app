import 'package:community_app/utils/enums.dart';
import 'package:flutter/foundation.dart';

@immutable
class BaseState {
  final UserRole userRole;
  final bool isLoading;
  final LoadingState loadingState;

  const BaseState({
    this.userRole = UserRole.tenant,
    this.isLoading = false,
    this.loadingState = LoadingState.idle,
  });

  BaseState copyWith({
    UserRole? userRole,
    bool? isLoading,
    LoadingState? loadingState,
  }) {
    return BaseState(
      userRole: userRole ?? this.userRole,
      isLoading: isLoading ?? this.isLoading,
      loadingState: loadingState ?? this.loadingState,
    );
  }
}