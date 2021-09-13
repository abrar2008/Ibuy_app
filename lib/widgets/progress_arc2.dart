import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as mathAdd;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressArc2 extends CustomPainter {
  double arc;
  Color progressColor;
  bool isBackground;

  ProgressArc2(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    double stroke = 10.ssp;
    final height = size.height - 10;
    final width = size.width - 10;

    final rect = Rect.fromLTRB(0, 0, height, width);
    final startAngle = -math.pi;
    final sweepAngle = arc != null ? arc * math.pi / 100 : math.pi;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(width / 2, height / 2);
    // this draws main outer circle
    double angle = arc != null ? arc * math.pi / 100 : math.pi;
    final customPaint = Paint()
      ..strokeCap = StrokeCap.square
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final offset = Offset(
      center.dx + radius * cos(-pi + angle),
      center.dy + radius * sin(-pi + angle),
    );

    if (!isBackground) {
      customPaint.shader =
          LinearGradient(colors: [Colors.blue[200], Colors.blue])
              .createShader(rect);
    }

    canvas.drawArc(rect, startAngle, sweepAngle, false, customPaint);

    //
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
