import 'package:bloc/bloc.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/change_password_usecase.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_event.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUsecase updateProfileUsecase;
  final ChangePasswordUsecase changePasswordUsecase;
  final GetProfileUsecase getProfileUsecase;

  ProfileBloc({
    required this.updateProfileUsecase,
    required this.changePasswordUsecase,
    required this.getProfileUsecase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_loadProfile);

    on<UpdateProfile>(_updateProfile);

    on<ChangePassword>(_changePassword);
  }

  Future<void> _loadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final profile = await getProfileUsecase();

    profile.fold(
      (failure) {
        emit(ProfileFailure(failure.message));
      },
      (profile) {
        emit(ProfileLoaded(profile));
      },
    );
  }

  Future<void> _updateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await updateProfileUsecase(name: event.name);

    result.fold(
      (failure) {
        emit(ProfileFailure(failure.message));
      },
      (_) {
        emit(ProfileSuccess("Profile Updated SuccessFully"));
      },
    );
  }

  Future<void> _changePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await changePasswordUsecase(password: event.password);

    result.fold(
      (failure) {
        emit(ProfileFailure(failure.message));
      },
      (_) {
        emit(const ProfileSuccess('Password changed successfully'));
      },
    );
  }
}
