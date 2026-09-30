import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';

class ReceiptModel extends ReceiptEntity {
  ReceiptModel({
    required super.id,
    required super.userId,

    required super.fileName,
    required super.filePath,
    required super.fileType,
    required super.fileSize,
    required super.createdAt,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    return ReceiptModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,

      fileName: json['file_name'] as String,
      filePath: json['file_path'] as String,
      fileType: json['file_type'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,

      'file_name': fileName,
      'file_path': filePath,
      'file_type': fileType,
      'file_size': fileSize,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
