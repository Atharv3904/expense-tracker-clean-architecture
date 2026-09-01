import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';

class CategoryStates {
  const CategoryStates();
}

class CategoryInitial extends CategoryStates {
  const CategoryInitial();
}

class CategoryLoaded extends CategoryStates {
  final List<TransactionCategoryEntity> categories;

  const CategoryLoaded(this.categories);
}

class CategoryFailure extends CategoryStates {
  final String message;

  const CategoryFailure(this.message);
}
