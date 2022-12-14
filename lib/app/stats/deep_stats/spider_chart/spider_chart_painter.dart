import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

class SpiderChart extends StatelessWidget {
  const SpiderChart({
    this.values,
    this.labels,
  });
  final List<int>? values;
  final List<String?>? labels;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(Get.size.width, Get.size.height),
      painter: SpiderChartPainter(values, labels),
    );
  }
}

class SpiderChartPainter extends CustomPainter {
  var values;
  var labels;

  SpiderChartPainter(this.values, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var centerOffset = Offset(centerX, centerY);
    var radius = centerX * 0.75;
    var labelRadius = centerX * 0.9;

    var blueprintPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    var ticks = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];
    var tickDistance = radius / (ticks.length);
    const double tickLabelFontSize = 10;

    var ticksPaint = Paint()
      ..color = Colors.grey[900]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    var features = labels;
    var angle = (2 * pi) / features.length;

    // *** DRAW BLUEPRINT
    ticks.sublist(0, ticks.length).asMap().forEach((index, tick) {
      var tickRadius = tickDistance * (index + 1);

      var blueprintPath = Path();
      blueprintPath.moveTo(centerX, centerY);

      for (int i = 0; i <= features.length; i++) {
        var xAngle = cos(angle * i - pi / 2);
        var yAngle = sin(angle * i - pi / 2);
        // var startingPoint = Offset(centerX + tickRadius, centerY + radius);

        var startingPoint = Offset(
            centerX + tickRadius * xAngle, centerY + tickRadius * yAngle);
        blueprintPath.lineTo(startingPoint.dx, startingPoint.dy);
      }
      blueprintPath.close();
      canvas.drawPath(blueprintPath, blueprintPaint);
    });

    const double featureLabelFontSize = 15;
    const double featureLabelFontWidth = 5;

    var path = Path();
    var graphPaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    var graphOutlinePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..isAntiAlias = true;

    features.asMap().forEach((index, feature) {
      // *** DRAW CHART OUTLINE
      var xAngle = cos(angle * index - pi / 2);
      var yAngle = sin(angle * index - pi / 2);
      var featureOffset =
          Offset(centerX + radius * xAngle, centerY + radius * yAngle);
      var labelOffset = Offset(
          centerX + labelRadius * xAngle, centerY + labelRadius * yAngle);

      canvas.drawLine(centerOffset, featureOffset, ticksPaint);

      // var labelYOffset = yAngle < 0 ? -featureLabelFontSize : 5;
      // var labelXOffset = xAngle > 0 ? -featureLabelFontWidth * feature.length : -10;

      TextPainter(
        text: TextSpan(
          text: '$feature\n${values[index]}',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )
        ..layout(minWidth: 10, maxWidth: size.width)
        ..paint(canvas, Offset(labelOffset.dx, labelOffset.dy));
      // canvas.restore();
      // *** DRAW POINT ON SPIDER CHART
      var scale = radius / ticks.last;

      // Start the graph on the initial point
      var scaledPoint = scale * values[index];
      if (index == 0) {
        path.moveTo(centerX, centerY - scaledPoint);
      }
      path.lineTo(
          centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle);

      canvas.drawCircle(
          Offset(
              centerX + scaledPoint * xAngle, centerY + scaledPoint * yAngle),
          1,
          graphOutlinePaint);
    });
    path.close();
    canvas.drawPath(path, graphPaint);
    canvas.drawPath(path, graphOutlinePaint);
  }

  @override
  bool shouldRepaint(SpiderChartPainter oldDelegate) {
    return false;
  }
}
