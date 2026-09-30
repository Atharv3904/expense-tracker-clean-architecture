import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/domain/params/delete_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/repository/receipt_repository.dart';

class DeleteReceiptUsecase {
  final ReceiptRepository repository;

  const DeleteReceiptUsecase(this.repository);

  AppResult<void> call(DeleteReceiptParams params) async {
    return await repository.deleteReceipt(params);
  }
}
