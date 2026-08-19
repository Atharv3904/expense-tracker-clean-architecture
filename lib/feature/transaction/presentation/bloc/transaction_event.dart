import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';

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
  final String transactionid;
  const DeleteTransaction(this.transactionid);
}

class GetAllTransaction extends TransactionEvent {
  const GetAllTransaction();
}
