import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';

abstract class TransactionCategoryRepository {
  Future<List<TransactionCategoryEntity>> getCategory();
}
