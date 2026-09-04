import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class DeleteTransactionUsecase {
  final TransactionRepository repository;

  DeleteTransactionUsecase(this.repository);

  AppResult<void> call(String transactionid) {
    return repository.deleteTransaction(transactionid);
  }
}
