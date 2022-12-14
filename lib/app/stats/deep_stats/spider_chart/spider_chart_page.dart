import 'package:flutter/material.dart';
import 'package:ss_golf/app/stats/deep_stats/deep_stats_dialog.dart';
import 'package:ss_golf/app/stats/deep_stats/spider_chart/spider_chart_painter.dart';
import 'package:ss_golf/services/utilities_service.dart';

class SpiderChartPage extends StatelessWidget {
  final List<DeepStat>? deepStats;

  SpiderChartPage({this.deepStats});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpiderChart(
            values: deepStats!
                .map<int>((e) => Utilities.roundOffPercentageValueToInt(e.value!))
                .toList(),
            labels: deepStats!.map<String?>((e) => e.name).toList()),
      ),
    );
  }
}
