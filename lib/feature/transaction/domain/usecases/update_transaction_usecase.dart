import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_repository.dart';

class UpdateTransactionUsecase {
  final TransactionRepository repository;

  const UpdateTransactionUsecase(this.repository);

  AppResult<TransactionEntity> call(TransactionParam params) {
    return repository.updateTransaction(params);
  }
}
