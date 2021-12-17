import 'package:flutter/material.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:vector_math/vector_math.dart' as vm;
// import './constants.dart';

class ProgressRing extends StatelessWidget {
  final double percentage;

  const ProgressRing({Key key, @required this.percentage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox.expand(
          child: CustomPaint(
              painter: RingPainter(
        strokeWidth: constraints.maxWidth * 0.15,
        percentage: (percentage / 100),
        gradedColor: Utilities.gradedColors(percentage),
      )));
    });
  }
}

class RingPainter extends CustomPainter {
  final double strokeWidth;
  final double percentage;
  final Color gradedColor;

  RingPainter({@required this.strokeWidth, @required this.percentage, this.gradedColor});

  @override
  void paint(Canvas canvas, Size size) {
    final inset = size.width * 0.18;

    final rect = Rect.fromLTRB(inset, inset, size.width - inset, size.height - inset);

    canvas.drawArc(
        rect,
        vm.radians(-90),
        vm.radians(360 * percentage),
        false,
        Paint()
          ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                gradedColor,
                gradedColor,
                // Colors.red,
                // Colors.orange,
                // Colors.green,
              ]).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round);
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) {
    if (oldDelegate.percentage != percentage || oldDelegate.strokeWidth != strokeWidth) {
      return true;
    }
    return false;
  }
}
