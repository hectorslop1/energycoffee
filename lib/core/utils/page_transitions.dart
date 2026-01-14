import 'package:flutter/material.dart';

class PageTransitions {
  // Fade transition
  static Route fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Slide transition from right
  static Route slideFromRight(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Slide transition from bottom
  static Route slideFromBottom(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Scale transition
  static Route scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));
        var scaleAnimation = animation.drive(tween);
        var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0));

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Shared axis transition (Material 3)
  static Route sharedAxisTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        // Forward animation
        var forwardTween =
            Tween(begin: const Offset(0.3, 0.0), end: Offset.zero)
                .chain(CurveTween(curve: curve));
        var forwardFade =
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        // Reverse animation
        var reverseTween =
            Tween(begin: Offset.zero, end: const Offset(-0.3, 0.0))
                .chain(CurveTween(curve: curve));
        var reverseFade =
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: curve));

        return Stack(
          children: [
            SlideTransition(
              position: secondaryAnimation.drive(reverseTween),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(reverseFade),
                child: Container(),
              ),
            ),
            SlideTransition(
              position: animation.drive(forwardTween),
              child: FadeTransition(
                opacity: animation.drive(forwardFade),
                child: child,
              ),
            ),
          ],
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
