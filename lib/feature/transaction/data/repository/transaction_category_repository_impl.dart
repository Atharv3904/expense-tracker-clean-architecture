import 'package:expense_tracker/feature/transaction/data/datasources/transaction_category_datasource.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/repository/transaction_category_repository.dart';

class TransactionCategoryRepositoryImpl extends TransactionCategoryRepository {
  final TransactionCategoryDatasource transactionCategoryDatasource;
  TransactionCategoryRepositoryImpl(this.transactionCategoryDatasource);

  @override
  Future<List<TransactionCategoryEntity>> getCategory() async {
    return await transactionCategoryDatasource.getCategory();
  }
}
