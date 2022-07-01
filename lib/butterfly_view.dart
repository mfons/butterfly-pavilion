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

  late Animation<double> animationDownWing;
  late AnimationController controllerWing;

  late Animation<double> animationUpWing;
  late Animation<double> _flapDownCurve;
  late Animation<double> _flapUpCurve;
  //late Animation<double> _wingFlapAnimation;
  static final Tween<double> _rightFrontWingFlapDownTween = Tween(begin: 0.0, end: 3*math.pi/4);
  static final Tween<double> _rightFrontWingFlapUpTween = Tween(begin:3*math.pi/4, end: 0);

  @override
  void initState() {
    super.initState();

    controllerWing = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    // _flapDownCurve = CurvedAnimation(parent: controllerWing, curve: Curves.easeOutCirc);
    // _flapUpCurve = CurvedAnimation(parent: controllerWing, curve: Curves.easeOutCirc);
    _flapDownCurve = CurvedAnimation(parent: controllerWing, curve: const Interval(0.0, 0.5));
    _flapUpCurve = CurvedAnimation(parent: controllerWing, curve: const Interval(0.5, 1.0));

    animationDownWing = _rightFrontWingFlapDownTween.animate(_flapDownCurve);
    animationUpWing = _rightFrontWingFlapUpTween.animate(_flapUpCurve);
    // ..addListener(() {
    //   setState(() {});
    // })
    // ..addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //       controllerWing.reverse();
    //   } else if (status == AnimationStatus.dismissed) {
    //       controllerWing.forward();
    //   }
    // });

    controllerWing.repeat();
 }

  @override
  void dispose() {
    controllerWing.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controllerWing,
      builder: (context, snapshot) {
        return Transform(
        transform: Matrix4.identity()
          ..rotateX(animationDownWing.value - animationUpWing.value)
            ..rotateZ(math.pi/15),
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
    var fillBrush = Paint()..color = Color(0xff46b3f7);

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
