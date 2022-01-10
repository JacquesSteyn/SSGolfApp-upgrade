import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/stats/deep_stats/deep_stats_dialog.dart';
import 'package:ss_golf/app/stats/progression_line_chart.dart';
import 'package:ss_golf/shared/models/stat.dart';
import 'package:ss_golf/shared/widgets/chart_dialog.dart';
import 'package:ss_golf/shared/widgets/custom_radial_painter.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';
// import 'package:ss_golf/shared/widgets/neo/neo_donut_chart.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/auth.provider.dart';

class StatsView extends StatefulWidget {
  @override
  _StatsViewState createState() => _StatsViewState();
}

class _StatsViewState extends State<StatsView> {
  String progressionChartType = 'golf';

  setProgressionChartType(String type) {
    setState(() {
      progressionChartType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final statsState = watch(appStateProvider.state);
      final userState = watch(userStateProvider?.state);

      return Container(
        color: Colors.black,
        child: SafeArea(
          child: Container(
            color: Colors.black,
            child: statsState.isLoading
                ? Center(child: CircularProgressIndicator())
                : statsView(statsState, userState.user.id),
          ),
        ),
      );
    });
  }

  Widget statsView(statsState, String userId) {
    final Stat currentStat =
        statsState.latestStat; //.length > 0 ? statsState.stats[0] : null;

    // print('LATEST STATE: ' + currentStat.day.toString());
    return currentStat.day == null
        ? Center(
            child: Text(
              'No stats available yet.\n Please complete more challenges.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          )
        : Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    statCard("Golf", currentStat.golfValue, 'golf'),
                    if (currentStat.physicalValue != null &&
                        currentStat.physicalValue > 0)
                      statCard(
                          "Physical", currentStat.physicalValue, 'physical'),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          overallParentButton('Golf', 'golf'),
                          overallParentButton('Physical', 'physical'),
                        ],
                      ),
                    ),
                    ChartInfo(
                        title: "Golfer Progress",
                        content:
                            "This shows your Golfer Rating progress over time. If you start to notice a downward trend, it's time to hit the range! \n\nTip: Look at your Golfer Overview and Skill Elements in order to identify which part of your game needs the most attention!"),
                    ProgressionLineChart(
                      userId: userId,
                      chartType: progressionChartType,
                    ),
                    SizedBox(
                      height: 12,
                    )
                  ],
                ),
              ),
            ],
          );
  }

  Widget statCard(String title, double value, String chartType) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => showStatsDialog(chartType),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: Get.width * 0.25,
                child: expandableOverallStat(value, chartType)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "$title rating",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Click for more",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget overallParentButton(String title, String chartType) {
    bool isSelected = chartType == progressionChartType;

    return ActionChip(
      onPressed: () {
        setProgressionChartType(chartType);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        side: BorderSide(
            color: isSelected ? Colors.grey : Colors.grey[800], width: 2),
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      elevation: isSelected ? 5 : 0,
      label: Text(
        "$title overall",
        softWrap: true,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      backgroundColor: isSelected
          ? Get.theme.accentColor
          : Colors.black, // Colors.grey[200] : Colors.black,
    );
  }

  showStatsDialog(String chartType) {
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black87,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: a1,
              curve: Curves.decelerate,
              reverseCurve: Curves.easeOutCubic),
          child: DeepStatsDialog(
            chartType: chartType,
          ),
        );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return null;
      },
    );
  }

  Widget expandableOverallStat(double value, String chartType) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // *** needs color to detect tap!?
          borderRadius: BorderRadius.circular(18.0),
          border: Border.all(color: Get.theme.accentColor),
        ),
        // color: Colors.red,
        child:
            //  NeoDonutChart(
            //   percentage: value,
            //   dimension: Get.height * 0.25,
            // ),
            DonutChart(
          value: value,
        )
        //     CustomPaint(
        //   painter: CustomRadialPainter(
        //     percentage: value,
        //     dimension: 150, // Get.height * 0.25,
        //     strokeWidth: 15,
        //     color: Colors.tealAccent,
        //   ),
        // ),

        );
  }
}
