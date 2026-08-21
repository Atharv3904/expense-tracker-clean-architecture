import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

abstract class TransactionTypeRepository {
  Future<Either<TypeFailure, List<TransactionTypeEntity>>> getTypes();
}
