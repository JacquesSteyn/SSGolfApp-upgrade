import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/widgets/neo/neuomorphic_circle.dart';
import 'package:ss_golf/shared/widgets/neo/progress_ring.dart';

class NeoDonutChart extends StatefulWidget {
  double percentage;
  double dimension;
  NeoDonutChart({Key key, this.percentage, this.dimension}) : super(key: key);

  @override
  _NeoDonutChartState createState() => _NeoDonutChartState();
}

class _NeoDonutChartState extends State<NeoDonutChart> {
  Color shadowColor = Colors.black87;
  Color backgroundColor = Get.theme.accentColor;

  /// Constants.backgroundColor;
  Color highlightColor = Colors.white.withOpacity(0.05);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          NeuomorphicCircle(
            shadowColor: shadowColor,
            backgroundColor: backgroundColor,
            highlightColor: highlightColor,
            innerShadow: true,
            outerShadow: false,
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: widget.dimension, //constraints.maxWidth * 0.3,
              height: widget.dimension, //constraints.maxWidth * 0.3,
              child: NeuomorphicCircle(
                innerShadow: false,
                outerShadow: true,
                highlightColor: highlightColor,
                shadowColor: shadowColor,
                backgroundColor: Colors.black,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      Utilities.roundOffPercentageValue(widget.percentage).toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 32),
                    ),
                  ),
                ),
              ),
            );
          }),
          ProgressRing(percentage: widget.percentage),
        ],
      ),
    );
  }
}
