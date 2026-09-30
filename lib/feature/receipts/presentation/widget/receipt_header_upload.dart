import 'package:expense_tracker/feature/receipts/presentation/widget/header_circle.dart';
import 'package:flutter/material.dart';

class ReceiptHeaderUpload extends StatelessWidget {
  final VoidCallback onBack;

  const ReceiptHeaderUpload({super.key, required this.onBack});

  static const Color _primary = Color(0xFF238E84);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 290,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(46),
                bottomRight: Radius.circular(46),
              ),
            ),
          ),

          Positioned(top: -54, left: -48, child: HeaderCircle(size: 150)),

          Positioned(top: 72, right: -38, child: HeaderCircle(size: 145)),

          Positioned(top: 144, left: 118, child: HeaderCircle(size: 88)),

          SafeArea(
            child: Padding(
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
                      'Receipts',
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
          ),

          const Positioned(
            left: 30,
            right: 30,
            bottom: 42,
            child: Column(
              children: [
                Icon(Icons.receipt_long_rounded, color: Colors.white, size: 38),

                SizedBox(height: 10),

                Text(
                  'Keep your receipts organised',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
