import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';

abstract class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;

  const TransactionLoaded(this.transactions);
}

class TransactionSuccess extends TransactionState {
  const TransactionSuccess();
}

class TransactionFailure extends TransactionState {
  final String message;

  const TransactionFailure(this.message);
}
