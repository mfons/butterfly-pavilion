import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class ButterflyView extends StatefulWidget {
  const ButterflyView({Key? key}) : super(key: key);

  @override
  State<ButterflyView> createState() => _ButterflyViewState();
}

class _ButterflyViewState extends State<ButterflyView>
  with TickerProviderStateMixin {

  late Animation<double> animation;
  late AnimationController controller;

  late Animation<double> animation2;
  late AnimationController controller2;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    Tween<double> _rightFrontWingFlapDownTween = Tween(begin: 0.0, end: math.pi/2);

    animation = _rightFrontWingFlapDownTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
            controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    // animation2 = _radiusTween.animate(controller2)
    //   ..addListener(() {
    //     setState(() {});
    //   })
    //   ..addStatusListener((status) {
    //     if (status == AnimationStatus.completed) {
    //       controller2.reverse();
    //     } else if (status == AnimationStatus.dismissed) {
    //       controller2.forward();
    //     }
    //   });

    controller.forward();
//    controller2.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, snapshot) {
        return Transform(
        transform: Matrix4.identity()
          ..rotateX(animation.value),
        origin: const Offset(230, 300),
        child: Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: RightFrontWingPainter(),
          ),
        ));
  },
    );
  }
}

class RightFrontWingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // var centerX = size.width / 2;
    // var centerY = size.height / 2;
    // var center = Offset(centerX, centerY);
    // var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Color(0xff46b3f7);

    //canvas.drawCircle(center, radius, fillBrush);
    Vertices vertices = Vertices(VertexMode.triangleFan, [
      const Offset(100, 150),
      const Offset(200, 40),
      const Offset(250, 200),
      const Offset(230, 300)
    ]);
    canvas.drawVertices(vertices, BlendMode.color, fillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
