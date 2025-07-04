import 'package:community_app/core/notifier/base_state.dart';
import 'package:flutter/foundation.dart';
import 'package:community_app/utils/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseNotifier extends StateNotifier<BaseState> {
  BaseNotifier() : super(const BaseState());

  UserRole? get userRole => state.userRole;

  set userRole(UserRole? value) {
    if (value != state.userRole) {
      state = state.copyWith(userRole: value);
    }
  }

  bool get isLoading => state.isLoading;
  LoadingState get loadingState => state.loadingState;

  set isLoading(bool value) {
    if (value != state.isLoading) {
      state = state.copyWith(isLoading: value);
    }
  }

  void setLoadingState(LoadingState newState) {
    if (newState != state.loadingState) {
      state = state.copyWith(loadingState: newState);
    }
  }

  Future<void> runWithLoadingVoid(Future<void> Function() task) async {
    try {
      setLoadingState(LoadingState.busy);
      await task();
    } finally {
      setLoadingState(LoadingState.idle);
    }
  }
}

final baseNotifierProvider = StateNotifierProvider<BaseNotifier, BaseState>(
      (ref) => BaseNotifier(),
);
