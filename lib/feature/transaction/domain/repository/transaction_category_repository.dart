import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';

abstract class TransactionCategoryRepository {
  Future<Either<CategoryFailure, List<TransactionCategoryEntity>>>
  getCategory();
}
