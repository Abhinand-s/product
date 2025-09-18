// A custom route with fade transition animation
import 'package:flutter/material.dart';

// A custom route with slide-up transition animation
class FadePageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  FadePageRoute({required this.builder})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

// A custom route with slide-up transition animation
class SlideUpPageRoute extends PageRouteBuilder {
  final WidgetBuilder builder;

  SlideUpPageRoute({required this.builder})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animate from bottom (Offset(0.0, 1.0)) to top (Offset.zero)
            final tween =
                Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          },
        );
}
