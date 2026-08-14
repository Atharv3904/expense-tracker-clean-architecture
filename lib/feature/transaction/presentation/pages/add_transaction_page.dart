// ignore_for_file: non_constant_identifier_names

import 'package:expense_tracker/core/di/injection_container.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_category_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/entities/transaction_type_entity.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_categories_usecase.dart';
import 'package:expense_tracker/feature/transaction/domain/usecases/transaction_types_usecase.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_bloc.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transacation_states.dart';
import 'package:expense_tracker/feature/transaction/presentation/bloc/transaction_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    print('INIT STATE CALLED');
    loadTransactionData();
  }

  bool validateTransaction() {
    if (amountController.text.trim().isEmpty) {
      print('Amount is empty');
      return false;
    }

    if (selectedTypeId == null) {
      print('Type is not selected');
      return false;
    }

    if (selectedCategoryId == null) {
      print('Category is not selected');
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      print('Description is empty');
      return false;
    }

    return true;
  }

  Future<void> loadTransactionData() async {
    final typeUsecase = sl<TransactionTypesUsecase>();
    final categoryUsecase = sl<TransactionCategoriesUsecase>();

    final types = await typeUsecase();

    final categoriesList = await categoryUsecase();

    setState(() {
      transactionTypes = types;
      categories = categoriesList;
    });
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

  @override
  Widget build(BuildContext context) {
    final income = transactionTypes
        .where((type) => type.type == 'income')
        .firstOrNull;

    final expense = transactionTypes
        .where((type) => type.type == 'expense')
        .firstOrNull;

    return BlocProvider(
      create: (context) => sl<TransactionBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if (state is TransactionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Transaction added successfully'),
                  ),
                );

                context.pop();
              }
              if (state is TransactionFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
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

              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D8FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            color: Colors.green,
                            size: 35,
                          ),

                          SizedBox(width: 12),

                          Text(
                            'Add your transaction',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Type
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
                                      (Transactiontype) =>
                                          Transactiontype.type == 'income',
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
                                  : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                    final Expense = transactionTypes.firstWhere(
                                      (Transactiontype) =>
                                          Transactiontype.type == 'expense',
                                    );

                                    setState(() {
                                      selectedTypeId = Expense.id;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedTypeId == expense?.id
                                  ? Colors.red
                                  : Colors.white,
                              foregroundColor: selectedTypeId == expense?.id
                                  ? Colors.white
                                  : Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('Expense'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Amount
                    const Text(
                      'Amount',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        prefixText: '₹ ',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Category
                    const Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      initialValue: selectedCategoryId,
                      decoration: InputDecoration(
                        hintText: 'Select category',
                        filled: true,
                        fillColor: Colors.white,
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

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'What was this transaction for?',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Date
                    const Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    InkWell(
                      onTap: selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Save
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!validateTransaction()) {
                            return;
                          }
                          final UserId =
                              Supabase.instance.client.auth.currentUser!.id;

                          final transaction = TransactionEntity(
                            id: '',
                            userId: UserId,
                            amount: double.parse(amountController.text.trim()),
                            typeId: selectedTypeId!,
                            categoryId: selectedCategoryId!,
                            description: descriptionController.text.trim(),
                            date: selectedDate,
                          );

                          context.read<TransactionBloc>().add(
                            AddTransaction(transaction),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Transaction',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
}
