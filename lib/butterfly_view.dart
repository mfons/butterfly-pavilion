import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:simple_animations/simple_animations.dart';

class ButterflyView extends StatefulWidget {
  const ButterflyView({Key? key}) : super(key: key);

  @override
  State<ButterflyView> createState() => _ButterflyViewState();
}

enum _AniProps { xtransform, canvasYTransform}

class _ButterflyViewState extends State<ButterflyView>
  with TickerProviderStateMixin {

  static final theDuration = 2000;
  static double painterCanvasYTransformAngle = 0;
  late AnimationController controllerWing;

 static final Tween<double> _rightFrontWingFlapDownTween = Tween(begin: 0.0, end: 3*math.pi/4);
  static final Tween<double> _rightFrontWingFlapUpTween = Tween(begin:3*math.pi/4, end: 0);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownTween = Tween(begin: math.pi/4, end: math.pi/4);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownUpTween = Tween(begin: math.pi/4, end: -math.pi/4);
  static final Tween<double> _rightFrontWingFlapCanvasRotationUpTween = Tween(begin: -math.pi/4, end: -math.pi/4);
  static final MultiTween<_AniProps> _flapTween = MultiTween<_AniProps>()
    ..add(_AniProps.xtransform, _rightFrontWingFlapDownTween, Duration(milliseconds: theDuration~/2))
    ..add(_AniProps.xtransform, _rightFrontWingFlapUpTween, Duration(milliseconds: theDuration~/2))
    ..add(_AniProps.canvasYTransform, _rightFrontWingFlapCanvasRotationDownTween, Duration(milliseconds: theDuration~/2 - 100))
    ..add(_AniProps.canvasYTransform, _rightFrontWingFlapCanvasRotationDownUpTween, Duration(milliseconds: 200))
    ..add(_AniProps.canvasYTransform, _rightFrontWingFlapCanvasRotationUpTween, Duration(milliseconds: theDuration~/2 - 100));
  @override
  void initState() {
    super.initState();

    controllerWing = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: theDuration),
    );
  }

  @override
  void dispose() {
    controllerWing.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return LoopAnimation<MultiTweenValues<_AniProps>>(
      tween: _flapTween,
      duration:_flapTween.duration,
      builder: (context, child, value) {
        painterCanvasYTransformAngle = value.get(_AniProps.canvasYTransform);
        return Transform(
        transform: Matrix4.identity()
          ..rotateX(value.get(_AniProps.xtransform)),
           origin: const Offset(230, 300),
        child: Container(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: RightFrontWingPainter(),
          ),
        ));
  }
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

    drawRotated(
        canvas,
        const Offset(230, 300),
     /*math.pi/4*/   _ButterflyViewState.painterCanvasYTransformAngle,
            () => canvas.drawVertices(vertices, BlendMode.color, fillBrush)
    );
  }

  /**
   * Here's helpful references for what I am doing here and why and how and stuff...
   * https://stackoverflow.com/questions/64230683/flutter-transform-path-in-custompaint-with-float64list-matrix4/64230684#64230684

      https://www.flutterclutter.dev/flutter/tutorials/2022-04-17-rotate-custom-paint-canvas-flutter/
   */

  void drawRotated(
      Canvas canvas,
      Offset origin,
      double angle,
      VoidCallback drawFunction
      ) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.transform(rotateY(angle));
    canvas.translate(-origin.dx, -origin.dy);
    drawFunction();
    canvas.restore();
  }

  Float64List rotateY(double radians) {
    return Float64List.fromList([
      math.cos(radians), 0, -math.sin(radians), 0,
      0, 1, 0, 0,
      math.sin(radians), 0, math.cos(radians), 0,
      0, 0, 0, 1
    ]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
