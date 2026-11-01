import 'package:expense_tracker/core/widgets/liquid_glass.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_palette.dart';
import 'package:expense_tracker/feature/dashboard/presentation/widgets/dashboard_top_background.dart';
import 'package:flutter/material.dart';

class DashboardErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DashboardErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        const DashboardTopBackground(),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: LiquidGlassCard(
              blur: 24,
              borderRadius: BorderRadius.circular(32),
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            DashboardPalettes.expense.withValues(alpha: 0.16),
                            const Color(0xFFFB7185).withValues(alpha: 0.08),
                          ],
                        ),
                        border: Border.all(
                          color: DashboardPalettes.expense.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: DashboardPalettes.expense.withValues(alpha: 0.14),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 34,
                        color: DashboardPalettes.expense,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Something went wrong',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark ? Colors.white : DashboardPalettes.ink,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: DashboardPalettes.muted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    LiquidGlassButton(
                      onPressed: onRetry,
                      height: 50,
                      width: double.infinity,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F766E),
                          Color(0xFF0D9488),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh_rounded, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Try Again',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 15,
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
    );
  }
}
