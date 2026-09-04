import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class AddTransactionUsecase {
  final TransactionRepository repository;
  const AddTransactionUsecase(this.repository);

  AppResult<TransactionEntity> call(TransactionEntity transaction) {
    return repository.addTransaction(transaction);
  }
}
