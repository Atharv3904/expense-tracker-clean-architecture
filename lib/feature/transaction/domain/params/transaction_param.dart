import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:file_picker/file_picker.dart';

class TransactionParam {
  final TransactionEntity transaction;
  final PlatformFile? file;
  const TransactionParam({required this.file, required this.transaction});
}
