import 'dart:math';
import 'dart:ui';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';

import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingOverlay<T extends BaseNotifier> extends ConsumerWidget {
  final Widget child;
  final ProviderListenable<dynamic> provider;
  const LoadingOverlay({super.key, required this.child, required this.provider,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(provider);
    final isLoading = notifier.loadingState == LoadingState.busy;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black12,
                child: Center(
                  child: _LoadingBox(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LoadingBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 80,
                width: 80,
                child: DotCircleSpinner(),
              ),
              const SizedBox(height: 18),
              Text(
                '${context.locale.welcome}...',
                style: AppFonts.text18.bold.white.style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DotCircleSpinner extends StatefulWidget {
  final double size;
  final double dotSize;
  final Color color;

  const DotCircleSpinner({
    super.key,
    this.size = 60,
    this.dotSize = 5,
    this.color = AppColors.white,
  });

  @override
  State<DotCircleSpinner> createState() => _DotCircleSpinnerState();
}

class _DotCircleSpinnerState extends State<DotCircleSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => CustomPaint(
          painter: _DotSpinnerPainter(
            animationValue: _controller.value,
            dotColor: widget.color,
            dotSize: widget.dotSize,
          ),
        ),
      ),
    );
  }
}

class _DotSpinnerPainter extends CustomPainter {
  final double animationValue;
  final double dotSize;
  final Color dotColor;
  static const int _dotCount = 12;

  _DotSpinnerPainter({
    required this.animationValue,
    required this.dotColor,
    required this.dotSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 * 0.7;

    for (int i = 0; i < _dotCount; i++) {
      final double angle = 2 * pi * i / _dotCount;
      final double dx = center.dx + radius * cos(angle);
      final double dy = center.dy + radius * sin(angle);

      final double progress = (animationValue + i / _dotCount) % 1.0;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);

      canvas.drawCircle(
        Offset(dx, dy),
        dotSize,
        Paint()..color = dotColor.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DotSpinnerPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
