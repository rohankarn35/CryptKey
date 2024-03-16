import 'package:flutter/material.dart';

class AnimatedRouteBuilder {
  Widget anotherPage;
  AnimatedRouteBuilder({required this.anotherPage});
  Route<PageRouteBuilder> animatedRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => anotherPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOutExpo;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        var slideAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
