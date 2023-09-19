import 'package:flutter/material.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget childWidget;

  const FadeAnimation(this.delay, this.childWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return PlayAnimationBuilder(
      tween: Tween(end: 200, begin: 50),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return childWidget;
      },
    );
  }
}
