// ignore_for_file: use_build_context_synchronously

import 'package:expense_tracker/core/notification/notification_service.dart';
import 'package:expense_tracker/core/responsive/responsive.dart';

import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';

import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/category_bloc/category_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_bloc/transaction_event.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/type_bloc/type_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_date_field.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_dropdown_field.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_header.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_info_card.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_primary_button.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_section_label.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_text_field.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_top_background.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_type_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateTransactionPage extends StatefulWidget {
  final TransactionEntity transaction;

  const UpdateTransactionPage({super.key, required this.transaction});

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedTypeId;
  String? selectedCategoryId;
  String? userId;

  List<TransactionTypeEntity> transactionTypes = [];
  List<TransactionCategoryEntity> categories = [];

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    amountController.text = widget.transaction.amount.toString();

    descriptionController.text = widget.transaction.description;

    selectedTypeId = widget.transaction.typeId;
    selectedCategoryId = widget.transaction.categoryId;
    selectedDate = widget.transaction.date;
    userId = widget.transaction.userId;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool validateTransaction() {
    if (amountController.text.trim().isEmpty) {
      _showMessage('Please enter amount');
      return false;
    }

    if (double.tryParse(amountController.text.trim()) == null) {
      _showMessage('Please enter a valid amount');
      return false;
    }

    if (selectedTypeId == null) {
      _showMessage('Please select transaction type');
      return false;
    }

    if (selectedCategoryId == null) {
      _showMessage('Please select category');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      _showMessage('Please enter description');
      return false;
    }

    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void updateTransaction() {
    if (!validateTransaction()) {
      return;
    }

    final updatedTransaction = TransactionEntity(
      id: widget.transaction.id,
      userId: widget.transaction.userId,
      amount: double.parse(amountController.text.trim()),
      typeId: selectedTypeId!,
      categoryId: selectedCategoryId!,
      description: descriptionController.text.trim(),
      date: selectedDate,
    );

    context.read<TransactionBloc>().add(UpdateTransaction(updatedTransaction));
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: TransactionWidgetPalette.teal,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: const Text(
            'Delete Transaction?',
            style: TextStyle(
              color: TransactionWidgetPalette.ink,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this transaction? '
            'This action cannot be undone.',
            style: TextStyle(
              color: TransactionWidgetPalette.muted,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                dialogContext.pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dialogContext.pop(true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: TransactionWidgetPalette.expense,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      context.read<TransactionBloc>().add(
        DeleteTransaction(widget.transaction.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 750.0
        : 900.0;

    final incomeSelected = transactionTypes.any(
      (type) => type.type == 'income' && type.id == selectedTypeId,
    );

    final expenseSelected = transactionTypes.any(
      (type) => type.type == 'expense' && type.id == selectedTypeId,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<TypeBloc, TypeStates>(
          listener: (context, state) {
            if (state is TypeLoaded) {
              setState(() {
                transactionTypes = state.types;
              });
            }

            if (state is TypeFailure) {
              _showMessage(state.message);
            }
          },
        ),
        BlocListener<CategoryBloc, CategoryStates>(
          listener: (context, state) {
            if (state is CategoryLoaded) {
              setState(() {
                categories = state.categories;
              });
            }

            if (state is CategoryFailure) {
              _showMessage(state.message);
            }
          },
        ),
        BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) async {
            if (state is TransactionSuccess) {
              _showMessage('Transaction updated successfully');

              context.pop(true);

              if (userId != null) {
                await NotificationService().sendNotification(
                  userId: userId!,
                  title: 'Transaction updated Successfully 💰',
                  body:
                      '₹${amountController.text.trim()} transaction is updated successfully.',
                );
              }
            }

            if (state is TransactionDeleteSuccess) {
              _showMessage('Transaction deleted successfully');

              context.pop(true);

              if (userId != null) {
                await NotificationService().sendNotification(
                  userId: userId!,
                  title: 'Transaction deleted Successfully 💰',
                  body:
                      '₹${amountController.text.trim()} transaction is deleted successfully.',
                );
              }
            }

            if (state is TransactionFailure) {
              _showMessage(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: TransactionWidgetPalette.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                const TransactionTopBackground(height: 245, bottomRadius: 38),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          isMobile ? 16 : 24,
                          horizontalPadding,
                          28,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TransactionHeader(
                              title: 'Update Transaction',
                              isMobile: isMobile,
                              trailing: Material(
                                color: Colors.white.withValues(alpha: 0.14),
                                shape: const CircleBorder(),
                              ),
                            ),
                            SizedBox(height: isMobile ? 28 : 34),
                            TransactionFormPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TransactionInfoCard(
                                    title: 'Update your transaction',
                                    icon: Icons.edit_note_rounded,
                                  ),
                                  const SizedBox(height: 26),
                                  const TransactionSectionLabel('Type'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TransactionTypeButton(
                                          label: 'Income',
                                          icon: Icons.arrow_downward_rounded,
                                          color:
                                              TransactionWidgetPalette.income,
                                          selected: incomeSelected,
                                          disabled: transactionTypes.isEmpty,
                                          onTap: transactionTypes.isEmpty
                                              ? null
                                              : () {
                                                  final income =
                                                      transactionTypes
                                                          .firstWhere(
                                                            (type) =>
                                                                type.type ==
                                                                'income',
                                                          );

                                                  setState(() {
                                                    selectedTypeId = income.id;
                                                  });
                                                },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TransactionTypeButton(
                                          label: 'Expense',
                                          icon: Icons.arrow_upward_rounded,
                                          color:
                                              TransactionWidgetPalette.expense,
                                          selected: expenseSelected,
                                          disabled: transactionTypes.isEmpty,
                                          onTap: transactionTypes.isEmpty
                                              ? null
                                              : () {
                                                  final expense =
                                                      transactionTypes
                                                          .firstWhere(
                                                            (type) =>
                                                                type.type ==
                                                                'expense',
                                                          );

                                                  setState(() {
                                                    selectedTypeId = expense.id;
                                                  });
                                                },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),
                                  if (!isMobile)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: _amountField()),
                                        const SizedBox(width: 16),
                                        Expanded(child: _categoryField()),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        _amountField(),
                                        const SizedBox(height: 20),
                                        _categoryField(),
                                      ],
                                    ),
                                  const SizedBox(height: 20),
                                  const TransactionSectionLabel('Description'),
                                  const SizedBox(height: 10),
                                  TransactionTextField(
                                    controller: descriptionController,
                                    hintText: 'What was this transaction for?',
                                    icon: Icons.notes_rounded,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 20),
                                  const TransactionSectionLabel('Date'),
                                  const SizedBox(height: 10),
                                  TransactionDateField(
                                    selectedDate: selectedDate,
                                    onTap: selectDate,
                                  ),
                                  const SizedBox(height: 30),
                                  BlocBuilder<
                                    TransactionBloc,
                                    TransactionState
                                  >(
                                    builder: (context, state) {
                                      return TransactionPrimaryButton(
                                        label: 'Update Transaction',
                                        icon:
                                            Icons.check_circle_outline_rounded,
                                        isLoading: state is TransactionLoading,
                                        onPressed: updateTransaction,
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _showDeleteConfirmation(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor:
                                            TransactionWidgetPalette.expense,
                                        side: const BorderSide(
                                          color:
                                              TransactionWidgetPalette.expense,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Delete Transaction',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _amountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TransactionSectionLabel('Amount'),
        const SizedBox(height: 10),
        TransactionTextField(
          controller: amountController,
          hintText: 'Enter amount',
          prefixText: '₹ ',
          icon: Icons.payments_rounded,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }

  Widget _categoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TransactionSectionLabel('Category'),
        const SizedBox(height: 10),

        TransactionDropdownField(
          value: selectedCategoryId,
          hintText: 'Select category',
          icon: Icons.category_rounded,

          items: {
            for (final category in categories) category.name: category.id,
          },

          onChanged: (value) {
            setState(() {
              selectedCategoryId = value;
            });
          },
        ),
      ],
    );
  }
}
