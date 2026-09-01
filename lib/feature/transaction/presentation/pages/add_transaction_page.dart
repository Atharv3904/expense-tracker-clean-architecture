// ignore_for_file: unused_label, use_build_context_synchronously, non_constant_identifier_names

import 'package:expense_tracker/core/constants/app_constants.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter amount')));

      return false;
    }

    if (double.tryParse(amountController.text.trim()) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );

      return false;
    }

    if (selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select transaction type')),
      );

      return false;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select category')));

      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter description')));

      return false;
    }

    return true;
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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

    final userId = Supabase.instance.client.auth.currentUser!.id;

    final transaction = TransactionEntity(
      id: '',
      userId: userId,
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
    final income = transactionTypes
        .where((type) => type.type == 'income')
        .firstOrNull;

    final expense = transactionTypes
        .where((type) => type.type == 'expense')
        .firstOrNull;

    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    // Responsive values
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 700.0
        : 900.0;

    return MultiBlocListener(
      listeners: [
        BlocListener<TypeBloc, TypeStates>(
          listener: (context, state) async {
            if (state is TypeLoaded) {
              setState(() {
                transactionTypes = state.types;
              });
            }

            if (state is TypeFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),

        BlocListener<TransactionBloc, TransactionState>(
          listener: (context, state) async {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction added successfully')),
              );

              final userId = Supabase.instance.client.auth.currentUser?.id;

              if (userId != null) {
                await NotificationService().sendNotification(
                  userId: userId,
                  title: 'Transaction Added 💰',
                  body:
                      '₹${amountController.text.trim()} transaction is added successfully.',
                );
              }
            }

            if (state is TransactionFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),

        appBar: AppBar(
          title: const Text(
            'Add Transaction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFF7F7FA),
          elevation: 0,
        ),

        body: GestureDetector(
          onTap: () {
            behavior:
            HitTestBehavior.translucent;
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),

            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(isMobile ? 16 : 20),

                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D8FF),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.green,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  'Add your transaction',
                                  style: TextStyle(
                                    fontSize: isMobile ? 17 : 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                const Text(
                                  'Track your income and expenses',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Transaction Type',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: transactionTypes.isEmpty
                                ? null
                                : () {
                                    final income = transactionTypes.firstWhere(
                                      (type) => type.type == 'income',
                                    );

                                    setState(() {
                                      selectedTypeId = income.id;
                                    });
                                  },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTypeId == income?.id
                                  ? Colors.green
                                  : Colors.white,

                              foregroundColor: selectedTypeId == income?.id
                                  ? Colors.white
                                  : Colors.black87,

                              elevation: 0,

                              padding: const EdgeInsets.symmetric(vertical: 16),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),

                                side: BorderSide(
                                  color: selectedTypeId == income?.id
                                      ? Colors.green
                                      : Colors.black12,
                                ),
                              ),
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_downward, size: 18),
                                SizedBox(width: 6),
                                Text('Income'),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: transactionTypes.isEmpty
                                ? null
                                : () {
                                    final expense = transactionTypes.firstWhere(
                                      (type) => type.type == 'expense',
                                    );

                                    setState(() {
                                      selectedTypeId = expense.id;
                                    });
                                  },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTypeId == expense?.id
                                  ? Colors.red
                                  : Colors.white,

                              foregroundColor: selectedTypeId == expense?.id
                                  ? Colors.white
                                  : Colors.black87,

                              elevation: 0,

                              padding: const EdgeInsets.symmetric(vertical: 16),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),

                                side: BorderSide(
                                  color: selectedTypeId == expense?.id
                                      ? Colors.red
                                      : Colors.black12,
                                ),
                              ),
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.arrow_upward, size: 18),
                                SizedBox(width: 6),
                                Text('Expense'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    if (!isMobile)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(child: _buildAmountField()),

                          const SizedBox(width: 16),

                          Expanded(child: _buildCategoryField()),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildAmountField(),

                          const SizedBox(height: 20),

                          _buildCategoryField(),
                        ],
                      ),

                    const SizedBox(height: 20),

                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: descriptionController,

                      maxLines: 3,

                      decoration: InputDecoration(
                        hintText: 'What was this transaction for?',

                        filled: true,
                        fillColor: Colors.white,

                        contentPadding: const EdgeInsets.all(16),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: selectDate,

                      borderRadius: BorderRadius.circular(12),

                      child: Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: Colors.black12),
                        ),

                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 12),

                            Text(
                              '${selectedDate.day}/'
                              '${selectedDate.month}/'
                              '${selectedDate.year}',
                            ),

                            const Spacer(),

                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: saveTransaction,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.check_circle_outline),

                            SizedBox(width: 8),

                            Text(
                              'Save Transaction',

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Amount',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: amountController,

          keyboardType: const TextInputType.numberWithOptions(decimal: true),

          decoration: InputDecoration(
            hintText: 'Enter amount',

            prefixText: '${AppConstants.currencySymbol} ',

            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.all(16),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),

        const SizedBox(height: 10),

        DropdownButtonFormField<String>(
          initialValue: selectedCategoryId,

          decoration: InputDecoration(
            hintText: 'Select category',

            filled: true,
            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide.none,
            ),
          ),

          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),

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
