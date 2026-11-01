import 'dart:ui';
import 'package:expense_tracker/core/utils/app_snackbar.dart';
import 'package:expense_tracker/core/widgets/liquid_glass.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: isDark
                ? const Color(0xFF1E293B).withValues(alpha: 0.95)
                : Colors.white.withValues(alpha: 0.95),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.9),
                width: 1.5,
              ),
            ),
            title: Text(
              'Delete receipt?',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${receipt.fileName}"?',
              style: TextStyle(
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              LiquidGlassButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE11D48),
                    Color(0xFFBE123C),
                  ],
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
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
        backgroundColor: Colors.transparent,
        body: LiquidGlassBackground(
          child: BlocListener<ReceiptBloc, ReceiptState>(
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
      ),
    );
  }
}
