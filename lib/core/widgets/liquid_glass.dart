import 'dart:ui';
import 'package:expense_tracker/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens and helpers for the Liquid Glass aesthetic.
class LiquidGlassTheme {
  // Brand accents
  static const Color primary = Color(0xFF1B7A70);
  static const Color primaryLight = Color(0xFF2FB5A6);
  static const Color primaryDark = Color(0xFF0F4E47);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentViolet = Color(0xFF8B5CF6);
  static const Color accentRose = Color(0xFFF43F5E);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentAmber = Color(0xFFF59E0B);

  // Background canvas
  static const Color background = Color(0xFFF1F5F9);
  static const Color backgroundDark = Color(0xFF0F172A);

  // Glass tints (Light Mode)
  static const Color glassSurface = Color(0xCCFFFFFF); // 80% opacity
  static const Color glassSurfaceDense = Color(0xE6FFFFFF); // 90% opacity
  static const Color glassSurfaceTranslucent = Color(0x80FFFFFF); // 50% opacity
  static const Color glassBorder = Color(0xB3FFFFFF); // 70% opacity white
  static const Color glassBorderSubtle = Color(0x66FFFFFF); // 40% opacity white

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);

  // Liquid gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0D5E56),
      Color(0xFF178074),
      Color(0xFF27A99B),
      Color(0xFF4FD1C5),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xE6FFFFFF),
      Color(0xB8F1F5F9),
      Color(0xCCFFFFFF),
    ],
  );

  static const LinearGradient glassHighlight = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x80FFFFFF),
      Color(0x1AFFFFFF),
    ],
  );

  static const LinearGradient liquidAccent = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF06B6D4),
    ],
  );

  /// Standard Light Mode Liquid Glass theme
  static ThemeData get lightTheme {
    final baseTextTheme = ThemeData.light().textTheme;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF0FDF4),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F766E),
        primary: const Color(0xFF0F766E),
        surface: const Color(0xFFFFFFFF),
        brightness: Brightness.light,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }

  /// Modern VisionOS-style Dark Obsidian Liquid Glass theme
  static ThemeData get darkTheme {
    final baseTextTheme = ThemeData.dark().textTheme;
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0B1320),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF14B8A6),
        primary: const Color(0xFF14B8A6),
        surface: const Color(0xFF1E293B),
        brightness: Brightness.dark,
      ),
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}

/// A frosted glass card with real backdrop blur, specular border, and ambient shadow.
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Gradient? gradient;
  final Color? color;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Clip clipBehavior;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 20.0,
    this.gradient,
    this.color,
    this.border,
    this.boxShadow,
    this.onTap,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(26);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultGlassColor = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.65)
        : LiquidGlassTheme.glassSurface;

    final defaultGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xCC1E293B),
              Color(0x990F172A),
              Color(0xB31E293B),
            ],
          )
        : LiquidGlassTheme.cardGradient;

    final defaultBorder = isDark
        ? Border.all(
            color: Colors.white.withValues(alpha: 0.14),
            width: 1.2,
          )
        : Border.all(
            color: LiquidGlassTheme.glassBorder,
            width: 1.3,
          );

    final defaultShadow = isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ]
        : [
            BoxShadow(
              color: const Color(0xFF64748B).withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.6),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ];

    Widget content = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? (gradient == null ? defaultGlassColor : null),
        gradient: color == null ? (gradient ?? defaultGradient) : null,
        borderRadius: effectiveRadius,
        border: border ?? defaultBorder,
        boxShadow: boxShadow ?? defaultShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: effectiveRadius,
          onTap: () {
            HapticFeedback.selectionClick();
            onTap!();
          },
          child: content,
        ),
      );
    }

    final glass = ClipRRect(
      borderRadius: effectiveRadius,
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      ),
    );

    if (margin != null) {
      return Padding(padding: margin!, child: glass);
    }
    return glass;
  }
}

/// A liquid fluid canvas that renders soft glowing chromatic orbs in the background.
class LiquidGlassBackground extends StatelessWidget {
  final Widget child;
  final bool showAura;

  const LiquidGlassBackground({
    super.key,
    required this.child,
    this.showAura = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base canvas
        Container(
          width: double.infinity,
          height: double.infinity,
          color: isDark ? const Color(0xFF0B1320) : LiquidGlassTheme.background,
        ),

        // Glowing organic aura orbs in background
        if (showAura) ...[
          // Top right cyan/teal aura
          Positioned(
            top: -60,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF2DD4BF).withValues(alpha: 0.28),
                      const Color(0xFF0EA5E9).withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Mid left indigo/violet aura
          Positioned(
            top: size.height * 0.25,
            left: -80,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.75,
                height: size.width * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF818CF8).withValues(alpha: 0.20),
                      const Color(0xFFC084FC).withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom right subtle warm glow
          Positioned(
            bottom: -50,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: size.width * 0.65,
                height: size.width * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF38BDF8).withValues(alpha: 0.18),
                      const Color(0xFF34D399).withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],

        // Main content
        child,
      ],
    );
  }
}

/// A liquid glass top banner background with smooth fluid shapes and glowing rings.
class LiquidGlassTopAura extends StatelessWidget {
  final double height;
  final double bottomRadius;
  final Widget? child;

  const LiquidGlassTopAura({
    super.key,
    this.height = 250,
    this.bottomRadius = 38,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F4E47),
            Color(0xFF146C62),
            Color(0xFF1D8E81),
            Color(0xFF28A89A),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomRadius),
          bottomRight: Radius.circular(bottomRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF146C62).withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Specular highlight line at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 1.5,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.0),
                    Colors.white.withValues(alpha: 0.6),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Luminous liquid glow circles
          Positioned(
            top: -40,
            left: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.20),
                    Colors.white.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF5EEAD4).withValues(alpha: 0.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 60,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
            ),
          ),

          ?child,
        ],
      ),
    );
  }
}

/// A tactile button with liquid gradient, specular sheen, and smooth haptic feedback.
class LiquidGlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? label;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const LiquidGlassButton({
    super.key,
    required this.onPressed,
    this.child,
    this.label,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.gradient,
    this.height = 54,
    this.width,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(20);

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor ?? LiquidGlassTheme.primaryLight,
                  backgroundColor ?? LiquidGlassTheme.primary,
                ],
              ),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? LiquidGlassTheme.primary).withValues(alpha: 0.38),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.30),
              blurRadius: 2,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: effectiveRadius,
            onTap: isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    onPressed?.call();
                  },
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.4,
                        ),
                      )
                    : child ??
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                            ],
                            if (label != null)
                              Text(
                                label!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                          ],
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A liquid glass chip/badge for categories, filters, or indicators.
class LiquidGlassBadge extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const LiquidGlassBadge({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? LiquidGlassTheme.primary;

    Widget badge = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.28),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      badge = GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap!();
        },
        child: badge,
      );
    }

    return badge;
  }
}

/// A sleek, tactile moon/sun icon button with rotation animation and frosted glass capsule styling.
class LiquidThemeToggle extends StatelessWidget {
  final double size;

  const LiquidThemeToggle({super.key, this.size = 42});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.85),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.22)
                  : Colors.white.withValues(alpha: 0.95),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.4)
                    : const Color(0xFF0F766E).withValues(alpha: 0.15),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                HapticFeedback.lightImpact();
                context.read<ThemeCubit>().toggleTheme();
              },
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    key: ValueKey(isDark),
                    size: size * 0.52,
                    color: isDark
                        ? const Color(0xFFFBBF24)
                        : const Color(0xFF0F766E),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
