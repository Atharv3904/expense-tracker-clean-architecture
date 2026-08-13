import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

abstract class TransactionTypeRepository {
  Future<List<TransactionTypeEntity>> getTypes();
}
