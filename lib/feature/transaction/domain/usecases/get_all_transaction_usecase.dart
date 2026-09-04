import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class GetAllTransactionUsecase {
  final TransactionRepository repository;
  GetAllTransactionUsecase(this.repository);

  AppResult<List<TransactionEntity>> call() async {
    return repository.getAllTransactionData();
  }
}
