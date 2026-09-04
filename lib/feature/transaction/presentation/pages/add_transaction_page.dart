// ignore_for_file: unused_field, unused_label, use_build_context_synchronously, non_constant_identifier_names

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

class _AddTransactionPalette {
  static const bg = Color(0xFFF3F6F4);
  static const teal = Color(0xFF2B8F84);
  static const tealDark = Color(0xFF19766E);
  static const ink = Color(0xFF07091D);
  static const muted = Color(0xFF89918F);
  static const border = Color(0xFFE8EEEB);
  static const income = Color(0xFF22B573);
  static const expense = Color(0xFFE8524A);
  static const softMint = Color(0xFFEAF8F5);
  static const softRed = Color(0xFFFFEEEE);
}

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _AddTransactionPalette.teal,
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

    final horizontalPadding = isMobile ? 18.0 : 28.0;

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
        backgroundColor: _AddTransactionPalette.bg,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                const _AddTransactionHeaderBackground(),
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
                            _PageHeader(isMobile: isMobile),
                            SizedBox(height: isMobile ? 26 : 32),
                            _FormPanel(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const _HeroIntro(),
                                  const SizedBox(height: 26),
                                  const _SectionLabel('Transaction Type'),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _TypeButton(
                                          label: 'Income',
                                          icon: Icons.arrow_downward_rounded,
                                          color: _AddTransactionPalette.income,
                                          selected:
                                              selectedTypeId == income?.id,
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
                                        child: _TypeButton(
                                          label: 'Expense',
                                          icon: Icons.arrow_upward_rounded,
                                          color: _AddTransactionPalette.expense,
                                          selected:
                                              selectedTypeId == expense?.id,
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
                                  const SizedBox(height: 24),
                                  if (!isMobile)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  const _SectionLabel('Description'),
                                  const SizedBox(height: 10),
                                  TextField(
                                    controller: descriptionController,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: _AddTransactionPalette.ink,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: _inputDecoration(
                                      hintText:
                                          'What was this transaction for?',
                                      icon: Icons.notes_rounded,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const _SectionLabel('Date'),
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: selectDate,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _AddTransactionPalette.border,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          _FieldIcon(
                                            icon: Icons.calendar_today_rounded,
                                            color: _AddTransactionPalette.teal,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            '${selectedDate.day}/'
                                            '${selectedDate.month}/'
                                            '${selectedDate.year}',
                                            style: const TextStyle(
                                              color: _AddTransactionPalette.ink,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: _AddTransactionPalette.muted,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: saveTransaction,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _AddTransactionPalette.teal,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Save Transaction',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
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

  Widget _buildAmountField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Amount'),
        const SizedBox(height: 10),
        TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            color: _AddTransactionPalette.ink,
            fontWeight: FontWeight.w800,
          ),
          decoration: _inputDecoration(
            hintText: 'Enter amount',
            prefixText: '${AppConstants.currencySymbol} ',
            icon: Icons.payments_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Category'),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: selectedCategoryId,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: _AddTransactionPalette.muted,
          ),
          decoration: _inputDecoration(
            hintText: 'Select category',
            icon: Icons.category_rounded,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(20),
          items: categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(
                category.name,
                style: const TextStyle(
                  color: _AddTransactionPalette.ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    String? prefixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixText: prefixText,
      prefixStyle: const TextStyle(
        color: _AddTransactionPalette.ink,
        fontWeight: FontWeight.w900,
      ),
      hintStyle: TextStyle(
        color: _AddTransactionPalette.muted.withValues(alpha: 0.78),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 12, right: 10),
        child: _FieldIcon(icon: icon, color: _AddTransactionPalette.teal),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _AddTransactionPalette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: _AddTransactionPalette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: _AddTransactionPalette.teal,
          width: 1.4,
        ),
      ),
    );
  }
}

class _AddTransactionHeaderBackground extends StatelessWidget {
  const _AddTransactionHeaderBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _AddTransactionPalette.teal,
            _AddTransactionPalette.tealDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -46, left: -36, child: _HeaderRing(size: 132)),
          Positioned(top: 38, right: -34, child: _HeaderRing(size: 126)),
          Positioned(top: 82, left: 82, child: _HeaderRing(size: 64)),
        ],
      ),
    );
  }
}

class _HeaderRing extends StatelessWidget {
  final double size;

  const _HeaderRing({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final bool isMobile;

  const _PageHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white.withValues(alpha: 0.14),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => Navigator.maybePop(context),
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 10,
              height: 42,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Add Transaction',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 18 : 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormPanel extends StatelessWidget {
  final Widget child;

  const _FormPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        boxShadow: [
          BoxShadow(
            color: _AddTransactionPalette.ink.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HeroIntro extends StatelessWidget {
  const _HeroIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _AddTransactionPalette.softMint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: _AddTransactionPalette.teal,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add your transaction',
                  style: TextStyle(
                    color: _AddTransactionPalette.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track your income and expenses',
                  style: TextStyle(
                    color: _AddTransactionPalette.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: _AddTransactionPalette.ink,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = selected ? color : Colors.white;
    final fgColor = selected ? Colors.white : _AddTransactionPalette.ink;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected ? color : _AddTransactionPalette.border,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.24),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: fgColor),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: fgColor, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _FieldIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
