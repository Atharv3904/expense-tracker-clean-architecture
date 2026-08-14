import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';

class TransactionCategoryModel extends TransactionCategoryEntity {
  TransactionCategoryModel({required super.id, required super.name});

  factory TransactionCategoryModel.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryModel(id: json['id'], name: json['name']);
  }
}
