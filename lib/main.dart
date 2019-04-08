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

class _QuadrantPainter extends CustomPainter {
  double pad;
  Color color;

  Path path;
  double devWidth;

  _QuadrantPainter(
      context, segments, quadrant, this.pad, this.color) {
    double w = MediaQuery.of(context).size.width - pad;
    double h = MediaQuery.of(context).size.height - pad;
    double onePad = pad / 2;

    double side = min(w, h);
    double sY = ((h - side) / 2) + onePad;
    double sX = ((w - side) / 2) + onePad;

    double cX = (MediaQuery.of(context).size.width) / 2;
    double cY = (MediaQuery.of(context).size.height) / 2;

    path = new Path();
    path.moveTo(cX, cY);
    switch (quadrant) {
      case 0:
        // Outer canvas case
        path
          ..moveTo(sX, sY)
          ..lineTo(sX, sY + side)
          ..lineTo(sX + side, sY + side)
          ..lineTo(sX + side, sY);
        break;
      // Start by drawing left
      case 1:
        if (segments > 0) {
          path.lineTo(sX, cY);
        }
        if (segments > 2) {
          path.lineTo(sX, sY);
        }
        if (segments > 3) {
          path.lineTo(cX, sY);
        }
        break;
      // Start by drawing up
      case 2:
        if (segments > 0) {
          path.lineTo(cX, sY);
        }
        if (segments > 2) {
          path.lineTo(sX + side, sY);
        }
        if (segments > 3) {
          path.lineTo(sX + side, cY);
        }
        break;
      // Start by drawing right
      case 3:
        if (segments > 0) {
          path.lineTo(sX + side, cY);
        }
        if (segments > 2) {
          path.lineTo(sX + side, sY + side);
        }
        if (segments > 3) {
          path.lineTo(cX, sY + side);
        }
        break;
      // Start by drawing down
      case 4:
        if (segments > 0) {
          path.lineTo(cX, sY + side);
        }
        if (segments > 2) {
          path.lineTo(sX, sY + side);
        }
        if (segments > 3) {
          path.lineTo(sX, cY);
        }
        break;
    }
    path.close();
  }

  @override
  bool shouldRepaint(_QuadrantPainter oldDelegate) {
    return oldDelegate.devWidth != devWidth ||
        oldDelegate.pad != pad ||
        oldDelegate.color != color;
  }

  @override
  bool shouldRebuildSemantics(_QuadrantPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        path,
        new Paint()
          ..color = color
          ..style = PaintingStyle.fill);
    canvas.drawPath(
        path,
        new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0);
  }

}

class MondrianWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
    int pieces = Random().nextInt(6) + 3;

    var paths = <Widget>[];
    // Add Canvas
    paths.add( new CustomPaint(
      painter: new _QuadrantPainter(context, 4, 0, 20.0, Colors.white),
    ));
    for (var i = 0; i < pieces; i++){
      int quad = (i ~/ 2) + 1;
      int shape = Random().nextInt(4) + 1;
      paths.add(new CustomPaint(
          painter: new _QuadrantPainter(context, shape, quad, 20.0, colors[Random().nextInt(colors.length)])
      ));
    }
    return new SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        height: MediaQuery.of(context).size.height - 10,
        child: new Stack(children: paths),
      );
  }
}
