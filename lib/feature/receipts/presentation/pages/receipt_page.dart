import 'package:expense_tracker/core/router/routes_name.dart';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_bloc.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_event.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_state.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_header_upload.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_upload_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ReceiptPage extends StatefulWidget {
  final VoidCallback onBack;

  const ReceiptPage({super.key, required this.onBack});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  static const Color _background = Color(0xFFF5F8F7);

  @override
  void initState() {
    super.initState();

    context.read<ReceiptBloc>().add(const GetReceipts());
  }

  Future<void> _pickAndUploadReceipt() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );

    if (file == null || !mounted) {
      return;
    }

    context.read<ReceiptBloc>().add(UploadReceipt(file: file));
  }

  void _viewAllReceipts() {
    context.push(RoutesName.receiptList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: BlocListener<ReceiptBloc, ReceiptState>(
        listener: (context, state) {
          if (state is ReceiptUploadSuccess) {
            AppSnackbar.show(context, message: 'Receipt uploaded successfully');

            context.read<ReceiptBloc>().add(const GetReceipts());
          }

          if (state is ReceiptDeleteSuccess) {
            AppSnackbar.show(context, message: 'Receipt deleted successfully');

            context.read<ReceiptBloc>().add(const GetReceipts());
          }

          if (state is ReceiptFailure) {
            AppSnackbar.show(context, message: state.message);
          }
        },

        child: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            final isLoading = state is ReceiptLoading;

            return Column(
              children: [
                ReceiptHeaderUpload(onBack: widget.onBack),

                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                        child: ReceiptUploadCard(
                          isLoading: isLoading,
                          onUpload: _pickAndUploadReceipt,
                          onViewAll: _viewAllReceipts,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
