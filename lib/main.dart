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
    canvas.drawPath(
        path,
        new Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0);
  }

  @override
  bool hitTest(Offset position) {
    return path.contains(position);
  }
}

class _SquareQuadrantPainter extends CustomPainter {
  double padding;
  Color color;

  Path path;
  double deviceWidth;

  _SquareQuadrantPainter(
      context, segments, quadrant, this.padding, this.color) {
    double width = MediaQuery.of(context).size.width - padding;
    double height = MediaQuery.of(context).size.height - padding;
    double onePad = padding / 2;

    double sideLength = min(width, height);
    double startY = ((height - sideLength) / 2) + onePad;
    double startX = ((width - sideLength) / 2) + onePad;

    double centerX = (MediaQuery.of(context).size.width) / 2;
    double centerY = (MediaQuery.of(context).size.height) / 2;

    path = new Path();
    path.moveTo(centerX, centerY);

    switch (quadrant) {
      // Start by drawing left
      case 1:
        if (segments > 0) {
          path.lineTo(startX, centerY);
        }
        if (segments > 2) {
          path.lineTo(startX, startY);
        }
        if (segments > 3) {
          path.lineTo(centerX, startY);
        }
        break;
      // Start by drawing up
      case 2:
        if (segments > 0) {
          path.lineTo(centerX, startY);
        }
        if (segments > 2) {
          path.lineTo(startX + sideLength, startY);
        }
        if (segments > 3) {
          path.lineTo(startX + sideLength, centerY);
        }
        break;
      // Start by drawing right
      case 3:
        if (segments > 0) {
          path.lineTo(startX + sideLength, centerY);
        }
        if (segments > 2) {
          path.lineTo(startX + sideLength, startY + sideLength);
        }
        if (segments > 3) {
          path.lineTo(centerX, startY + sideLength);
        }
        break;
      // Start by drawing down
      case 4:
        if (segments > 0) {
          path.lineTo(centerX, startY + sideLength);
        }
        if (segments > 2) {
          path.lineTo(startX, startY + sideLength);
        }
        if (segments > 3) {
          path.lineTo(startX, centerY);
        }
        break;
    }

    path.close();
  }

  @override
  bool shouldRepaint(_SquareQuadrantPainter oldDelegate) {
    return oldDelegate.deviceWidth != deviceWidth ||
        oldDelegate.padding != padding ||
        oldDelegate.color != color;
  }

  @override
  bool shouldRebuildSemantics(_SquareQuadrantPainter oldDelegate) => true;

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
            painter:
            new _SquareQuadrantPainter(context, 4, 1, 20.0, Colors.red),
          ),
          new CustomPaint(
            painter:
                new _SquareQuadrantPainter(context, 4, 2, 20.0, Colors.green),
          ),
          new CustomPaint(
            painter:
            new _SquareQuadrantPainter(context, 4, 3, 20.0, Colors.yellow),
          ),
          new CustomPaint(
            painter:
            new _SquareQuadrantPainter(context, 4, 4, 20.0, Colors.blue),
          ),
        ]),
      ),
    );
  }
}
