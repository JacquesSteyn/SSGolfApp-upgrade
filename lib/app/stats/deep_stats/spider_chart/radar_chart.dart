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
      {@required this.values, this.values2, @required this.labels});
  final List<double> values;
  final List<double> values2;
  final List<String> labels;

  @override
  _CustomRadarChartState createState() => _CustomRadarChartState();
}

class _CustomRadarChartState extends State<CustomRadarChart> {
  bool loaded = false;
  List<double> tempValues = [0, 0, 0];

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
          ChartInfo(
            title: "Golfer Overview",
            content:
                "This is a blueprint of all your overall golfing ability (Blue), compared to the benchmarked standard for your specific handicap bracket (Grey). If the grey shape extends beyond the blue shape, that means you have some work to do in that area of your game!",
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
                      getTitle: (index) {
                        String title = widget.labels[index];
                        if (title.length > 11) {
                          title = title.replaceFirst(' ', '\n');
                        }
                        title += "\n" + tempValues[index].round().toString();
                        return title;
                      },
                      tickCount: 5,
                      ticksTextStyle: const TextStyle(
                          color: Colors.transparent, fontSize: 10),
                      tickBorderData:
                          const BorderSide(color: Colors.blue, width: 1),
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
        fillColor: rawDataSet.color.withOpacity(0.6),
        borderColor: rawDataSet.color,
        entryRadius: 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: 2,
      );
    }).toList();
  }

  List<RawDataSet> rawDataSets() {
    return [
      if (widget.values2 != null &&
          widget.values2.length == widget.values.length)
        RawDataSet(
          color: Colors.grey,
          values: [...widget.values2],
        ),
      RawDataSet(
        color: Colors.blue,
        values: [...widget.values],
      ),
    ];
  }
}

class RawDataSet {
  final Color color;
  final List<double> values;

  RawDataSet({
    @required this.color,
    @required this.values,
  });
}
