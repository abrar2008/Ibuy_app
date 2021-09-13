import 'package:flutter/material.dart';
import 'dart:math' as math;

class Progress extends CustomPainter {
  final Color backgroundColor; //Background color
  final Color progressColor; //Foreground color
  final double startPointAngle; //Canvas drawing start position
  final double endPointAngle; //End position
  final bool centerClose; //Whether the arc is closed
  final double radius; //radius
  final double lineWidth; //The width of the drawn line
  final double value; //The value of the progress bar
  final TextStyle style; //Text style of progress bar (not required)
  final String completeText; //Progress bar text (not required)

  const Progress(
      {this.backgroundColor,
      this.progressColor,
      this.startPointAngle,
      this.endPointAngle,
      this.centerClose,
      this.radius,
      this.lineWidth,
      this.value,
      this.style,
      this.completeText});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint() //Initialize the brush
      ..color = backgroundColor //background color
      ..style = PaintingStyle.stroke //Brush style
      ..strokeCap = StrokeCap.round //Pen tip type
      ..strokeWidth = lineWidth; //The width of the brush
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);

//Draw an arc through Canvas
    canvas.drawArc(rect, startPointAngle, endPointAngle, centerClose, paint);
//The background arc is drawn

    paint
      ..color = progressColor //Foreground color
      ..strokeWidth = lineWidth +
          1.0 //The width of the brush, here we set it slightly wider than the width of the background
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
        rect, startPointAngle, endPointAngle * value, centerClose, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}

class ArcProgress extends StatefulWidget {
  //When calling the Widget in other places, you can assign value directly

  @override
  _ArcProgressState createState() => _ArcProgressState();
}

class _ArcProgressState extends State<ArcProgress> {
  @override
  Widget build(BuildContext context) {
    double value = 8.0;
    return CustomPaint(
      painter: Progress(
        backgroundColor: Colors.grey, //Set the background color
        progressColor: Colors.amber, //Set the foreground color
        radius:
            MediaQuery.of(context).size.width * 0.3, //Set the background color
        lineWidth: 5.0, //Set the line width (here is the background line width)
        startPointAngle: math.pi - (math.pi / 9), //Set the starting point
        endPointAngle: -(7 * math.pi / 9),
        centerClose:
            false, //Whether it is closed, it will be a fan after closing
        value: value,
      ),
    );
  }
}
