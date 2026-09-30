import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/domain/repository/receipt_repository.dart';

class GetReceiptsUsecase {
  final ReceiptRepository repository;

  const GetReceiptsUsecase(this.repository);

  AppResult<List<ReceiptEntity>> call() async {
    return await repository.getReceipts();
  }
}
