import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

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

class TransactionDeleteSuccess extends TransactionState {
  const TransactionDeleteSuccess();
}

class TypeLoaded extends TransactionState {
  final List<TransactionTypeEntity> types;

  const TypeLoaded(this.types);
}

class CategoryLoaded extends TransactionState {
  final List<TransactionCategoryEntity> categories;

  const CategoryLoaded(this.categories);
}

class TypeFailure extends TransactionState {
  final String message;

  const TypeFailure(this.message);
}

class CategoryFailure extends TransactionState {
  final String message;

  const CategoryFailure(this.message);
}
