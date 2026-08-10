import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource.dart';
import 'package:expense_tracker/feature/authentication/data/datasources/auth_remote_datasource_impl.dart';
import 'package:expense_tracker/feature/authentication/data/repositories/auth_repository_impl.dart';
import 'package:expense_tracker/feature/authentication/domain/repositories/auth_repository.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/forgot_password_usecase.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/login_usecase.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/logout_usecase.dart';
import 'package:expense_tracker/feature/authentication/domain/usecases/register_usecase.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/forgot_password/forgot_pass_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/logout/logout_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/register/register_cubit.dart';
import 'package:expense_tracker/feature/authentication/presentation/cubit/splash/splash_cubit.dart';
import 'package:expense_tracker/feature/dashboard/Presentation/cubit/dashboard_cubit/dashboard_cubit.dart';
import 'package:expense_tracker/feature/dashboard/data/datasources/dasboard_datasource.dart';
import 'package:expense_tracker/feature/dashboard/data/datasources/dashboard_datasource_impl.dart';
import 'package:expense_tracker/feature/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:expense_tracker/feature/dashboard/domain/repository/dashboard_repository.dart';
import 'package:expense_tracker/feature/dashboard/domain/usecase/dashboard_summary_usecases.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl(), //remoteDatasource
    ),
  );
  sl.registerLazySingleton(() => RegisterUsecase(sl()));

  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => LoginCubit(sl()));
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerFactory(() => SplashCubit(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerFactory(() => LogoutCubit(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
  sl.registerFactory(() => ForgotPassCubit(sl()));

  sl.registerFactory(() => DashboardCubit(sl()));
  sl.registerLazySingleton(() => DashboardSummaryUsecases(sl()));
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<DasboardDatasource>(
    () => DashboardDatasourceImpl(sl()),
  );
}
