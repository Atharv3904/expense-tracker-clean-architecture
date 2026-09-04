import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

abstract class TransactionTypeRepository {
  AppResult<List<TransactionTypeEntity>> getTypes();
}
