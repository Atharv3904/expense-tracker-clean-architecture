import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

class TypeStates {
  const TypeStates();
}

class TypeInitial extends TypeStates {
  const TypeInitial();
}

class TypeLoading extends TypeStates {
  const TypeLoading();
}

class TypeLoaded extends TypeStates {
  final List<TransactionTypeEntity> types;

  const TypeLoaded(this.types);
}

class TypeFailure extends TypeStates {
  final String message;

  const TypeFailure(this.message);
}
