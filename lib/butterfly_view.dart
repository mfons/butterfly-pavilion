import 'dart:typed_data';
import 'dart:ui' as ui;

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
  static const theDuration = 2500 /* 10 flaps/second (160 milliseconds/flap) is actual butterfly flap speed */;
  static final origin = Offset(230, 300);
  static double painterCanvasYTransformAngle = 0;
  late AnimationController controllerWing;

  late bool isMirror;

  static final Tween<double> _rightFrontWingFlapDownTween =
      Tween(begin: 0.0, end: 3 * math.pi / 4);
  static final Tween<double> _rightFrontWingFlapUpTween =
      Tween(begin: 3 * math.pi / 4, end: 0);
  static final Tween<double> _rightFrontWingFlapCanvasRotationStartDownTween =
  Tween(begin: -math.pi /3 , end: math.pi / 8);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownTween =
  Tween(begin: math.pi / 8, end: math.pi / 8);
  static final Tween<double> _rightFrontWingFlapCanvasRotationDownUpTween =
      Tween(begin: math.pi / 8, end: -math.pi /3 );
  static final Tween<double> _rightFrontWingFlapCanvasRotationUpTween =
      Tween(begin: -math.pi /3, end: -math.pi /3 );

  static final MultiTween<_AniProps> _flapTween = MultiTween<_AniProps>()
    ..add(_AniProps.xtransform, _rightFrontWingFlapDownTween,
        Duration(milliseconds: theDuration ~/ 2))
    ..add(_AniProps.xtransform, _rightFrontWingFlapUpTween,
        Duration(milliseconds: theDuration ~/ 2))
    ..add(
        _AniProps.canvasYTransform,
        _rightFrontWingFlapCanvasRotationStartDownTween,
        Duration(milliseconds: 2 * theDuration ~/ 25))
    ..add(
        _AniProps.canvasYTransform,
        _rightFrontWingFlapCanvasRotationDownTween,
        Duration(milliseconds: theDuration ~/ 2 - 3 * theDuration ~/ 25))
    ..add(
        _AniProps.canvasYTransform,
        _rightFrontWingFlapCanvasRotationDownUpTween,
        Duration(milliseconds: 2 * theDuration ~/ 25))
    ..add(_AniProps.canvasYTransform, _rightFrontWingFlapCanvasRotationUpTween,
        Duration(milliseconds: theDuration ~/ 2 - 1 * theDuration ~/ 25));
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
    return
      LoopAnimation<MultiTweenValues<_AniProps>>(
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
                    height: 400,
                    child: CustomPaint(
                     // size: Size(300,(300*1.3333333333333333).toDouble()),
                      painter: RightWingsPainter(true),
                    ),
                  )),

              Transform(
                  transform: Matrix4.identity()
                    ..rotateX(value.get(_AniProps.xtransform)),
                  origin: origin,
                  child: Container(
                    width: 300,
                    height: 400,
                    child: CustomPaint(
                     // size: Size(300,(300*1.3333333333333333).toDouble()),
                      painter: RightWingsPainter(false),
                    ),
                  ))
            ],
          );
        });
  }
}

class RightWingsPainter extends CustomPainter {
  bool isMirror = false;
  RightWingsPainter (this.isMirror);

