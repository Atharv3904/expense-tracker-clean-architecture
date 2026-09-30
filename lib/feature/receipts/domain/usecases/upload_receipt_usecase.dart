import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/domain/params/upload_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/repository/receipt_repository.dart';

class UploadReceiptUsecase {
  final ReceiptRepository repository;

  const UploadReceiptUsecase(this.repository);

  AppResult<ReceiptEntity> call(UploadReceiptParams params) async {
    return await repository.uploadReceipt(params);
  }
}
