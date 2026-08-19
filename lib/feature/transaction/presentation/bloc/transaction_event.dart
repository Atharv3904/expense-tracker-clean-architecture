import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_filter.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class LoadTransaction extends TransactionEvent {
  const LoadTransaction();
}

class AddTransaction extends TransactionEvent {
  final TransactionEntity transaction;
  const AddTransaction(this.transaction);
}

class UpdateTransaction extends TransactionEvent {
  final TransactionEntity transaction;
  const UpdateTransaction(this.transaction);
}

class DeleteTransaction extends TransactionEvent {
  final String TransactionId;
  const DeleteTransaction(this.TransactionId);
}

class GetAllTransaction extends TransactionEvent {
  final String? typeId;
  final String? categoryId;
  final DateTime? date;
  final double? minAmount;
  final double? maxAmount;

  const GetAllTransaction({
    this.typeId,
    this.categoryId,
    this.date,
    this.minAmount,
    this.maxAmount,
  });
}
