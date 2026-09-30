import 'package:expense_tracker/feature/receipts/data/model/receipt_model.dart';
import 'package:expense_tracker/feature/receipts/domain/params/delete_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/params/upload_receipt_params.dart';

abstract class ReceiptRemoteDatasource {
  Future<ReceiptModel> uploadReceipt(UploadReceiptParams params);

  Future<List<ReceiptModel>> getReceipts();

  Future<void> deleteReceipt(DeleteReceiptParams params);
  Future<String> getReceiptUrl(String filePath);
}
