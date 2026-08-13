import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required super.id,
    required super.userId,
    required super.amount,
    required super.typeId,
    required super.categoryId,
    required super.description,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      typeId: json['type_id'] as String,
      categoryId: json['category_id'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'type_id': typeId,
      'category_id': categoryId,
      'description': description,
      'created_at': date.toIso8601String(),
    };
  }
}
