import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_form_panel.dart';
import 'package:expense_tracker/feature/transaction/presentation/widgets/transaction_top_background.dart';
import 'package:flutter/widgets.dart';

class InsightsLoading extends StatelessWidget {
  const InsightsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const TransactionTopBackground(height: 245, bottomRadius: 34),
        SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              const SizedBox(height: 26),
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 330,
                decoration: BoxDecoration(
                  color: TransactionWidgetPalette.border,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
