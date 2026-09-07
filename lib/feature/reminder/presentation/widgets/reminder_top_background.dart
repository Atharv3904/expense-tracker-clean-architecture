import 'package:expense_tracker/feature/authentication/presentation/widgets/login_widget.dart/header_ring.dart';
import 'package:expense_tracker/feature/reminder/presentation/widgets/reminder_palette.dart';
import 'package:flutter/widgets.dart';

class ReminderTopBackground extends StatelessWidget {
  const ReminderTopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ReminderPalette.teal, ReminderPalette.tealDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(38),
          bottomRight: Radius.circular(38),
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -42, left: -34, child: HeaderRing(size: 132)),
          Positioned(top: 42, right: -38, child: HeaderRing(size: 126)),
          Positioned(top: 86, left: 90, child: HeaderRing(size: 64)),
        ],
      ),
    );
  }
}
