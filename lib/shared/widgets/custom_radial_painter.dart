import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ss_golf/services/utilities_service.dart';

class CustomRadialPainter extends CustomPainter {
  double? percentage;
  double? dimension;
  double? strokeWidth;
  Color? color;
  CustomRadialPainter(
      {this.percentage, this.dimension, this.strokeWidth, this.color});
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    if (percentage == null) {
      percentage = 0;
    }
    dimension = 155;
    double width = dimension! / 5;
    Offset center = Offset(width, 0);
    double radius = dimension! / 3;

    final Paint line = new Paint()
      ..color = Color(
          0xFF1C1E22) // Colors.grey[300] // Color(0xFF625D7B) // Colors.grey
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;

    // final Paint shadedLine = new Paint()
    //   ..shader = RadialGradient(
    //     colors: [
    //       // Utilities.gradedColors(percentage).withOpacity(0.5),
    //       // Utilities.gradedColors(percentage).withOpacity(0.15),
    //       const Color(0xFF1C1E22),
    //       const Color(0xFF1C1E22),
    //       // const Color(0xFFE2E2E2),
    //       // const Color(0xFFE2E2E2),
    //       // const Color(0xFF141414),
    //     ],
    //     stops: [0.2, 0.85], //, 0.85],
    //   ).createShader(Rect.fromCircle(
    //     center: Offset(dimension / 5, 0),
    //     radius: dimension / 3,
    //   ));

    final Paint filledInLine = new Paint()
      ..color =
          Utilities.gradedColors(percentage) //   color // Color(0xFF0155A6)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;
    // ..shader = RadialGradient(colors: [
    //   Utilities.gradedColors(percentage),
    //   Utilities.gradedColors(percentage).withOpacity(0.85)
    // ]).createShader(Rect.fromCircle(
    //   center: Offset(dimension / 5, 0),
    //   radius: dimension / 3,
    // ));

    // double width = dimension / 5;
    // Offset center = Offset(width, 0);
    // double radius = dimension / 3;
    canvas.drawCircle(center, radius, line);
    // canvas.drawCircle(center, radius, shadedLine);

    double arcAngle = 2 * pi * (percentage! / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, filledInLine);

    // ** decimal checks
    // int intPercentage = percentage.toInt();
    // String text = percentage - intPercentage > 0
    //     ? percentage.toStringAsFixed(1).toString()
    //     : intPercentage.toString();
    // int intVal = percentage.toInt();
    // double decimalVal = percentage - intVal;
    // int percentageValue = decimalVal > 0.5 ? (intVal + 1) : intVal;

    String textValue = Utilities.roundOffPercentageValue(percentage!);

    double widthFactor = 3;

    if (textValue.length == 1) {
      widthFactor = 1.5;
    }
    if (textValue.length == 3) {
      widthFactor = 15;
    }

    _textPainter.text = TextSpan(
        text: textValue,
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.w500,
        ));
    _textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);
    _textPainter.paint(canvas, Offset(width / widthFactor, -radius / 3));
  }

  @override
  bool shouldRepaint(CustomRadialPainter oldDelegate) => false;
}
