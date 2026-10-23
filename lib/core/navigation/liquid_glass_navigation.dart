import 'dart:ui';

import 'package:flutter/material.dart';

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

  static const double _barHeight = 78;
  static const double _bubbleSize = 94;

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
    return SafeArea(
      top: false,
      child: Padding(
        // Extra top space lets the oversized bubble rise above the bar.
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final itemWidth = width / _icons.length;

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
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xC8FFFFFF),
                                    Color(0xA5DCE5FF),
                                    Color(0xA6B7C8F8),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  width: 1.3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF8DA8FF,
                                    ).withValues(alpha: 0.25),
                                    blurRadius: 28,
                                  ),
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Oversized glass bubble follows the selected tab.
                      AnimatedPositioned(
                        duration: Duration(milliseconds: _isDragging ? 0 : 260),
                        curve: Curves.easeOutCubic,
                        left:
                            _indicatorPosition * itemWidth +
                            (itemWidth - _bubbleSize) / 2,
                        top: (_barHeight - _bubbleSize) / 2,
                        width: _bubbleSize,
                        height: _bubbleSize,
                        child: IgnorePointer(
                          child: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    center: const Alignment(-0.35, -0.5),
                                    radius: 1.2,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.65),
                                      const Color(
                                        0xFF92B9FF,
                                      ).withValues(alpha: 0.42),
                                      const Color(
                                        0xFF9D85FF,
                                      ).withValues(alpha: 0.30),
                                      Colors.white.withValues(alpha: 0.12),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    width: 1.6,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF7CA6FF,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: const Color(
                                        0xFFFF9ED8,
                                      ).withValues(alpha: 0.25),
                                      blurRadius: 18,
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

                          final scale = 1.0 + dragZoom * 0.42 + hover * 0.12;

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
                                          size: index == 2 ? 29 : 23,
                                          color: index == 2
                                              ? Colors.white
                                              : isSelected
                                              ? const Color(0xFF26385F)
                                              : const Color(0xFF596581),
                                        ),
                                        const SizedBox(height: 4),
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
                                            color: const Color(0xFF303C5C),
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
