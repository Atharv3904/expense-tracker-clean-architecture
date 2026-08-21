import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_category_datasource.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_category_repository.dart';

class TransactionCategoryRepositoryImpl extends TransactionCategoryRepository {
  final TransactionCategoryDatasource transactionCategoryDatasource;
  TransactionCategoryRepositoryImpl(this.transactionCategoryDatasource);

  @override
  Future<Either<CategoryFailure, List<TransactionCategoryEntity>>>
  getCategory() async {
    try {
      final result = await transactionCategoryDatasource.getCategory();
      return Right(result);
    } on CategoryException catch (e) {
      return Left(CategoryFailure(e.message));
    }
  }
}
