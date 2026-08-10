import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/dashboard/data/datasources/dasboard_datasource.dart';
import 'package:expense_tracker/feature/dashboard/domain/entity/dashboard_summary.dart';
import 'package:expense_tracker/feature/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DasboardDatasource remoteDataSource;
  const DashboardRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<AppFailure, DashboardSummary>> getDashboardSummary() async {
    try {
      final result = await remoteDataSource.getDashboardSummary();
      return Right(result);
    } on AppException catch (e) {
      return Left(AppFailure(e.toString()));
    } catch (_) {
      return const Left(AppFailure("try again!"));
    }
  }
}
