import 'package:flutter/material.dart';

class FlipTransition extends AnimatedWidget {
  const FlipTransition({
    super.key,
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateY(animation.value * 3.1415927);

    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: animation.value < 0.5
          ? child
          : Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(3.1415927),
              child: child,
            ),
    );
  }
}
