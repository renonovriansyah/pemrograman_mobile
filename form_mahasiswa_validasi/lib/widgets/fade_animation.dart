import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    // Menggunakan TweenAnimationBuilder untuk animasi simpel tanpa Controller
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            // Efek slide dari bawah ke atas (50 pixel)
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      // Menambahkan delay visual menggunakan key
      key: ValueKey(delay),
      child: child,
    );
  }
}