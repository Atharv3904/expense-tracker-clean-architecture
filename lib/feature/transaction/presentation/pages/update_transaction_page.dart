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

    loadTransactionData();
  }

  // UI -> Bloc
  // No UseCase is called directly from UI.
  void loadTransactionData() {}

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

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Transaction?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this transaction? '
            'This action cannot be undone.',
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
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
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
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    final horizontalPadding = isMobile ? 16.0 : 24.0;

    final maxWidth = isMobile
        ? double.infinity
        : isTablet
        ? 750.0
        : 900.0;

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
          listener: (context, state) {
            if (state is TransactionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction updated successfully'),
                ),
              );

              context.pop(true);
            }

            if (state is TransactionDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Transaction deleted successfully'),
                ),
              );

              context.pop(true);
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
            'Update Transaction',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFF7F7FA),
          elevation: 0,
        ),

        body: SingleChildScrollView(
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
                        Icon(
                          Icons.edit_note,
                          color: Colors.green,
                          size: isMobile ? 30 : 35,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            'Update your transaction',
                            style: TextStyle(
                              fontSize: isMobile ? 17 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                            backgroundColor:
                                transactionTypes.any(
                                  (type) =>
                                      type.type == 'income' &&
                                      type.id == selectedTypeId,
                                )
                                ? Colors.green
                                : Colors.white,

                            foregroundColor:
                                transactionTypes.any(
                                  (type) =>
                                      type.type == 'income' &&
                                      type.id == selectedTypeId,
                                )
                                ? Colors.white
                                : Colors.black,

                            padding: const EdgeInsets.symmetric(vertical: 15),

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text('Income'),
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
                            backgroundColor:
                                transactionTypes.any(
                                  (type) =>
                                      type.type == 'expense' &&
                                      type.id == selectedTypeId,
                                )
                                ? Colors.red
                                : Colors.white,

                            foregroundColor:
                                transactionTypes.any(
                                  (type) =>
                                      type.type == 'expense' &&
                                      type.id == selectedTypeId,
                                )
                                ? Colors.white
                                : Colors.black,

                            padding: const EdgeInsets.symmetric(vertical: 15),

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text('Expense'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: amountController,

                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    decoration: InputDecoration(
                      hintText: 'Enter amount',
                      prefixText: '₹ ',

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
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                    initialValue:
                        categories.any(
                          (category) => category.id == selectedCategoryId,
                        )
                        ? selectedCategoryId
                        : null,

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

                  const SizedBox(height: 20),

                  const Text(
                    'Description',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                      ),

                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.green),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              '//${selectedDate.day}/'
                              '${selectedDate.month}/'
                              '${selectedDate.year}',
                            ),
                          ),

                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  BlocBuilder<TransactionBloc, TransactionState>(
                    builder: (context, state) {
                      if (state is TransactionLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed: updateTransaction,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,

                            elevation: 0,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: const Text(
                            'Update Transaction',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: OutlinedButton(
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },

                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,

                        side: const BorderSide(color: Colors.red),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      child: const Text(
                        'Delete Transaction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
    );
  }
}
