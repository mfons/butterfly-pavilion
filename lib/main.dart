import 'package:butterfly_pavilion/butterfly_view.dart';
import 'package:butterfly_pavilion/routes.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

// test change
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butterfly Pavillion',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  // double _xRotation = math.pi / 10;
  // double _yRotation = -math.pi / 3;
  double rx = 0.0, ry = 0.0, rz = 0.0;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 750),
                  pageBuilder: (_, __, ___) => const HomePage()),
          );
        },
       // onVerticalDragUpdate: (details) {
       //    setState(() {
       //      _xRotation = _xRotation + details.delta.direction/60;
       //    });
       //  },
       //  onHorizontalDragUpdate: (details) {
       //    setState(() {
       //      _yRotation = _yRotation + details.primaryDelta!/60;
       //    });
       //  },
        onPanUpdate: (details) {
          ry += details.delta.dx * 0.01;
          rx += details.delta.dy * 0.01;
         // rz += details.delta.dz * 0.01;
          setState(() {
            rx %= math.pi * 2;
            ry %= math.pi * 2;
            rz %= math.pi * 2;
          });
        },
        child: Scaffold(
          // appBar: AppBar(
          //     title: const Text(
          //         "Butterflies.org...tap the butterfly to continue...")),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.amberAccent,
                child: Hero(
                    tag: 'butterflyHero',
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                      //..rotateX(math.pi / 10)
                      ..rotateX(rx/*_xRotation*/)
                        ..rotateY(ry /*_yRotation */)
                        ..rotateZ(rz)
                        ..setEntry(3, 2, 0.001),
                      child: ButterflyView(),
                    )),
              ),
              const SizedBox(height: 32),
              Slider(
                value: rx,
                onChanged: (value) => setState(() => rx = value),
                min: 0,
                max: math.pi * 2,
              ),
              Slider(
                value: ry,
                onChanged: (value) => setState(() => ry = value),
                min: 0,
                max: math.pi * 2,
              ),
              Slider(
                value: rz,
                onChanged: (value) => setState(() => rz = value),
                min: 0,
                max: math.pi * 2,
              ),
              // Slider(
              //   value: _duration.toDouble(),
              //   onChanged: (value) => setState(() => _duration = value.toInt()),
              //   min: 160,
              //   max: 2500,
              // ),
            ],
          ),
        ));
  }
}
