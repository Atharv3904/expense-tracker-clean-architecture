import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/domain/repository/receipt_repository.dart';

class GetReceiptUrlUsecase {
  final ReceiptRepository repository;

  const GetReceiptUrlUsecase(this.repository);

  AppResult<String> call(String filePath) async {
    return await repository.getReceiptUrl(filePath);
  }
}
