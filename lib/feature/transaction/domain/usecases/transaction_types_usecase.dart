import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_type_repository.dart';

class TransactionTypesUsecase {
  final TransactionTypeRepository transactionTypeRepository;
  TransactionTypesUsecase(this.transactionTypeRepository);

  Future<List<TransactionTypeEntity>> call() async {
    return await transactionTypeRepository.getTypes();
  }
}
