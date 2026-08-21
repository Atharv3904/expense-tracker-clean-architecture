import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_type_repository.dart';

class TransactionTypesUsecase {
  final TransactionTypeRepository transactionTypeRepository;
  TransactionTypesUsecase(this.transactionTypeRepository);

  Future<Either<TypeFailure, List<TransactionTypeEntity>>> call() async {
    return await transactionTypeRepository.getTypes();
  }
}
