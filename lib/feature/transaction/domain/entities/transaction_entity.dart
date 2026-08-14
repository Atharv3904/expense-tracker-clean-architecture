// ignore_for_file: non_constant_identifier_names

class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.userId,
    required this.amount,
    required this.typeId,
    required this.categoryId,
    required this.description,
    required this.date,
  });

  final String id; // Transaction ID , new and unique by supabase
  final String userId; // auth.users.id , foregin key
  final double amount; // Transaction amount
  final String
  typeId; // transaction_types.id foregin key , we will get from the type table
  final String
  categoryId; // categories.id  foregin key , we will get from the categories table
  final String description; // e.g. Dinner   where we spent in details
  final DateTime date; // Transaction date.  the time
}
