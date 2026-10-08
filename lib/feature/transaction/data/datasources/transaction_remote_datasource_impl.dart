import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/feature/transaction/data/datasources/transaction_remote_datasource.dart';
import 'package:expense_tracker/feature/transaction/data/model/transaction_model.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/params/transaction_param.dart';
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
        receiptUrl = await supabaseClient.storage
            .from('receipts')
            .createSignedUrl(filePath, 60 * 10);
      }
    }

    final transactionJson = Map<String, dynamic>.from(json);

    transactionJson['receipt_id'] = receiptId;
    transactionJson['receipt_url'] = receiptUrl;

    return TransactionModel.fromJson(transactionJson);
  }

  @override
  Future<TransactionModel> addTransaction(TransactionParam param) async {
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

    final user = supabaseClient.auth.currentUser;

    if (user == null) {
      throw ServerException('User is not authenticated');
    }

    final transaction = param.transaction;
    final file = param.file;

    String? filePath;

    try {
      // ---------------------------------------------------------
      // 1. Upload receipt to Supabase Storage
      // ---------------------------------------------------------

      if (file != null) {
        // Read the actual file bytes.
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

        // -------------------------------------------------------
        // 2. Call PostgreSQL RPC
        // -------------------------------------------------------

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

        // -------------------------------------------------------
        // 3. RPC returns the newly created transaction ID
        // -------------------------------------------------------

        final transactionId = response as String;

        // -------------------------------------------------------
        // 4. Get newly created transaction
        // -------------------------------------------------------

        final transactionResponse = await supabaseClient
            .from('transactions')
            .select()
            .eq('id', transactionId)
            .single();

        return TransactionModel.fromJson(transactionResponse);
      }

      // ---------------------------------------------------------
      // No receipt selected
      // ---------------------------------------------------------

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
      // ---------------------------------------------------------
      // 5. Remove uploaded file if database/RPC failed
      // ---------------------------------------------------------

      if (filePath != null) {
        try {
          await supabaseClient.storage.from('receipts').remove([filePath]);
        } catch (_) {
          // Keep the original error.
        }
      }

      if (e is ServerException) {
        rethrow;
      }

      throw ServerException('Failed to add transaction');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final data = {
        'amount': transaction.amount,
        'type_id': transaction.typeId,
        'category_id': transaction.categoryId,
        'description': transaction.description,
        'created_at': transaction.date.toIso8601String(),
      };

      final response = await supabaseClient
          .from('transactions')
          .update(data)
          .eq('id', transaction.id)
          .select()
          .single();

      return TransactionModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to update transaction');
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
}
