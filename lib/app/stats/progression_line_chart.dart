import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/services/utilities_service.dart';

class TimePeriod {
  String? label, startDay, endDay;
  TimePeriod({this.label, this.startDay, this.endDay});
}

class ProgressionLineChart extends StatefulWidget {
  final String? userId;
  final String? chartType;
  ProgressionLineChart({this.userId, this.chartType});

  @override
  _ProgressionLineChartState createState() => _ProgressionLineChartState();
}

class TimePeriodLabels {
  static const oneWeekPeriod = '1\n week ';
  static const twoWeekPeriod = '2\nweeks ';
  static const oneMonthPeriod = '1\nmonth ';
  static const threeMonthPeriod = '3\nmonths';
  static const sixMonthPeriod = '6\nmonths';
}

class _ProgressionLineChartState extends State<ProgressionLineChart> {
  final DataService _dataService = DataService();
  Stream? _dataStream;
  TimePeriod? _selectedTimePeriod;
  List<TimePeriod> _timePeriods = [];
  late DateTime currentDateTime;
  int yAxisInterval = 30;

  List<Color> gradientColors = [
    // const Color(0xFF625D7B),
    const Color(0xFFE2E2E2),
    // const Color(0xFF853D16),

    // const Color(0xFF272627),
    const Color(0xFF141414),
    // const Color(0xFF000000),
  ];

  @override
  void initState() {
    currentDateTime = DateTime.now();
    _timePeriods.addAll([
      TimePeriod(
          label: TimePeriodLabels.oneWeekPeriod,
          endDay: Utilities.getCurrentDayId(),
          startDay: Utilities.getLastWeekStartDayId(currentDateTime)),
      TimePeriod(
          label: TimePeriodLabels.twoWeekPeriod,
          endDay: Utilities.getCurrentDayId(),
          startDay: Utilities.getLastTwoWeeksStartDayId(currentDateTime)),
      TimePeriod(
          label: TimePeriodLabels.oneMonthPeriod,
          endDay: Utilities.getCurrentDayId(),
          startDay: Utilities.getLastMonthStartDayId(currentDateTime)),
      TimePeriod(
          label: TimePeriodLabels.threeMonthPeriod,
          endDay: Utilities.getCurrentDayId(),
          startDay: Utilities.getLastThreeMonthsStartDayId(currentDateTime)),
      TimePeriod(
          label: TimePeriodLabels.sixMonthPeriod,
          endDay: Utilities.getCurrentDayId(),
          startDay: Utilities.getLastSixMonthsStartDayId(currentDateTime)),
    ]);
    _selectedTimePeriod = _timePeriods[4];
    _dataStream = _dataService.datedProgressionStatsStream(widget.userId,
        _selectedTimePeriod!.startDay!, _selectedTimePeriod!.endDay!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        color: Colors.black54, // Color(0xFF1E2630),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AspectRatio(
            aspectRatio: 1.8,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                child: streamedLineChartData(),
              ),
            ),
          ),
          timeLineButtons(),
        ],
      ),
    );
  }

  void _onUpdateSelectedTimePeriod(TimePeriod period) {
    setState(() {
      _selectedTimePeriod = period;
      _dataStream = _dataService.datedProgressionStatsStream(
          widget.userId, period.startDay!, period.endDay!);
      // update for UI
      if (period.label == TimePeriodLabels.oneWeekPeriod) {
        yAxisInterval = 2;
      } else if (period.label == TimePeriodLabels.twoWeekPeriod) {
        yAxisInterval = 4;
      } else if (period.label == TimePeriodLabels.oneMonthPeriod) {
        yAxisInterval = 6;
      } else if (period.label == TimePeriodLabels.threeMonthPeriod) {
        yAxisInterval = 15;
      } else if (period.label == TimePeriodLabels.sixMonthPeriod) {
        yAxisInterval = 30;
      }
    });
  }

  Widget timeLineButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _timePeriods
            .map<Widget>((period) => timeLineButton(period))
            .toList(),
      ),
    );
  }

  Widget timeLineButton(TimePeriod period) {
    bool isSelected = _selectedTimePeriod == period;

    return Container(
      constraints: BoxConstraints(maxWidth: Get.width / 5),
      child: ActionChip(
        onPressed: () {
          _onUpdateSelectedTimePeriod(period);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          side: BorderSide(color: isSelected ? Colors.grey : Colors.grey[800]!),
        ),
        padding: const EdgeInsets.all(1),
        elevation: isSelected ? 5 : 0,
        label: FittedBox(
          child: Text(
            period.label!,
            softWrap: false,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
        backgroundColor: isSelected ? Colors.grey[300] : Colors.black,
      ),
    );
  }

  Widget streamedLineChartData() {
    return StreamBuilder(
      stream: _dataStream,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
          //Map? rawStats = snapshot.data as Map?;

          Map? rawStats = (snapshot.data! as DatabaseEvent).snapshot.value
              as Map<Object?, dynamic>?;

          // print('rawStats: ' + rawStats.toString());
          List<FlSpot> dataPoints = [];

          List<String> dayIds = Utilities.getDayIds(
              _selectedTimePeriod!.startDay!, _selectedTimePeriod!.endDay!);

          double? lastVal = 0;

          dayIds.asMap().forEach((index, dayId) {
            if (rawStats?[dayId] != null &&
                rawStats?[dayId][widget.chartType] != null) {
              dataPoints.add(FlSpot(index.toDouble(),
                  rawStats?[dayId][widget.chartType]['value']));

              lastVal = rawStats?[dayId][widget.chartType]['value'];
            } else {
              // TODO - what to do with this?? make prev val?
              dataPoints.add(FlSpot(index.toDouble(), lastVal!));
            }
          });

          // print('DAY IDS:: ' + dataPoints.toString());
          return LineChart(
            lineChartData(dataPoints, dayIds),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  LineChartData lineChartData(
    List<FlSpot> dataPoints,
    List<String> dayIds,
  ) {
    return LineChartData(
      // showingTooltipIndicators: true,
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            //margin: 10,
            interval: 20,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: TextStyle(color: Colors.grey),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //margin: 10,
            interval: yAxisInterval.toDouble(),
            getTitlesWidget: (value, meta) {
              return Container(
                color: Colors.black,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  Utilities.formatXAxisLabel(dayIds[value.toInt()]),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              );
            },
          ),
        ),
      ),
      minY: 0,
      maxY: 100,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipBgColor: Colors.white,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                String tooltipText =
                    '${Utilities.formatChartHeaderDate(dayIds[barSpot.x.toInt()])}\n\n${Utilities.roundOffPercentageValue(barSpot.y)}';
                return LineTooltipItem(
                  tooltipText,
                  TextStyle(color: Colors.black),
                );
              }).toList();
            }),
        getTouchedSpotIndicator:
            (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(color: Colors.grey[200], strokeWidth: 1),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  var flDotCirclePainter = FlDotCirclePainter(
                    radius: 4,
                    color: Colors.grey[200],
                    // strokeWidth: 5,
                  );
                  return flDotCirclePainter;
                },
              ),
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: dataPoints,
          dotData: FlDotData(
            show: false,
          ),
          isCurved: true,
          barWidth: 3,
          isStrokeCapRound: true,
          color: Colors.white, // gradientColors,
          belowBarData: BarAreaData(
            gradient: LinearGradient(
              stops: [0.3, 0.75],
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
            show: true,
          ),
        ),
      ],
    );
  }
}
