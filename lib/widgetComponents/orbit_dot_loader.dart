import 'dart:math';
import 'package:flutter/material.dart';

class OrbitDotLoader extends StatefulWidget {
  final double size;
  final Color color;

  const OrbitDotLoader({
    super.key,
    this.size = 60,
    this.color = const Color(0xFF4FC3F7), // similar blue
  });

  @override
  State<OrbitDotLoader> createState() => _OrbitDotLoaderState();
}

class _OrbitDotLoaderState extends State<OrbitDotLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int dotCount = 6;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 4;

    return SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 13),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi, // full rotation
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(dotCount, (index) {
                  final angle = (2 * pi / dotCount) * index;

                  // depth effect (front dots bigger)
                  final wave = sin(angle + (_controller.value * 2 * pi));
                  final scale = 0.6 + (wave + 1) / 2 * 0.6;
                  final opacity = 0.4 + (wave + 1) / 2 * 0.6;

                  return Transform.translate(
                    offset: Offset(radius * cos(angle), radius * sin(angle)),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
