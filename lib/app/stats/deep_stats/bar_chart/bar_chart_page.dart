import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/stats/deep_stats/bar_chart/bar_chart_fl_chart.dart';
import 'package:ss_golf/app/stats/deep_stats/deep_stats_dialog.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/widgets/chart_dialog.dart';

class BarChartPage extends StatelessWidget {
  final List<DeepStat> deepStats;
  // final String nestedStatType;
  final bool shouldShowSub;
  final String chartType;

  BarChartPage(
      {this.deepStats, @required this.shouldShowSub, @required this.chartType});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: Get.size.height * 0.8,

        child: Column(
          children: [
            chartType == 'golf'
                ? ChartInfo(
                    title: "Skill Elements",
                    content:
                        "Each part of your game is broken down into specific skill elements. Each element is a score out of 100 and is compared to the benchmarked standard for your specific handicap bracket (Grey Line). If the grey line extends above the bar in the graph, that means you have some work to do for that skill element of your game!")
                : ChartInfo(
                    title: "Physical Attributes",
                    content:
                        "Each part of your game is broken down into specific physical attributes. Each attribute is a score out of 100 and is compared to the benchmarked standard for your specific handicap bracket (Grey Line). If the grey line extends above the bar in the graph, that means you have some work to do for that physical attribute of your game!"),
            Expanded(
                child: HorizontalBarChart(
              stats: deepStats,
              shouldShowSub: shouldShowSub,
            )),
          ],
        ),

        // BarChartFlChart(
        //     values: deepStats
        //         .map<int>((e) => Utilities.roundOffPercentageValueToInt(e.value))
        //         .toList(),
        //     labels: deepStats.map<String>((e) => e.name).toList()),
      ),
    );
  }
}
