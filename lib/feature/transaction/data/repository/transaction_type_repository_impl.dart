import 'package:expense_tracker/feature/transaction/data/datasources/transaction_type_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_type_repository.dart';

class TransactionTypeRepositoryImpl implements TransactionTypeRepository {
  final TransactionTypeRemoteDatasource transactionTypeRemoteDatasource;
  TransactionTypeRepositoryImpl(this.transactionTypeRemoteDatasource);
  @override
  Future<List<TransactionTypeEntity>> getTypes() async {
    return await transactionTypeRemoteDatasource.getTypes();
  }
}
