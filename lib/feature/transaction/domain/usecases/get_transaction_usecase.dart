import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class GetTransactionUsecase {
  GetTransactionUsecase(this.repository);

  final TransactionRepository repository;

  AppResult<List<TransactionEntity>> call() {
    return repository.getTransaction();
  }
}
