import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LiquidGlassBottomNavigation extends StatefulWidget {
  const LiquidGlassBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  @override
  State<LiquidGlassBottomNavigation> createState() =>
      _LiquidGlassBottomNavigationState();
}

class _LiquidGlassBottomNavigationState
    extends State<LiquidGlassBottomNavigation> {
  double? _pointerX;
  double _indicatorPosition = 0;
  bool _isDragging = false;

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.add_rounded,
    Icons.receipt_long_rounded,
    Icons.person_rounded,
  ];

  static const List<String> _labels = [
    'Home',
    'Insights',
    'Add',
    'Receipts',
    'Profile',
  ];

  // Visual tab order -> existing MainNavigationPage index.
  static const List<int> _pageIndices = [0, 2, 1, 3, 4];

  static const double _barHeight = 70;
  static const double _indicatorHeight = 54;

  int get _selectedVisualIndex {
    final index = _pageIndices.indexOf(widget.currentIndex);
    return index >= 0 ? index : 0;
  }

  @override
  void initState() {
    super.initState();
    _indicatorPosition = _selectedVisualIndex.toDouble();
  }

  @override
  void didUpdateWidget(covariant LiquidGlassBottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex && !_isDragging) {
      _indicatorPosition = _selectedVisualIndex.toDouble();
    }
  }

  void _selectItem(int index) {
    if (index < 0 || index >= _icons.length) return;

    HapticFeedback.selectionClick();

    setState(() {
      _indicatorPosition = index.toDouble();
      _pointerX = null;
      _isDragging = false;
    });

    if (widget.currentIndex != _pageIndices[index]) {
      widget.onChanged(_pageIndices[index]);
    }
  }

  void _updateFromPosition(double x, double itemWidth) {
    if (itemWidth <= 0) return;

    final position = (x / itemWidth).clamp(0.0, _icons.length - 1.0).toDouble();

    setState(() {
      _indicatorPosition = position;
      _isDragging = true;
    });
  }

  void _finishDrag() {
    final nearestIndex = _indicatorPosition
        .round()
        .clamp(0, _icons.length - 1)
        .toInt();

    setState(() {
      _indicatorPosition = nearestIndex.toDouble();
      _isDragging = false;
      _pointerX = null;
    });

    if (widget.currentIndex != _pageIndices[nearestIndex]) {
      widget.onChanged(_pageIndices[nearestIndex]);
    }
  }

  void _cancelDrag() {
    setState(() {
      _isDragging = false;
      _pointerX = null;
      _indicatorPosition = _selectedVisualIndex.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = width / _icons.length;
            final indicatorWidth = (itemWidth - 8).clamp(56.0, 78.0);

            return MouseRegion(
              onHover: (event) {
                if (!_isDragging) {
                  setState(() {
                    _pointerX = event.localPosition.dx;
                  });
                }
              },
              onExit: (_) {
                if (!_isDragging) {
                  setState(() => _pointerX = null);
                }
              },
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: (details) {
                  _updateFromPosition(details.localPosition.dx, itemWidth);
                },
                onHorizontalDragUpdate: (details) {
                  _updateFromPosition(details.localPosition.dx, itemWidth);
                },
                onHorizontalDragEnd: (_) => _finishDrag(),
                onHorizontalDragCancel: _cancelDrag,
                child: SizedBox(
                  height: _barHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Main translucent glass panel.
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: isDark
                                      ? [
                                          const Color(0xF21E293B),
                                          const Color(0xD90F172A),
                                          const Color(0xCC0B1320),
                                        ]
                                      : const [
                                          Color(0xF2FFFFFF),
                                          Color(0xD9E2E8F0),
                                          Color(0xCCE2E8F0),
                                        ],
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.16)
                                      : Colors.white.withValues(alpha: 0.9),
                                  width: 1.4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1B7A70).withValues(alpha: 0.16),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Round glass capsule follows the selected tab, enclosing both icon and label.
                      AnimatedPositioned(
                        duration: Duration(milliseconds: _isDragging ? 0 : 240),
                        curve: Curves.easeOutCubic,
                        left:
                            _indicatorPosition * itemWidth +
                            (itemWidth - indicatorWidth) / 2,
                        top: (_barHeight - _indicatorHeight) / 2,
                        width: indicatorWidth,
                        height: _indicatorHeight,
                        child: IgnorePointer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.20, -0.4),
                                    radius: 1.25,
                                    colors: isDark
                                        ? [
                                            const Color(0xFF2DD4BF).withValues(alpha: 0.38),
                                            const Color(0xFF0F766E).withValues(alpha: 0.22),
                                            const Color(0xFF1E293B).withValues(alpha: 0.12),
                                            Colors.white.withValues(alpha: 0.04),
                                          ]
                                        : [
                                            Colors.white.withValues(alpha: 0.90),
                                            const Color(0xFF5EEAD4).withValues(alpha: 0.50),
                                            const Color(0xFF1B7A70).withValues(alpha: 0.20),
                                            Colors.white.withValues(alpha: 0.12),
                                          ],
                                  ),
                                  border: Border.all(
                                    color: isDark
                                        ? const Color(0xFF2DD4BF).withValues(alpha: 0.50)
                                        : Colors.white.withValues(alpha: 0.95),
                                    width: 1.4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2DD4BF).withValues(
                                        alpha: isDark ? 0.38 : 0.28,
                                      ),
                                      blurRadius: 16,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Interactive navigation items.
                      Row(
                        children: List.generate(_icons.length, (index) {
                          final distance = (_indicatorPosition - index).abs();

                          final pointerDistance = _pointerX == null
                              ? double.infinity
                              : (_pointerX! - (index + 0.5) * itemWidth).abs();

                          final hover = _pointerX == null
                              ? 0.0
                              : (1 - pointerDistance / (itemWidth * 1.5))
                                    .clamp(0.0, 1.0)
                                    .toDouble();

                          final dragZoom = (1 - distance / 1.35)
                              .clamp(0.0, 1.0)
                              .toDouble();

                          final scale = 1.0 + dragZoom * 0.10 + hover * 0.05;

                          final isSelected =
                              widget.currentIndex == _pageIndices[index];

                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => _selectItem(index),
                              child: Center(
                                child: AnimatedScale(
                                  scale: scale,
                                  duration: Duration(
                                    milliseconds: _isDragging ? 0 : 180,
                                  ),
                                  curve: Curves.easeOutCubic,
                                  child: SizedBox(
                                    height: _barHeight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _icons[index],
                                          size: 20,
                                          color: isSelected
                                              ? (isDark
                                                  ? const Color(0xFF2DD4BF)
                                                  : const Color(0xFF0F4E47))
                                              : (isDark
                                                  ? const Color(0xFF94A3B8)
                                                  : const Color(0xFF64748B)),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _labels[index],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 10,
                                            height: 1.1,
                                            fontWeight: isSelected
                                                ? FontWeight.w800
                                                : FontWeight.w600,
                                            color: isSelected
                                                ? (isDark
                                                    ? const Color(0xFF2DD4BF)
                                                    : const Color(0xFF0F4E47))
                                                : (isDark
                                                    ? const Color(0xFF94A3B8)
                                                    : const Color(0xFF64748B)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
