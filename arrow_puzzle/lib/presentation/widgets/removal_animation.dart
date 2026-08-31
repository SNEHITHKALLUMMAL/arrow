import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/models/models.dart';
import '../../core/constants/app_colors.dart';

/// Animates the removal of an arrow from the board.
/// The arrow slides in its facing direction and fades out.
class RemovalAnimation extends StatefulWidget {
  final Arrow arrow;
  final double cellSize;
  final double boardWidth;
  final double boardHeight;
  final bool isFailed;
  final VoidCallback onComplete;

  const RemovalAnimation({
    super.key,
    required this.arrow,
    required this.cellSize,
    required this.boardWidth,
    required this.boardHeight,
    this.isFailed = false,
    required this.onComplete,
  });

  @override
  State<RemovalAnimation> createState() => _RemovalAnimationState();
}

class _RemovalAnimationState extends State<RemovalAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.isFailed ? 300 : 450),
      vsync: this,
    );

    final direction = widget.arrow.direction.delta;
    final slideDistance = widget.isFailed
        ? Offset(direction.$2 * 15.0, direction.$1 * 15.0)
        : Offset(
            direction.$2 * (widget.boardWidth + widget.cellSize),
            direction.$1 * (widget.boardHeight + widget.cellSize),
          );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.isFailed ? slideDistance * 0.15 : slideDistance,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.isFailed ? Curves.easeInOut : Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: widget.isFailed ? 0.5 : 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.isFailed
          ? const Interval(0.0, 0.5)
          : const Interval(0.4, 1.0),
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.arrowColor(widget.arrow.direction.index);
    final startX = widget.arrow.col * widget.cellSize;
    final startY = widget.arrow.row * widget.cellSize;
    final iconSize = widget.cellSize * 0.55;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final offset = _slideAnimation.value;
        final opacity = _fadeAnimation.value;
        final shake =
            widget.isFailed ? sin(_controller.value * pi * 4) * 4.0 : 0.0;

        return Positioned(
          left: startX + offset.dx + shake,
          top: startY + offset.dy,
          width: widget.cellSize,
          height: widget.cellSize,
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: EdgeInsets.all(widget.cellSize * 0.08),
              decoration: BoxDecoration(
                color: widget.isFailed
                    ? AppColors.error.withValues(alpha: 0.3)
                    : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(widget.cellSize * 0.18),
                border: Border.all(
                  color: widget.isFailed ? AppColors.error : color,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (widget.isFailed ? AppColors.error : color)
                        .withValues(alpha: 0.3),
                    blurRadius: widget.isFailed ? 8 : 6,
                  ),
                ],
              ),
              child: Center(
                child: Transform.rotate(
                  angle: widget.arrow.direction.angle,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: iconSize,
                    color: widget.isFailed ? AppColors.error : color,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
