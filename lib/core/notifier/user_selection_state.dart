import 'package:community_app/utils/enums.dart';

class UserRoleSelectionState {
  final UserRole? userRole;

  const UserRoleSelectionState({this.userRole});

  UserRoleSelectionState copyWith({UserRole? userRole}) {
    return UserRoleSelectionState(
      userRole: userRole ?? this.userRole,
    );
  }
}