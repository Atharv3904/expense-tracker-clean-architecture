import 'package:expense_tracker/feature/receipts/domain/entity/receipt_entity.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_empty_state.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_list_card.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_list_header.dart';
import 'package:expense_tracker/feature/receipts/presentation/widget/receipt_search_field.dart';
import 'package:flutter/material.dart';

class ReceiptListBody extends StatelessWidget {
  final List<ReceiptEntity> receipts;

  final TextEditingController searchController;
  final String searchQuery;

  final VoidCallback onBack;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  final void Function(ReceiptEntity receipt) onView;
  final void Function(ReceiptEntity receipt) onDelete;

  const ReceiptListBody({
    super.key,
    required this.receipts,
    required this.searchController,
    required this.searchQuery,
    required this.onBack,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onView,
    required this.onDelete,
  });

  static const Color _primary = Color(0xFF238E84);
  static const Color _danger = Color(0xFFE0524A);

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _isImage(String fileType) {
    return fileType.startsWith('image/');
  }

  bool _isPdf(String fileType) {
    return fileType == 'application/pdf';
  }

  IconData _getFileIcon(String fileType) {
    if (_isPdf(fileType)) {
      return Icons.picture_as_pdf_rounded;
    }

    if (_isImage(fileType)) {
      return Icons.image_rounded;
    }

    return Icons.receipt_long_outlined;
  }

  Color _getFileColor(String fileType) {
    if (_isPdf(fileType)) {
      return _danger;
    }

    if (_isImage(fileType)) {
      return const Color(0xFF4D7CFE);
    }

    return _primary;
  }

  @override
  Widget build(BuildContext context) {
    final filteredReceipts = receipts.where((receipt) {
      return receipt.fileName.toLowerCase().contains(searchQuery);
    }).toList();

    return Column(
      children: [
        ReceiptListHeader(
          onBack: onBack,
          searchField: ReceiptSearchField(
            controller: searchController,
            searchQuery: searchQuery,
            onChanged: onSearchChanged,
            onClear: onClearSearch,
          ),
        ),

        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: filteredReceipts.isEmpty
                  ? ReceiptEmptyState(isSearching: searchQuery.isNotEmpty)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                      itemCount: filteredReceipts.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 18);
                      },
                      itemBuilder: (context, index) {
                        final receipt = filteredReceipts[index];

                        return ReceiptListCard(
                          receipt: receipt,
                          fileSize: _formatFileSize(receipt.fileSize),
                          icon: _getFileIcon(receipt.fileType),
                          iconColor: _getFileColor(receipt.fileType),
                          onView: () {
                            onView(receipt);
                          },
                          onDelete: () {
                            onDelete(receipt);
                          },
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
