import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/stats/deep_stats/deep_stats_dialog.dart';
import 'package:ss_golf/shared/widgets/custom_radial_painter.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';

class DonutChartPage extends StatefulWidget {
  final List<DeepStat> deepStats;
  final String nestedStatType;

  DonutChartPage({this.deepStats, this.nestedStatType});

  @override
  _DonutChartPageState createState() => _DonutChartPageState();
}

class _DonutChartPageState extends State<DonutChartPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: widget.deepStats
            .map<Widget>((deepStat) =>
                statCard(deepStat.name, deepStat.value, widget.nestedStatType))
            .toList(),
      ),
    );
  }

  Widget statCard(String text, double value, String nestedStatType) {
    // print('DEEP STAT: ' + text.toString() + ' val: ' + value.toString());
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      width: Get.size.width * 0.45,
      height: Get.size.width * 0.42,
      decoration: BoxDecoration(
        // color: Colors.brown,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(
            color: nestedStatType != null
                ? Get.theme.accentColor
                : Colors.transparent),
      ),
      child: Stack(
        children: [
          nestedStatType != null
              ? expandableStat(value, text)
              : regularStat(value),
          Align(
            alignment: Alignment(0, 0.9),
            child: InkWell(
              onTap: () {
                print('Selected chart type: ' + nestedStatType);
                // setProgressionChartType(chartType);
              },
              child: Container(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Widget expandableStat(double value, String nestedStatType) {
    return GestureDetector(
      onTap: () => showGeneralDialog(
        barrierDismissible: false,
        context: Get.context,
        barrierColor: Colors.black87,
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.decelerate,
                reverseCurve: Curves.easeOutCubic),
            child: DeepStatsDialog(
              chartType: nestedStatType == 'Physical'
                  ? nestedStatType.toLowerCase()
                  : nestedStatType,
            ),
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return null;
        },
      ),
      child: regularStat(value),
    );
  }

  Widget regularStat(double value) {
    return Container(
      color: Colors.transparent, // *** needs color to detect tap!?
      child: Align(
        alignment: Alignment(-0.4, -0.2),
        child: DonutChart(
          value: value,
        ),
      ),
      // child: Align(
      //   alignment: Alignment(-0.4, -0.2),
      //   child: Container(
      //     child: CustomPaint(
      //       painter: CustomRadialPainter(
      //         percentage: value,
      //         dimension: Get.height * 0.25,
      //         strokeWidth: 15,
      //         color: Colors.tealAccent,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
