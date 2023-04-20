import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ss_golf/shared/widgets/chart_dialog.dart';

const gridColor = Color(0xff68739f);
const titleColor = Color(0xff8c95db);
const artColor = Color(0xff63e7e5);
const boxingColor = Color(0xff83dea7);
const entertainmentColor = Colors.white70;

class CustomRadarChart extends StatefulWidget {
  const CustomRadarChart(
      {required this.values,
      this.values2,
      required this.labels,
      required this.chartType});
  final List<double?> values;
  final List<double>? values2;
  final List<String?> labels;
  final String? chartType;

  @override
  _CustomRadarChartState createState() => _CustomRadarChartState();
}

class _CustomRadarChartState extends State<CustomRadarChart> {
  bool loaded = false;
  List<double?> tempValues = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        tempValues = widget.values;
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.chartType == 'golf'
              ? ChartInfo(
                  title: "Golfer Overview",
                  content:
                      "This is a blueprint of all your overall golfing ability (Blue), compared to the benchmarked standard for your specific handicap bracket (Grey). If the grey shape extends beyond the blue shape, that means you have some work to do in that area of your game!",
                )
              : ChartInfo(
                  title: "Physical Overview",
                  content:
                      "This is a blueprint of all your overall physical ability (Blue), compared to the benchmarked standard for your specific handicap bracket (Grey). If the grey shape extends beyond the blue shape, that means you have some work for that physical attribute!",
                ),
          const SizedBox(height: 4),
          AspectRatio(
            aspectRatio: 1.3,
            child: RadarChart(
              !loaded
                  ? RadarChartData(
                      dataSets: showingDataSets(),
                    )
                  : RadarChartData(
                      radarTouchData: RadarTouchData(
                          touchCallback: (FlTouchEvent event, response) {}),
                      dataSets: showingDataSets(),
                      radarBackgroundColor: Colors.transparent,
                      borderData: FlBorderData(show: false),
                      radarBorderData:
                          const BorderSide(color: Colors.transparent),
                      titlePositionPercentageOffset: 0.2,
                      titleTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 14),
                      getTitle: (index, angle) {
                        String title = widget.labels[index]!;
                        if (title.length > 11) {
                          title = title.replaceAll(' ', '\n');
                        }
                        title += "\n" + tempValues[index]!.round().toString();
                        return RadarChartTitle(text: title);
                      },
                      tickCount: maxTickScale(),
                      ticksTextStyle: const TextStyle(
                          color: Colors.transparent, fontSize: 8),
                      tickBorderData: BorderSide(
                          color: Colors.blue.withOpacity(0.3), width: 1),
                      gridBorderData:
                          const BorderSide(color: gridColor, width: 2),
                    ),
              swapAnimationDuration: Duration(milliseconds: 450),
              swapAnimationCurve: Curves.easeIn,
            ),
          ),
        ],
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
      var rawDataSet = entry.value;

      return RadarDataSet(
        fillColor: rawDataSet.fill,
        borderColor: rawDataSet.color,
        entryRadius: 4,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e!)).toList(),
        borderWidth: 0,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      if (widget.values2 != null &&
          widget.values2!.length == widget.values.length)
        RawDataSet(
          fill: Colors.grey.withOpacity(0.7),
          color: Colors.grey,
          values: [...widget.values2!],
        ),
      RawDataSet(
        fill: Colors.blue.withOpacity(0.7),
        color: Colors.blue,
        values: [...widget.values],
      ),
      RawDataSet(
        fill: Colors.transparent,
        color: Colors.white.withOpacity(0),
        values: List.filled(widget.values.length, maxScoreScale()),
      ),
    ];
  }

  double maxScoreScale() {
    double maxScore =
        [...widget.values].reduce((curr, next) => curr! > next! ? curr : next)!;
    double maxHandicap =
        [...?widget.values2].reduce((curr, next) => curr > next ? curr : next);
    double maxScale = maxScore > maxHandicap ? maxScore : maxHandicap;
    return (((maxScale / 10).round() * 10) + 10).toDouble();
  }

  int maxTickScale() {
    double maxScore = maxScoreScale();
    print("maxScore: $maxScore");
    if (maxScore <= 60)
      return (maxScore ~/ 5);
    else
      return (maxScore ~/ 10);
  }
}

class RawDataSet {
  final Color fill;
  final Color color;
  final List<double?> values;

  RawDataSet({
    required this.fill,
    required this.color,
    required this.values,
  });
}
