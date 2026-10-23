import 'package:expense_tracker/feature/admin/domain/entity/all_user_entity.dart';

sealed class AllUserState {
  const AllUserState();
}

class AllUserInitial extends AllUserState {
  const AllUserInitial();
}

class AllUserLoading extends AllUserState {
  const AllUserLoading();
}

class AllUserLoaded extends AllUserState {
  final List<AllUserEntity> users;

  const AllUserLoaded({required this.users});
}

class AllUserError extends AllUserState {
  final String message;

  const AllUserError({required this.message});
}