  @override
  void paint(Canvas canvas, Size size) {
     var fillBrush = Paint()..color = isMirror ? Colors.deepOrange : Colors.blue;
    // Paint redPaint = new Paint()
    // ..color = Color.fromARGB(0, 0, 0, 255)
    // ..style = PaintingStyle.fill;
    // canvas.drawPaint(redPaint);

    ui.Vertices rightRearWingVertices = ui.Vertices(VertexMode.triangleFan, [
      const Offset(90, 180),
      const Offset(225, 275),
      const Offset(220, 300),
      const Offset(100, 310),
      const Offset(75, 240)
    ]);

     drawWithGap(
         canvas,
         _ButterflyViewState.origin,
             () => canvas.drawVertices(rightRearWingVertices, BlendMode.color, fillBrush));


// FRONT WING DRAWING
    // ui.Vertices rightFrontWingVertices = ui.Vertices(VertexMode.triangleFan, [
    //   const Offset(100, 160),
    //   const Offset(180, 90),
    //   const Offset(200, 20),
    //   const Offset(250, 200),
    //   _ButterflyViewState.origin
    // ]);

    // drawRotated(
    //     canvas,
    //     _ButterflyViewState.origin,
    //     ((isMirror) ? -1 : 1) * _ButterflyViewState.painterCanvasYTransformAngle,
    //     () => canvas.drawVertices(
    //         rightFrontWingVertices, BlendMode.color, fillBrush));

     // This form of the wing generated with https://www.youtube.com/watch?v=AnKgtKxRLX4
     //  download and install at https://fluttershapemaker.com/
     Paint paint0 = Paint()
       ..color = const Color.fromARGB(255, 33, 150, 243)
       ..style = PaintingStyle.fill
       ..strokeWidth = 1.0;
     paint0.shader = ui.Gradient.linear(Offset(size.width*0.84,size.height*0.05),Offset(size.width*0.32,size.height*0.75),[Color(0xff000000),Color(0xff000000),Color(0xff3ba6eb),Color(0xff50b5f1)],[0.00,0.11,0.26,1.00]);

     Path path0 = Path();
     path0.moveTo(size.width*0.7666667,size.height*0.7500000);
     path0.quadraticBezierTo(size.width*0.3505000,size.height*0.4212000,size.width*0.3333333,size.height*0.4000000);
     path0.cubicTo(size.width*0.3188333,size.height*0.3861000,size.width*0.3462667,size.height*0.3508500,size.width*0.3567000,size.height*0.3458750);
     path0.cubicTo(size.width*0.3733667,size.height*0.3387750,size.width*0.4091000,size.height*0.3472500,size.width*0.4278000,size.height*0.3425250);
     path0.cubicTo(size.width*0.4403333,size.height*0.3295500,size.width*0.4155333,size.height*0.2857000,size.width*0.4409000,size.height*0.2776000);
     path0.cubicTo(size.width*0.4635333,size.height*0.2747500,size.width*0.5045000,size.height*0.2894000,size.width*0.5176333,size.height*0.2842500);
     path0.cubicTo(size.width*0.5283667,size.height*0.2765250,size.width*0.5210000,size.height*0.2414750,size.width*0.5399000,size.height*0.2325500);
     path0.cubicTo(size.width*0.5480000,size.height*0.2280500,size.width*0.5905667,size.height*0.2304000,size.width*0.6000000,size.height*0.2225000);
     path0.cubicTo(size.width*0.6117667,size.height*0.2136750,size.width*0.5993333,size.height*0.1858000,size.width*0.6055000,size.height*0.1775750);
     path0.quadraticBezierTo(size.width*0.6101333,size.height*0.1695000,size.width*0.6399667,size.height*0.1525000);
     path0.quadraticBezierTo(size.width*0.6277000,size.height*0.1212000,size.width*0.6300000,size.height*0.1075750);
     path0.quadraticBezierTo(size.width*0.6296667,size.height*0.0977000,size.width*0.6511000,size.height*0.0800750);
     path0.quadraticBezierTo(size.width*0.6459667,size.height*0.0533250,size.width*0.6666667,size.height*0.0500000);
     path0.cubicTo(size.width*0.7793667,size.height*0.1559000,size.width*0.8444667,size.height*0.3899000,size.width*0.8333333,size.height*0.5000000);
     path0.quadraticBezierTo(size.width*0.8374333,size.height*0.5637000,size.width*0.7666667,size.height*0.7500000);
     path0.close();


     Paint paint1 = Paint()
       ..color = const Color.fromARGB(255, 33, 150, 243)
       ..style = PaintingStyle.fill
       ..strokeWidth = 1.0;


     Path path1 = Path();
     path1.moveTo(size.width*0.6553000,size.height*0.1979250);
     path1.lineTo(size.width*0.6700000,size.height*0.2200000);
     path1.lineTo(size.width*0.7166667,size.height*0.2600000);
     path1.lineTo(size.width*0.7633333,size.height*0.2950000);
     path1.lineTo(size.width*0.8100000,size.height*0.3350000);
     path1.lineTo(size.width*0.8200000,size.height*0.4225000);
     path1.lineTo(size.width*0.7533333,size.height*0.3725000);
     path1.lineTo(size.width*0.6766667,size.height*0.3025000);
     path1.lineTo(size.width*0.6033333,size.height*0.2350000);
     path1.lineTo(size.width*0.8133333,size.height*0.5225000);
     path1.lineTo(size.width*0.7800000,size.height*0.5025000);
     path1.lineTo(size.width*0.7133333,size.height*0.4400000);
     path1.lineTo(size.width*0.6633333,size.height*0.3950000);
     path1.lineTo(size.width*0.5900000,size.height*0.3375000);
     path1.lineTo(size.width*0.5433333,size.height*0.2925000);
     path1.lineTo(size.width*0.5313333,size.height*0.2820750);
     path1.lineTo(size.width*0.7866667,size.height*0.6100000);
     path1.lineTo(size.width*0.7633333,size.height*0.5825000);
     path1.lineTo(size.width*0.7200000,size.height*0.5500000);
     path1.lineTo(size.width*0.6866667,size.height*0.5200000);
     path1.lineTo(size.width*0.6433333,size.height*0.4925000);
     path1.lineTo(size.width*0.5766667,size.height*0.4325000);
     path1.lineTo(size.width*0.4666667,size.height*0.3425000);
     path1.lineTo(size.width*0.4626667,size.height*0.3356750);
     path1.lineTo(size.width*0.7800000,size.height*0.6850000);
     path1.lineTo(size.width*0.7266667,size.height*0.6400000);
     path1.lineTo(size.width*0.6300000,size.height*0.5625000);
     path1.lineTo(size.width*0.4933333,size.height*0.4525000);
     path1.lineTo(size.width*0.4100000,size.height*0.3800000);
     path1.lineTo(size.width*0.4059667,size.height*0.3669750);

     drawRotated(
         canvas,
         _ButterflyViewState.origin,
         ((isMirror) ? -1 : 1) * _ButterflyViewState.painterCanvasYTransformAngle,
             () => {canvas.drawPath(path0, paint0), canvas.drawPath(path1, paint1)});
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
    canvas.translate(-5, -5); // leave room for the body
    canvas.translate(-origin.dx, -origin.dy);
    drawFunction();
    canvas.restore();
  }

  void drawWithGap(
      Canvas canvas, Offset origin, VoidCallback drawFunction) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.translate(-10, -10); // leave room for the body
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
