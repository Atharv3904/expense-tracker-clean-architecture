// ignore_for_file: avoid_print

import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';

import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';
import 'package:flutter/foundation.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  final SupabaseClient supabaseClient;

  TransactionRemoteDatasourceImpl(this.supabaseClient);

  @override
  Future<List<TransactionModel>> getAllTransactionData({
    String? searchQuery,
  }) async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        throw ServerException('User is not authenticated');
      }

      var query = supabaseClient
          .from('transactions')
          .select('''
          *,
          receipts (
            id,
            file_path
          )
        ''')
          .eq('user_id', user.id);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.ilike('description', '%${searchQuery.trim()}%');
      }

      final response = await query.order('updated_at', ascending: false);

      final transactions = <TransactionModel>[];

      for (final json in response as List) {
        transactions.add(
          await _transactionModelWithReceipt(Map<String, dynamic>.from(json)),
        );
      }

      return transactions;
    } catch (e) {
      debugPrint(' getAllTransactionData ERROR: $e');

      if (e is ServerException) {
        rethrow;
      }

      throw ServerException('Failed to get transaction');
    }
  }

  @override
  Future<List<TransactionModel>> getTransaction() async {
    try {
      final user = supabaseClient.auth.currentUser;

      if (user == null) {
        throw ServerException('User is not authenticated');
      }

      final response = await supabaseClient
          .from('transactions')
          .select('''
          *,
          receipts (
            id,
            file_path
          )
        ''')
          .eq('user_id', user.id)
          .order('updated_at', ascending: false)
          .limit(3);

      final transactions = <TransactionModel>[];

      for (final json in response as List) {
        transactions.add(
          await _transactionModelWithReceipt(Map<String, dynamic>.from(json)),
        );
      }

      return transactions;
    } catch (e) {
      debugPrint(' getTransaction ERROR: $e');

      if (e is ServerException) {
        rethrow;
      }

      throw ServerException('Failed to get transaction');
    }
  }

  Future<TransactionModel> _transactionModelWithReceipt(
    Map<String, dynamic> json,
  ) async {
    String? receiptId;
    String? receiptUrl;

    final receipts = json['receipts'];

    if (receipts is List && receipts.isNotEmpty) {
      final receipt = Map<String, dynamic>.from(receipts.first as Map);

      receiptId = receipt['id'] as String?;

      final filePath = receipt['file_path'] as String?;

      if (filePath != null && filePath.isNotEmpty) {
        try {
          receiptUrl = await supabaseClient.storage
              .from('receipts')
              .createSignedUrl(filePath, 60 * 10);
        } catch (e) {
          debugPrint('❌ Receipt ID: $receiptId');
          debugPrint('❌ Missing Storage path: $filePath');
          debugPrint('❌ Storage error: $e');

          receiptUrl = null;
        }
      }
    }

    final transactionJson = Map<String, dynamic>.from(json);

    transactionJson['receipt_id'] = receiptId;
    transactionJson['receipt_url'] = receiptUrl;

    return TransactionModel.fromJson(transactionJson);
  }

  @override
  Future<TransactionModel> addTransaction(TransactionParam param) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ServerException('User is not authenticated');
    }

    final transaction = param.transaction;
    final file = param.file;

    String? filePath;

    try {
      if (file != null) {
        final storageFile = await file.readAsBytes();

        final fileName = file.name;

        final safeFileName = fileName.replaceAll(RegExp(r'[/\\]'), '_');

        final timestamp = DateTime.now().microsecondsSinceEpoch;

        filePath =
            '${user.id}/'
            '${timestamp}_$safeFileName';

        final contentType = getContentType(fileName);

        await supabaseClient.storage
            .from('receipts')
            .uploadBinary(
              filePath,
              storageFile,
              fileOptions: FileOptions(contentType: contentType, upsert: false),
            );

        final response = await supabaseClient.rpc(
          'add_transaction_with_receipt',
          params: {
            'p_amount': transaction.amount,
            'p_type_id': transaction.typeId,
            'p_category_id': transaction.categoryId,
            'p_description': transaction.description,
            'p_created_at': transaction.date.toIso8601String(),

            'p_receipt_file_name': fileName,
            'p_receipt_file_path': filePath,
            'p_receipt_file_type': contentType,
            'p_receipt_file_size': storageFile.length,
          },
        );

        final transactionId = response as String;

        final transactionResponse = await supabaseClient
            .from('transactions')
            .select()
            .eq('id', transactionId)
            .single();

        return TransactionModel.fromJson(transactionResponse);
      }

      final response = await supabaseClient.rpc(
        'add_transaction_with_receipt',
        params: {
          'p_amount': transaction.amount,
          'p_type_id': transaction.typeId,
          'p_category_id': transaction.categoryId,
          'p_description': transaction.description,
          'p_created_at': transaction.date.toIso8601String(),
          'p_receipt_file_name': null,
          'p_receipt_file_path': null,
          'p_receipt_file_type': null,
          'p_receipt_file_size': null,
        },
      );

      final transactionId = response as String;

      final transactionResponse = await supabaseClient
          .from('transactions')
          .select()
          .eq('id', transactionId)
          .single();

      return TransactionModel.fromJson(transactionResponse);
    } catch (e) {
      if (filePath != null) {
        try {
          await supabaseClient.storage.from('receipts').remove([filePath]);
        } catch (_) {}
      }

      if (e is ServerException) {
        rethrow;
      }

      throw ServerException('Failed to add transaction');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionParam params) async {
    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ServerException('User is not authenticated');
    }

    final transaction = params.transaction;
    final file = params.file;

    String? newFilePath;
    String? oldFilePath;

    bool databaseUpdated = false;

    try {
      debugPrint('========== UPDATE TRANSACTION ==========');
      debugPrint('Transaction ID: ${transaction.id}');
      debugPrint('Replacement receipt: ${file?.name ?? "None"}');

      final oldReceiptResponse = await supabaseClient
          .from('receipts')
          .select('id, file_path')
          .eq('transaction_id', transaction.id)
          .maybeSingle();

      oldFilePath = oldReceiptResponse?['file_path'] as String?;

      debugPrint('Old receipt row: $oldReceiptResponse');
      debugPrint('Old receipt path: $oldFilePath');

      // ---------------------------------------------------------
      // 2. Upload the replacement receipt, if selected.
      // ---------------------------------------------------------

      String? fileName;
      String? contentType;
      int? fileSize;

      if (file != null) {
        fileName = file.name;

        final storageFile = await file.readAsBytes();

        final safeFileName = fileName.replaceAll(RegExp(r'[/\\]'), '_');

        final timestamp = DateTime.now().microsecondsSinceEpoch;

        newFilePath = '${user.id}/${timestamp}_$safeFileName';

        contentType = getContentType(fileName);
        fileSize = storageFile.length;

        await supabaseClient.storage
            .from('receipts')
            .uploadBinary(
              newFilePath,
              storageFile,
              fileOptions: FileOptions(contentType: contentType, upsert: false),
            );

        debugPrint('✅ New receipt uploaded: $newFilePath');
      }

      final rpcResponse = await supabaseClient.rpc(
        'update_transaction_with_receipt',
        params: {
          'p_transaction_id': transaction.id,
          'p_amount': transaction.amount,
          'p_type_id': transaction.typeId,
          'p_category_id': transaction.categoryId,
          'p_description': transaction.description,
          'p_created_at': transaction.date.toIso8601String(),
          'p_receipt_file_name': fileName,
          'p_receipt_file_path': newFilePath,
          'p_receipt_file_type': contentType,
          'p_receipt_file_size': fileSize,
        },
      );

      debugPrint('RPC response: $rpcResponse');

      databaseUpdated = true;

      debugPrint('✅ Transaction and receipt metadata updated');

      if (file != null &&
          oldFilePath != null &&
          oldFilePath.isNotEmpty &&
          oldFilePath != newFilePath) {
        try {
          await supabaseClient.storage.from('receipts').remove([oldFilePath]);

          debugPrint('✅ Old receipt removed: $oldFilePath');
        } catch (e) {
          // The database is already updated.
          // Never delete the new file because old-file cleanup failed.
          debugPrint('⚠️ Could not remove old receipt: $oldFilePath');
          debugPrint('Storage cleanup error: $e');
        }
      }

      final updatedResponse = await supabaseClient
          .from('transactions')
          .select('''
          *,
          receipts (
            id,
            file_path
          )
        ''')
          .eq('id', transaction.id)
          .eq('user_id', user.id)
          .single();

      final updatedTransaction = await _transactionModelWithReceipt(
        Map<String, dynamic>.from(updatedResponse),
      );

      debugPrint('✅ Updated transaction fetched successfully');
      debugPrint('========================================');

      return updatedTransaction;
    } catch (e, stackTrace) {
      debugPrint('❌ UPDATE TRANSACTION ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!databaseUpdated && newFilePath != null) {
        try {
          await supabaseClient.storage.from('receipts').remove([newFilePath]);

          debugPrint('Cleaned up failed replacement upload: $newFilePath');
        } catch (cleanupError) {
          debugPrint('⚠️ New-file cleanup failed: $cleanupError');
        }
      }

      if (e is ServerException) {
        rethrow;
      }

      throw ServerException('Failed to update transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await supabaseClient
          .from('transactions')
          .delete()
          .eq('id', transactionId)
          .select();
    } catch (e) {
      throw ServerException('Failed to delete transaction');
    }
  }

  String getContentType(String fileName) {
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
        throw ServerException('Unsupported file type');
    }
  }
}
