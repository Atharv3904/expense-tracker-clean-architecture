import 'package:dartz/dartz.dart';
import 'package:expense_tracker/core/errors/app_exception.dart';
import 'package:expense_tracker/core/errors/app_failure.dart';
import 'package:expense_tracker/core/types/app_result.dart';
import 'package:expense_tracker/feature/receipts/data/datasource/receipt_remote_datasource.dart';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/domain/params/delete_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/params/upload_receipt_params.dart';
import 'package:expense_tracker/feature/receipts/domain/repository/receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDatasource datasource;

  const ReceiptRepositoryImpl(this.datasource);

  @override
  AppResult<ReceiptEntity> uploadReceipt(UploadReceiptParams params) async {
    try {
      final result = await datasource.uploadReceipt(params);

      return Right(result);
    } on ReceiptException catch (e) {
      return Left(ReceiptFailure(e.message));
    } catch (e) {
      return Left(ReceiptFailure('Failed to upload receipt'));
    }
  }

  @override
  AppResult<List<ReceiptEntity>> getReceipts() async {
    try {
      final result = await datasource.getReceipts();

      return Right(result);
    } on ReceiptException catch (e) {
      return Left(ReceiptFailure(e.message));
    } catch (e) {
      return Left(ReceiptFailure('Failed to get receipts'));
    }
  }

  @override
  AppResult<void> deleteReceipt(DeleteReceiptParams params) async {
    try {
      await datasource.deleteReceipt(params);

      return const Right(null);
    } on ReceiptException catch (e) {
      return Left(ReceiptFailure(e.message));
    } catch (e) {
      return Left(ReceiptFailure('Failed to delete receipt'));
    }
  }

  @override
  AppResult<String> getReceiptUrl(String filePath) async {
    try {
      final result = await datasource.getReceiptUrl(filePath);

      return Right(result);
    } on ReceiptException catch (e) {
      return Left(ReceiptFailure(e.message));
    } catch (e) {
      return const Left(ReceiptFailure('Failed to generate receipt URL'));
    }
  }
}
