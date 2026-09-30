import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/domain/params/delete_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/params/upload_receipt_params.dart';

abstract class ReceiptRepository {
  AppResult<ReceiptEntity> uploadReceipt(UploadReceiptParams params);

  AppResult<List<ReceiptEntity>> getReceipts();

  AppResult<void> deleteReceipt(DeleteReceiptParams params);
  AppResult<String> getReceiptUrl(String filePath);
}
