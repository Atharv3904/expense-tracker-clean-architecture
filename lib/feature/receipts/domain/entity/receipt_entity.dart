class ReceiptEntity {
  final String id;
  final String userId;

  final String fileName;
  final String filePath;
  final String fileType;
  final int fileSize;
  final DateTime createdAt;

  const ReceiptEntity({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.fileSize,
    required this.createdAt,
  });
}
