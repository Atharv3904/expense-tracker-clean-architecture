class TransactionFilter {
  final DateTime? date;
  final int? month;
  final double? minAmount;
  final double? maxAmount;
  final String? typeId;
  final String? categoryId;
  final TransactionSort sort;

  const TransactionFilter({
    this.date,
    this.month,
    this.minAmount,
    this.maxAmount,
    this.typeId,
    this.categoryId,
    this.sort = TransactionSort.newest,
  });
}

enum TransactionSort { newest, oldest, highest, lowest }
