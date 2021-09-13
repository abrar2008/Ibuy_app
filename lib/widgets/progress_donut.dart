import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressDonut extends CustomPainter {
  double pctComplete;
  double stroke = 20.ssp;
  ProgressDonut(this.pctComplete);

  @override
  void paint(Canvas canvas, Size size) {

    Paint basePaint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7 * stroke;

    Offset center  = Offset(
        size.height/2,
        size.width/2
    );

    double radius = min(size.width/2, size.height/2) - stroke;

    canvas.drawCircle(
        center,
        radius,
        basePaint
    );

    Paint progressPaint = Paint()
      ..shader = LinearGradient(colors: [
        Colors.amber, Colors.blue, Colors.blueAccent
      ]).createShader(Rect.fromCircle(center: center, radius: size.width/2))
      //]).createShader(Rect.fromLTRB(0,0,150,150))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    double angle = 2 * pi * (pctComplete/100);
    canvas.drawArc(
        Rect.fromCircle(
            center: center,
            radius: radius),
        pi/2,
        angle,
        false,
        progressPaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}