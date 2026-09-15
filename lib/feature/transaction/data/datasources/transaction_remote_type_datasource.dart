import 'package:expense_tracker/feature/transaction/data/model/transaction_type_model.dart';

abstract class TransactionTypeRemoteDatasource {
  Future<List<TransactionTypeModel>> getTypes();
}
