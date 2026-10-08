import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class LoadTransaction extends TransactionEvent {
  const LoadTransaction();
}

class AddTransaction extends TransactionEvent {
  final TransactionParam param;
  const AddTransaction(this.param);
}

class UpdateTransaction extends TransactionEvent {
  final TransactionParam params;
  const UpdateTransaction(this.params);
}

class DeleteTransaction extends TransactionEvent {
  final String transactionid;
  const DeleteTransaction(this.transactionid);
}

class GetAllTransaction extends TransactionEvent {
  final String? searchQuery;
  const GetAllTransaction({this.searchQuery});
}
