import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/receipts/data/model/receipt_model.dart';
import 'package:expense_tracker/feature/receipts/domain/params/delete_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/params/upload_receipt_params.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'receipt_remote_datasource.dart';

class ReceiptRemoteDatasourceImpl implements ReceiptRemoteDatasource {
  final SupabaseClient supabaseClient;

  ReceiptRemoteDatasourceImpl(this.supabaseClient);

  static const String _bucketName = 'receipts';

  @override
  Future<ReceiptModel> uploadReceipt(UploadReceiptParams params) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ReceiptException('User not logged in');
    }

    final file = params.file;

    try {
      final userId = user.id;

      final fileName = file.name;

      final safeFileName = fileName.replaceAll(RegExp(r'[/\\]'), '_');

      final timestamp = DateTime.now().microsecondsSinceEpoch;

      final filePath =
          '$userId/'
          '${timestamp}_$safeFileName';

      // Read the actual file bytes.
      final storageFile = await file.readAsBytes();

      final contentType = _getContentType(fileName);

      // 1. Upload actual file to Supabase Storage.
      await supabaseClient.storage
          .from(_bucketName)
          .uploadBinary(
            filePath,
            storageFile,
            fileOptions: FileOptions(contentType: contentType),
          );

      // 2. Store only file metadata in PostgreSQL.
      final response = await supabaseClient
          .from('receipts')
          .insert({
            'user_id': userId,
            'file_name': fileName,
            'file_path': filePath,
            'file_type': contentType,
            'file_size': storageFile.length,
          })
          .select()
          .single();

      return ReceiptModel.fromJson(response);
    } on StorageException catch (e) {
      throw ReceiptException(e.message);
    } on PostgrestException catch (e) {
      throw ReceiptException(e.message);
    } catch (e) {
      if (e is ReceiptException) {
        rethrow;
      }

      throw ReceiptException('Failed to upload receipt');
    }
  }

  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return 'application/pdf';

      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';

      case 'png':
        return 'image/png';

      case 'webp':
        return 'image/webp';

      default:
        throw ReceiptException('Unsupported file type');
    }
  }

  @override
  Future<List<ReceiptModel>> getReceipts() async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ReceiptException('User not logged in');
    }

    try {
      final response = await supabaseClient
          .from('receipts')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ReceiptModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw ReceiptException(e.message);
    } catch (e) {
      if (e is ReceiptException) {
        rethrow;
      }

      throw ReceiptException('Failed to get receipts');
    }
  }

  @override
  Future<void> deleteReceipt(DeleteReceiptParams params) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ReceiptException('User not logged in');
    }

    try {
      // 1. Delete actual file from Supabase Storage.
      await supabaseClient.storage.from(_bucketName).remove([params.filePath]);

      // 2. Delete metadata from PostgreSQL.
      await supabaseClient
          .from('receipts')
          .delete()
          .eq('id', params.receiptId)
          .eq('user_id', user.id);
    } on StorageException catch (e) {
      throw ReceiptException(e.message);
    } on PostgrestException catch (e) {
      throw ReceiptException(e.message);
    } catch (e) {
      if (e is ReceiptException) {
        rethrow;
      }

      throw ReceiptException('Failed to delete receipt');
    }
  }

  @override
  Future<String> getReceiptUrl(String filePath) async {
    try {
      final signedUrl = await supabaseClient.storage
          .from(_bucketName)
          .createSignedUrl(filePath, 60 * 10);

      return signedUrl;
    } on StorageException catch (e) {
      throw ReceiptException(e.message);
    } catch (e) {
      if (e is ReceiptException) {
        rethrow;
      }

      throw ReceiptException('Failed to generate receipt URL');
    }
  }
}
