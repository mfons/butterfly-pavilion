import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:simple_animations/simple_animations.dart';

class ButterflyView extends StatefulWidget {
  const ButterflyView({Key? key}) : super(key: key);

  @override
  State<ButterflyView> createState() => _ButterflyViewState();
}

enum _AniProps { xtransform, ztransform}

class _ButterflyViewState extends State<ButterflyView>
  with TickerProviderStateMixin {

  static final theDuration = 2000;

  late AnimationController controllerWing;

 static final Tween<double> _rightFrontWingFlapDownTween = Tween(begin: 0.0, end: 3*math.pi/4);
  static final Tween<double> _rightFrontWingFlapUpTween = Tween(begin:3*math.pi/4, end: 0);
  static final Tween<double> _rightFrontWingRotateFlapDownTween = Tween(begin:-math.pi/4, end:math.pi/4);
  static final Tween<double> _rightFrontWingRotateFlapUpTween = Tween(begin:math.pi/4, end:-math.pi/4);
  static final Tween<double> _rightFrontWingRotateHoldFlapDownTween = Tween(begin:math.pi/4, end:math.pi/4);
  static final Tween<double> _rightFrontWingRotateHoldFlapUpTween = Tween(begin:-math.pi/4, end:-math.pi/4);
  static final MultiTween<_AniProps> _flapTween = MultiTween<_AniProps>()
    ..add(_AniProps.xtransform, _rightFrontWingFlapDownTween, Duration(milliseconds: theDuration~/2))
    ..add(_AniProps.xtransform, _rightFrontWingFlapUpTween, Duration(milliseconds: theDuration~/2))
    ..add(_AniProps.ztransform, _rightFrontWingRotateFlapDownTween, Duration(milliseconds: theDuration~/(2*10)))
    ..add(_AniProps.ztransform, _rightFrontWingRotateFlapUpTween, Duration(milliseconds: theDuration~/(2*10)))
    ..add(_AniProps.ztransform, _rightFrontWingRotateHoldFlapDownTween, Duration(milliseconds: 9*theDuration~/(2*10)))
    ..add(_AniProps.ztransform, _rightFrontWingRotateHoldFlapUpTween, Duration(milliseconds: 9*theDuration~/(2*10)));
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
        return Transform(
        transform: Matrix4.identity()
          // ..rotateZ(math.pi/15)
          ..rotateZ(value.get(_AniProps.ztransform))
          ..rotateX(value.get(_AniProps.xtransform)),
            // ..rotateX(animationDownWing.value - animationUpWing.value),
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
    canvas.drawVertices(vertices, BlendMode.color, fillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
