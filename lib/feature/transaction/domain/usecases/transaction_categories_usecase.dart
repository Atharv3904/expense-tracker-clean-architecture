import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_category_repository.dart';

class TransactionCategoriesUsecase {
  final TransactionCategoryRepository transactionCategoryRepository;

  TransactionCategoriesUsecase(this.transactionCategoryRepository);

  Future<Either<CategoryFailure, List<TransactionCategoryEntity>>>
  call() async {
    return await transactionCategoryRepository.getCategory();
  }
}
