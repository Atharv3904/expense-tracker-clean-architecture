import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

class TransactionTypeModel extends TransactionTypeEntity {
  TransactionTypeModel({required super.id, required super.type});

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    return TransactionTypeModel(id: json['id'], type: json['type']);
  }
}
