import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ReceiptEvent {
  const ReceiptEvent();
}

final class UploadReceipt extends ReceiptEvent {
  final PlatformFile file;

  const UploadReceipt({required this.file});
}

final class GetReceipts extends ReceiptEvent {
  const GetReceipts();
}

final class DeleteReceipt extends ReceiptEvent {
  final String receiptId;
  final String filePath;

  const DeleteReceipt({required this.receiptId, required this.filePath});
}

final class GetReceiptUrl extends ReceiptEvent {
  final String filePath;
  final String fileName;
  final String fileType;

  const GetReceiptUrl({
    required this.filePath,
    required this.fileName,
    required this.fileType,
  });
}
