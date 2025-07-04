import 'package:community_app/core/notifier/user_selection_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final userRoleSelectionNotifierProvider = StateNotifierProvider<UserRoleSelectionNotifier, UserRoleSelectionState>(
      (ref) => UserRoleSelectionNotifier(),
);

class UserRoleSelectionNotifier extends StateNotifier<UserRoleSelectionState> {
  UserRoleSelectionNotifier() : super(const UserRoleSelectionState());

  void selectRoleAndNavigate(BuildContext context, UserRole userRole) {
    // Update state immutably
    state = state.copyWith(userRole: userRole);

    // Navigate after state update
    context.push(AppRoutes.login);
  }
}