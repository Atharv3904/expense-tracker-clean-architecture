import 'package:expense_tracker/core/constants/app_constants.dart';
import 'package:expense_tracker/core/notification/notification_service.dart';
import 'package:expense_tracker/core/responsive/responsive.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/feature/profile/presentation/bloc/profile_states.dart';
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

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedTypeId;
  String? selectedCategoryId;
  String? userId;

  List<TransactionTypeEntity> transactionTypes = [];
  List<TransactionCategoryEntity> categories = [];

  DateTime selectedDate = DateTime.now();

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

  void saveTransaction() {
    if (!validateTransaction()) {
      return;
    }

    final transaction = TransactionEntity(
      id: '',
      userId: userId!,
      amount: double.parse(amountController.text.trim()),
      typeId: selectedTypeId!,
      categoryId: selectedCategoryId!,
      description: descriptionController.text.trim(),
      date: selectedDate,
    );

    context.read<TransactionBloc>().add(AddTransaction(transaction));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 18.0 : 28.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 700.0
        : 900.0;

    final income = transactionTypes
        .where((type) => type.type == 'income')
        .firstOrNull;

    final expense = transactionTypes
        .where((type) => type.type == 'expense')
        .firstOrNull;

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
              _showMessage('Transaction added successfully');

              if (userId != null) {
                await NotificationService().sendNotification(
                  userId: userId!,
                  title: 'Transaction Added 💰',
                  body:
                      '₹${amountController.text.trim()} transaction is added successfully.',
                );
              }
            }

            if (state is TransactionFailure) {
              _showMessage(state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            userId = state.profile.id;
          }
          return Scaffold(
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
                    const TransactionTopBackground(
                      height: 245,
                      bottomRadius: 34,
                    ),
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
                                  title: 'Add Transaction',
                                  isMobile: isMobile,
                                ),
                                SizedBox(height: isMobile ? 26 : 32),
                                TransactionFormPanel(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const TransactionInfoCard(
                                        title: 'Add your transaction',
                                        subtitle:
                                            'Track your income and expenses',
                                      ),
                                      const SizedBox(height: 26),
                                      const TransactionSectionLabel(
                                        'Transaction Type',
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TransactionTypeButton(
                                              label: 'Income',
                                              icon:
                                                  Icons.arrow_downward_rounded,
                                              color: TransactionWidgetPalette
                                                  .income,
                                              selected:
                                                  selectedTypeId == income?.id,
                                              disabled:
                                                  transactionTypes.isEmpty,
                                              onTap: transactionTypes.isEmpty
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        selectedTypeId =
                                                            income?.id;
                                                      });
                                                    },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TransactionTypeButton(
                                              label: 'Expense',
                                              icon: Icons.arrow_upward_rounded,
                                              color: TransactionWidgetPalette
                                                  .expense,
                                              selected:
                                                  selectedTypeId == expense?.id,
                                              disabled:
                                                  transactionTypes.isEmpty,
                                              onTap: transactionTypes.isEmpty
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        selectedTypeId =
                                                            expense?.id;
                                                      });
                                                    },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
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
                                      const TransactionSectionLabel(
                                        'Description',
                                      ),
                                      const SizedBox(height: 10),
                                      TransactionTextField(
                                        controller: descriptionController,
                                        hintText:
                                            'What was this transaction for?',
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
                                      TransactionPrimaryButton(
                                        label: 'Save Transaction',
                                        icon:
                                            Icons.check_circle_outline_rounded,
                                        onPressed: saveTransaction,
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
          );
        },
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
          prefixText: '${AppConstants.currencySymbol} ',
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
