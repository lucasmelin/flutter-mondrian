import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(Mondrian());

class Mondrian extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mondrian Art Generator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MondrianWidget(),
    );
  }
}

class _SquareCanvasPainter extends CustomPainter {
  double padding;
  Color color;

  Path path;
  double deviceWidth;

  _SquareCanvasPainter(context, this.padding, this.color) {
    double width = MediaQuery.of(context).size.width - padding;
    double height = MediaQuery.of(context).size.height - padding;
    double onePad = padding / 2;

    double sideLength = min(width, height);
    print(sideLength);
    double startY = ((height - sideLength) / 2) + onePad;
    double startX = ((width - sideLength) / 2) + onePad;

    path = new Path()
      ..moveTo(startX, startY)
      ..lineTo(startX, startY + sideLength)
      ..lineTo(startX + sideLength, startY + sideLength)
      ..lineTo(startX + sideLength, startY)
      ..close();
  }

  @override
  bool shouldRepaint(_SquareCanvasPainter oldDelegate) {
    return oldDelegate.deviceWidth != deviceWidth ||
        oldDelegate.padding != padding ||
        oldDelegate.color != color;
  }

  @override
  bool shouldRebuildSemantics(_SquareCanvasPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        path,
        new Paint()
          ..color = color
          ..style = PaintingStyle.fill);
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}

class MondrianWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => print('Tapped Artwork'),
      child: new SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.height - 10,
        child: new Stack(children: <Widget>[
          new CustomPaint(
            painter: new _SquareCanvasPainter(context, 20.0, Colors.white),
          ),
          new CustomPaint(
            painter: new _SquareCanvasPainter(context, 40.0, Colors.blue),
          )
        ]),
      ),
    );
  }
}
