import 'package:expense_tracker/feature/receipts/presentation/widget/header_circle.dart';
import 'package:flutter/material.dart';

class ReceiptListHeader extends StatelessWidget {
  final VoidCallback onBack;
  final Widget searchField;

  const ReceiptListHeader({
    super.key,
    required this.onBack,
    required this.searchField,
  });

  static const Color primary = Color(0xFF238E84);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 340,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(46),
                bottomRight: Radius.circular(46),
              ),
            ),
          ),

          Positioned(top: -55, left: -50, child: HeaderCircle(size: 150)),

          Positioned(top: 72, right: -36, child: HeaderCircle(size: 145)),

          Positioned(top: 145, left: 120, child: HeaderCircle(size: 86)),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onBack,
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 29,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          'My Receipts',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: searchField,
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
