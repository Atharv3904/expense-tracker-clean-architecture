import 'package:expense_tracker/feature/receipts/domain/usecases/delete_receipt_usecase.dart';
import 'package:expense_tracker/feature/receipts/domain/usecases/get_receipt_url_usecase.dart';
import 'package:expense_tracker/feature/receipts/domain/usecases/get_receipts_usecase.dart';
import 'package:expense_tracker/feature/receipts/domain/usecases/upload_receipt_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/params/delete_receipt_params.dart';
import '../../domain/params/upload_receipt_params.dart';
import 'receipt_event.dart';
import 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final UploadReceiptUsecase uploadReceiptUsecase;
  final GetReceiptsUsecase getReceiptsUsecase;
  final DeleteReceiptUsecase deleteReceiptUsecase;
  final GetReceiptUrlUsecase getReceiptUrlUsecase;

  ReceiptBloc(
    this.uploadReceiptUsecase,
    this.getReceiptsUsecase,
    this.deleteReceiptUsecase,
    this.getReceiptUrlUsecase,
  ) : super(const ReceiptInitial()) {
    on<UploadReceipt>(_onUploadReceipt);
    on<GetReceipts>(_onGetReceipts);
    on<DeleteReceipt>(_onDeleteReceipt);
    on<GetReceiptUrl>(_onGetReceiptUrl);
  }

  Future<void> _onUploadReceipt(
    UploadReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());

    final result = await uploadReceiptUsecase(
      UploadReceiptParams(file: event.file),
    );

    result.fold(
      (failure) {
        emit(ReceiptFailure(failure.message));
      },
      (receipt) {
        emit(ReceiptUploadSuccess(receipt));
      },
    );
  }

  Future<void> _onGetReceipts(
    GetReceipts event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());

    final result = await getReceiptsUsecase();

    result.fold(
      (failure) {
        emit(ReceiptFailure(failure.message));
      },
      (receipts) {
        emit(ReceiptsLoaded(receipts));
      },
    );
  }

  Future<void> _onDeleteReceipt(
    DeleteReceipt event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());

    final result = await deleteReceiptUsecase(
      DeleteReceiptParams(receiptId: event.receiptId, filePath: event.filePath),
    );

    result.fold(
      (failure) {
        emit(ReceiptFailure(failure.message));
      },
      (_) {
        emit(const ReceiptDeleteSuccess());
      },
    );
  }

  Future<void> _onGetReceiptUrl(
    GetReceiptUrl event,
    Emitter<ReceiptState> emit,
  ) async {
    emit(const ReceiptLoading());

    final result = await getReceiptUrlUsecase(event.filePath);

    result.fold(
      (failure) {
        emit(ReceiptFailure(failure.message));
      },
      (url) {
        emit(
          ReceiptUrlLoaded(
            url: url,
            fileName: event.fileName,
            fileType: event.fileType,
          ),
        );
      },
    );
  }
}
