import 'package:expense_tracker/core/notification/%20android_notification_service.dart';
// import 'package:expense_tracker/core/notification/notification_service.dart';
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
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource.dart';
import 'package:expense_tracker/feature/profile/data/datasource/profile_remote_datasource_impl.dart';
import 'package:expense_tracker/feature/profile/data/repository/profile_repository_impl.dart';
import 'package:expense_tracker/feature/profile/domain/repository/profile_repository.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/change_password_usecase.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:expense_tracker/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_datasource.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_datasource_impl.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_local_datasource.dart';
import 'package:expense_tracker/feature/reminder/data/datasource/reminder_local_datasource_impl.dart';
import 'package:expense_tracker/feature/reminder/data/repository/reminder_local_repository_impl.dart';
import 'package:expense_tracker/feature/reminder/data/repository/reminder_repository_impl.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_local_repository.dart';
import 'package:expense_tracker/feature/reminder/domain/repository/reminder_repository.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/cancel_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/clear_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/get_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/save_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/domain/usecases/schedule_daily_reminder_usecase.dart';
import 'package:expense_tracker/feature/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_category_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_category_datasource_impl.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource_impl.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_type_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_type_remote_datasource_impl.dart';
import 'package:expense_tracker/feature/transaction/data/repository/transaction_category_repository_impl.dart';
import 'package:expense_tracker/feature/transaction/data/repository/transaction_repository_impl.dart';
import 'package:expense_tracker/feature/transaction/data/repository/transaction_type_repository_impl.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_category_repository.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_type_repository.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/add_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/get_all_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/get_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_categories_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_types_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final preferences = await SharedPreferences.getInstance();

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

  sl.registerLazySingleton<TransactionRemoteDatasource>(
    () => TransactionRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetTransactionUsecase(sl()));
  sl.registerLazySingleton(() => AddTransactionUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTransactionUsecase(sl()));
  sl.registerLazySingleton(() => DeleteTransactionUsecase(sl()));

  sl.registerFactory(
    () => TransactionBloc(
      addTransactionUsecase: sl(),
      deleteTransactionUsecase: sl(),
      getTransactionUsecase: sl(),
      updateTransactionUsecase: sl(),
      getAllTransactionUsecase: sl(),
    ),
  );

  // Transaction Type
  sl.registerLazySingleton<TransactionTypeRemoteDatasource>(
    () => TransactionTypeRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<TransactionTypeRepository>(
    () => TransactionTypeRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<TransactionCategoryDatasource>(
    () => TransactionCategoryDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<TransactionCategoryRepository>(
    () => TransactionCategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => TransactionTypesUsecase(sl()));
  sl.registerLazySingleton(() => TransactionCategoriesUsecase(sl()));
  sl.registerLazySingleton(() => GetAllTransactionUsecase(sl()));

  // Type BLoC
  sl.registerFactory(
    () => TypeBloc(transactionTypesUsecase: sl<TransactionTypesUsecase>()),
  );
  sl.registerFactory(
    () => CategoryBloc(
      transactionCategoriesUsecase: sl<TransactionCategoriesUsecase>(),
    ),
  );

  //profile

  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));

  sl.registerLazySingleton(() => GetProfileUsecase(sl()));

  sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));

  sl.registerFactory(
    () => ProfileBloc(
      getProfileUsecase: sl<GetProfileUsecase>(),
      updateProfileUsecase: sl<UpdateProfileUsecase>(),
      changePasswordUsecase: sl<ChangePasswordUsecase>(),
    ),
  );

  // ============================================================
  // REMINDER
  // ============================================================

  sl.registerLazySingleton<AndroidNotificationService>(
    () => AndroidNotificationService(),
  );

  // sl.registerLazySingleton<NotificationService>(
  //   () => NotificationService(sl()),
  // );

  sl.registerLazySingleton<ReminderDatasource>(
    () => ReminderDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ReminderRepository>(
    () => ReminderRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => ScheduleDailyReminderUsecase(sl()));

  sl.registerLazySingleton(() => CancelDailyReminderUsecase(sl()));

  // reminder Local Storage Shared preference
  sl.registerLazySingleton<ReminderLocalDatasource>(
    () => ReminderLocalDatasourceImpl(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ReminderLocalRepository>(
    () => ReminderLocalRepositoryImpl(sl<ReminderLocalDatasource>()),
  );

  sl.registerLazySingleton(() => SaveReminderUsecase(sl()));

  sl.registerLazySingleton(() => GetReminderUsecase(sl()));

  sl.registerLazySingleton(() => ClearReminderUsecase(sl()));

  sl.registerLazySingleton<SharedPreferences>(() => preferences);

  // -------------------- Bloc --------------------

  sl.registerFactory(
    () => ReminderBloc(
      scheduleDailyReminderUsecase: sl(),
      cancelDailyReminderUsecase: sl(),
      saveReminderUsecase: sl(),
      getReminderUsecase: sl(),
      clearReminderUsecase: sl(),
    ),
  );
}
