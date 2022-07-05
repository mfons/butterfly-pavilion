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

enum _AniProps { xtransform, canvasYTransform }

class _ButterflyViewState extends State<ButterflyView>
    with TickerProviderStateMixin {
  static final theDuration = 2000;
  static final origin = Offset(230, 300);
  static double painterCanvasYTransformAngle = 0;
  late AnimationController controllerWing;

  static final Tween<double> _rightFrontWingFlapDownTween =
      Tween(begin: 0.0, end: 3 * math.pi / 4);
  static final Tween<double> _rightFrontWingFlapUpTween =
      Tween(begin: 3 * math.pi / 4, end: 0);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownTween =
      Tween(begin: math.pi / 4, end: math.pi / 4);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownUpTween =
      Tween(begin: math.pi / 4, end: -math.pi / 4);
  static final Tween<double> _rightFrontWingFlapCanvasRotationUpTween =
      Tween(begin: -math.pi / 4, end: -math.pi / 4);
  static final MultiTween<_AniProps> _flapTween = MultiTween<_AniProps>()
    ..add(_AniProps.xtransform, _rightFrontWingFlapDownTween,
        Duration(milliseconds: theDuration ~/ 2))
    ..add(_AniProps.xtransform, _rightFrontWingFlapUpTween,
        Duration(milliseconds: theDuration ~/ 2))
    ..add(
        _AniProps.canvasYTransform,
        _rightFrontWingFlapCanvasRotationDownTween,
        Duration(milliseconds: theDuration ~/ 2 - 100))
    ..add(
        _AniProps.canvasYTransform,
        _rightFrontWingFlapCanvasRotationDownUpTween,
        Duration(milliseconds: 200))
    ..add(_AniProps.canvasYTransform, _rightFrontWingFlapCanvasRotationUpTween,
        Duration(milliseconds: theDuration ~/ 2 - 100));
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
        duration: _flapTween.duration,
        builder: (context, child, value) {
          painterCanvasYTransformAngle = value.get(_AniProps.canvasYTransform);
          return Stack(
            children: <Widget>[
              Transform(
                  transform: Matrix4.identity()
                    ..rotateX(-value.get(_AniProps.xtransform)),
                  origin: origin,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: RightWingsPainter(),
                    ),
                  )),

              Transform(
                  transform: Matrix4.identity()
                    ..rotateX(value.get(_AniProps.xtransform)),
                  origin: origin,
                  child: Container(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: RightWingsPainter(),
                    ),
                  ))
            ],
          );
        });
  }
}

class RightWingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
     var fillBrush = Paint()..color = Color(0xff46b3f7);
    // Paint redPaint = new Paint()
    // ..color = Color.fromARGB(0, 0, 0, 255)
    // ..style = PaintingStyle.fill;
    // canvas.drawPaint(redPaint);

    Vertices rightRearWingVertices = Vertices(VertexMode.triangleFan, [
      const Offset(90, 180),
      const Offset(225, 275),
      const Offset(220, 300),
      const Offset(100, 310),
      const Offset(75, 240)
    ]);

    canvas.drawVertices(rightRearWingVertices, BlendMode.color, fillBrush);

    Vertices rightFrontWingVertices = Vertices(VertexMode.triangleFan, [
      const Offset(100, 160),
      const Offset(180, 90),
      const Offset(200, 20),
      const Offset(250, 200),
      _ButterflyViewState.origin
    ]);

    drawRotated(
        canvas,
        _ButterflyViewState.origin,
        _ButterflyViewState.painterCanvasYTransformAngle,
        () => canvas.drawVertices(
            rightFrontWingVertices, BlendMode.color, fillBrush));
  }

  /**
   * Here's helpful references for what I am doing here and why and how and stuff...
   * https://stackoverflow.com/questions/64230683/flutter-transform-path-in-custompaint-with-float64list-matrix4/64230684#64230684

      https://www.flutterclutter.dev/flutter/tutorials/2022-04-17-rotate-custom-paint-canvas-flutter/
   */

  void drawRotated(
      Canvas canvas, Offset origin, double angle, VoidCallback drawFunction) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.transform(rotateY(angle));
    canvas.translate(-origin.dx, -origin.dy);
    drawFunction();
    canvas.restore();
  }

  Float64List rotateY(double radians) {
    return Float64List.fromList([
      math.cos(radians),
      0,
      -math.sin(radians),
      0,
      0,
      1,
      0,
      0,
      math.sin(radians),
      0,
      math.cos(radians),
      0,
      0,
      0,
      0,
      1
    ]);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
