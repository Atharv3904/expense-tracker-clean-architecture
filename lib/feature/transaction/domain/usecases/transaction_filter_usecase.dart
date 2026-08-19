import '../entities/transaction_entity.dart';
import '../entities/transaction_filter.dart';

class TransactionFilterUsecase {
  List<TransactionEntity> call(
    List<TransactionEntity> transactions,
    TransactionFilter filter,
  ) {
    var result = List<TransactionEntity>.from(transactions);

    // Date
    if (filter.date != null) {
      result = result.where((transaction) {
        return transaction.date.year == filter.date!.year &&
            transaction.date.month == filter.date!.month &&
            transaction.date.day == filter.date!.day;
      }).toList();
    }

    // Amount
    if (filter.minAmount != null) {
      result = result.where((transaction) {
        return transaction.amount >= filter.minAmount!;
      }).toList();
    }

    if (filter.maxAmount != null) {
      result = result.where((transaction) {
        return transaction.amount <= filter.maxAmount!;
      }).toList();
    }

    // Type
    if (filter.typeId != null) {
      result = result.where((transaction) {
        return transaction.typeId == filter.typeId;
      }).toList();
    }

    // Category
    if (filter.categoryId != null) {
      result = result.where((transaction) {
        return transaction.categoryId == filter.categoryId;
      }).toList();
    }
    //month
    if (filter.month != null) {
      result = result.where((transaction) {
        return transaction.date.month == filter.month;
      }).toList();
    }

    // Sort
    switch (filter.sort) {
      case TransactionSort.newest:
        result.sort((a, b) => b.date.compareTo(a.date));
        break;

      case TransactionSort.oldest:
        result.sort((a, b) => a.date.compareTo(b.date));
        break;

      case TransactionSort.highest:
        result.sort((a, b) => b.amount.compareTo(a.amount));
        break;

      case TransactionSort.lowest:
        result.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return result;
  }
}
