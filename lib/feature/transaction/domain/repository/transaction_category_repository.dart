import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';

abstract class TransactionCategoryRepository {
  AppResult<List<TransactionCategoryEntity>> getCategory();
}
