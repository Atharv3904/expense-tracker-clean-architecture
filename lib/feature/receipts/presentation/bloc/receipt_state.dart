import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ReceiptState {
  const ReceiptState();
}

final class ReceiptInitial extends ReceiptState {
  const ReceiptInitial();
}

final class ReceiptLoading extends ReceiptState {
  const ReceiptLoading();
}

final class ReceiptsLoaded extends ReceiptState {
  final List<ReceiptEntity> receipts;

  const ReceiptsLoaded(this.receipts);
}

final class ReceiptUploadSuccess extends ReceiptState {
  final ReceiptEntity receipt;

  const ReceiptUploadSuccess(this.receipt);
}

final class ReceiptDeleteSuccess extends ReceiptState {
  const ReceiptDeleteSuccess();
}

final class ReceiptFailure extends ReceiptState {
  final String message;

  const ReceiptFailure(this.message);
}

final class ReceiptUrlLoaded extends ReceiptState {
  final String url;
  final String fileName;
  final String fileType;

  const ReceiptUrlLoaded({
    required this.url,
    required this.fileName,
    required this.fileType,
  });
}
