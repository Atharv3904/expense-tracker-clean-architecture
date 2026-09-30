import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_bloc.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_event.dart';
import 'package:expense_tracker/feature/receipts/presentation/bloc/receipt_state.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_error_state.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_list_body.dart';

import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_preview_error.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_preview_header.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ReceiptListPage extends StatefulWidget {
  const ReceiptListPage({super.key});

  @override
  State<ReceiptListPage> createState() => _ReceiptListPageState();
}

class _ReceiptListPageState extends State<ReceiptListPage> {
  static const Color _primary = Color(0xFF238E84);
  static const Color _background = Color(0xFFF5F8F7);
  static const Color _danger = Color(0xFFE0524A);

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    context.read<ReceiptBloc>().add(const GetReceipts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isImage(String fileType) {
    return fileType.startsWith('image/');
  }

  bool _isPdf(String fileType) {
    return fileType == 'application/pdf';
  }

  IconData getFileIcon(String fileType) {
    if (_isPdf(fileType)) {
      return Icons.picture_as_pdf_rounded;
    }

    if (_isImage(fileType)) {
      return Icons.image_rounded;
    }

    return Icons.receipt_long_outlined;
  }

  Future<void> _deleteReceipt(ReceiptEntity receipt) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete receipt?',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'Are you sure you want to delete "${receipt.fileName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _danger,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    context.read<ReceiptBloc>().add(
      DeleteReceipt(receiptId: receipt.id, filePath: receipt.filePath),
    );
  }

  void _viewReceipt(ReceiptEntity receipt) {
    if (!_isImage(receipt.fileType) && !_isPdf(receipt.fileType)) {
      AppSnackbar.show(context, message: 'Unsupported receipt type.');
      return;
    }

    context.read<ReceiptBloc>().add(
      GetReceiptUrl(
        filePath: receipt.filePath,
        fileName: receipt.fileName,
        fileType: receipt.fileType,
      ),
    );
  }

  void _showReceiptPreview({
    required String url,
    required String fileName,
    required String fileType,
  }) {
    if (_isPdf(fileType)) {
      _showPdfPreview(url: url, fileName: fileName);
      return;
    }

    _showImagePreview(url: url, fileName: fileName);
  }

  void _showImagePreview({required String url, required String fileName}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 600,
            height: 700,
            child: Column(
              children: [
                ReceiptPreviewHeader(
                  fileName: fileName,
                  onClose: () {
                    Navigator.pop(dialogContext);

                    context.read<ReceiptBloc>().add(const GetReceipts());
                  },
                ),

                Expanded(
                  child: InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 4,
                    child: Center(
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return const CircularProgressIndicator(
                            color: Colors.white,
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const ReceiptPreviewError();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPdfPreview({required String url, required String fileName}) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 900,
            height: 750,
            child: Column(
              children: [
                ReceiptPreviewHeader(
                  fileName: fileName,
                  backgroundColor: _primary,
                  onClose: () {
                    Navigator.pop(dialogContext);

                    context.read<ReceiptBloc>().add(const GetReceipts());
                  },
                ),

                Expanded(child: SfPdfViewer.network(url)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReceiptBloc>().add(const GetReceipts());
      },
      child: Scaffold(
        backgroundColor: _background,
        body: BlocListener<ReceiptBloc, ReceiptState>(
          listener: (context, state) {
            if (state is ReceiptDeleteSuccess) {
              AppSnackbar.show(
                context,
                message: 'Receipt deleted successfully',
              );

              context.read<ReceiptBloc>().add(const GetReceipts());
            }

            if (state is ReceiptUrlLoaded) {
              _showReceiptPreview(
                url: state.url,
                fileName: state.fileName,
                fileType: state.fileType,
              );
            }

            if (state is ReceiptFailure) {
              AppSnackbar.show(context, message: state.message);
            }
          },

          child: BlocBuilder<ReceiptBloc, ReceiptState>(
            builder: (context, state) {
              if (state is ReceiptLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: _primary),
                );
              }

              if (state is ReceiptFailure) {
                return ReceiptErrorState(
                  message: state.message,
                  onRetry: () {
                    context.read<ReceiptBloc>().add(const GetReceipts());
                  },
                );
              }

              if (state is ReceiptsLoaded) {
                return ReceiptListBody(
                  receipts: state.receipts,
                  searchController: _searchController,
                  searchQuery: _searchQuery,

                  onBack: () {
                    Navigator.maybePop(context);
                  },

                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },

                  onClearSearch: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },

                  onView: _viewReceipt,

                  onDelete: _deleteReceipt,
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
