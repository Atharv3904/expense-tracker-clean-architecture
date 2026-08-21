import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_type_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_type_repository.dart';

class TransactionTypeRepositoryImpl implements TransactionTypeRepository {
  final TransactionTypeRemoteDatasource transactionTypeRemoteDatasource;
  TransactionTypeRepositoryImpl(this.transactionTypeRemoteDatasource);
  @override
  Future<Either<TypeFailure, List<TransactionTypeEntity>>> getTypes() async {
    try {
      final result = await transactionTypeRemoteDatasource.getTypes();
      return Right(result);
    } on TypeException catch (e) {
      return Left(TypeFailure(e.message));
    }
  }
}
