import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_category_repository.dart';

class TransactionCategoriesUsecase {
  final TransactionCategoryRepository transactionCategoryRepository;

  TransactionCategoriesUsecase(this.transactionCategoryRepository);

  AppResult<List<TransactionCategoryEntity>> call() async {
    return await transactionCategoryRepository.getCategory();
  }
}
