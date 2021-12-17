// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:ss_golf/services/utilities_service.dart';

// class BarChartFlChart extends StatefulWidget {
//   BarChartFlChart({this.values, this.labels});
//   final List<int> values;
//   final List<String> labels;

//   @override
//   _BarChartFlChartState createState() => _BarChartFlChartState();
// }

// class _BarChartFlChartState extends State<BarChartFlChart> {
//   int _touchedIndex;
//   int _maxCount = 100;

//   double getMaxYValue() {
//     return (_maxCount + 2).toDouble();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildBarChartFlChart();
//   }

//   Widget buildBarChartFlChart() {
//     return BarChart(
//       BarChartData(
//         // alignment: BarChartAlignment.spaceBetween,
//         maxY: getMaxYValue(),
//         barTouchData: BarTouchData(
//           enabled: true,
//           touchCallback: (BarTouchResponse response) {
//             if (response.spot != null &&
//                 response.touchInput is! FlPanEnd &&
//                 response.touchInput is! FlLongPressEnd) {
//               setState(() {
//                 _touchedIndex = response.spot.touchedBarGroupIndex;
//               });
//             } else {
//               setState(() {
//                 _touchedIndex = -1;
//               });
//             }
//           },
//           touchTooltipData: BarTouchTooltipData(
//             getTooltipItem: (group, groupIndex, rod, rodIndex) {
//               return BarTooltipItem(
//                 rod.y.toInt().toString(),
//                 Theme.of(context).textTheme.bodyText2,
//               );
//             },
//           ),
//         ),
//         titlesData: FlTitlesData(
//           show: true,
//           bottomTitles: SideTitles(
//             margin: 10.0,
//             showTitles: true,
//             getTextStyles: (value) {
//               final isTouched = value == _touchedIndex;
//               return TextStyle(
//                 color: Colors.white,
//                 fontSize: 14.0,
//                 fontWeight: isTouched ? FontWeight.bold : FontWeight.w600,
//               );
//             },
//             rotateAngle: 30.0,
//             getTitles: (double index) {
//               return '${widget.labels[index.toInt()]}\n${widget.values[index.toInt()]}';
//             },
//           ),
//           leftTitles: SideTitles(
//             showTitles: false,
//           ),
//           // leftTitles: SideTitles(
//           //     margin: 5.0,
//           //     showTitles: false,
//           //     textStyle: TextStyle(
//           //       color: Colors.grey,
//           //       fontSize: 14.0,
//           //       fontWeight: FontWeight.w400,
//           //     ),
//           //     getTitles: (value) {
//           //       if (value == 0) {
//           //         return '0';
//           //       } else if (value % 3 == 0) {
//           //         return '${value ~/ 3 * 5}K';
//           //       }
//           //       return '';
//           //     }),
//         ),
//         // gridData: FlGridData(
//         //   show: true,
//         //   checkToShowHorizontalLine: (value) => value % 3 == 0,
//         //   getDrawingHorizontalLine: (value) => FlLine(
//         //     color: Colors.black12,
//         //     strokeWidth: 1.0,
//         //     dashArray: [5],
//         //   ),
//         // ),
//         borderData: FlBorderData(show: false),
//         barGroups: widget.values
//             .asMap()
//             .map(
//               (index, value) {
//                 return MapEntry(
//                     index, //IndexedSemantics,
//                     BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           y: // value.count.toDouble(),
//                               index == _touchedIndex
//                                   ? (value.toDouble() + 0.1)
//                                   : value.toDouble(),
//                           colors: [Utilities.gradedColors(value.toDouble())],
//                           width: 22,
//                           backDrawRodData: BackgroundBarChartRodData(
//                             colors: [Theme.of(context).primaryColor],
//                             y: getMaxYValue(),
//                             show: true,
//                           ),
//                         ),
//                       ],
//                     ));
//               },
//             )
//             .values
//             .toList(),
//       ),
//     );
//   }
// }

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:ss_golf/app/stats/deep_stats/deep_stats_dialog.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:get/get.dart';

class HorizontalBarChart extends StatefulWidget {
  HorizontalBarChart({this.stats, @required this.shouldShowSub});
  final List<DeepStat> stats;
  final bool shouldShowSub;

  @override
  _HorizontalBarChartState createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
  List<charts.Series<DeepStat, String>> seriesList = [];

  @override
  void initState() {
    seriesList = [
      new charts.Series<DeepStat, String>(
        id: 'Stats',
        domainFn: (DeepStat stat, _) => stat.name.toString(),
        measureFn: (DeepStat stat, _) =>
            Utilities.roundOffPercentageValueToInt(stat.value),
        fillColorFn: (DeepStat stat, _) =>
            charts.ColorUtil.fromDartColor(Utilities.gradedColors(stat.value)),
        // fillColorFn: (DeepStat stat, _) => charts.MaterialPalette.white, // Utilities.gradedColors(stat.value),
        data: widget.stats,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (DeepStat stat, _) =>
            '${Utilities.roundOffPercentageValue(stat.value)}   ${stat.name}',
        insideLabelStyleAccessorFn: (DeepStat stat, _) {
          return new charts.TextStyleSpec(color: charts.MaterialPalette.white);
        },
        outsideLabelStyleAccessorFn: (DeepStat stat, _) {
          return new charts.TextStyleSpec(
              color: charts.MaterialPalette.white, fontWeight: 'bold');
        },
      ),
      new charts.Series<DeepStat, String>(
        id: 'Stats-Stacked',
        domainFn: (DeepStat stat, _) => stat.name.toString(),
        measureFn: (DeepStat stat, _) =>
            100 - Utilities.roundOffPercentageValueToInt(stat.value),
        // labelAccessorFn: (DeepStat stat, _) =>
        //     '${Utilities.roundOffPercentageValue(stat.value)}   ${stat.name}',
        seriesColor: charts.ColorUtil.fromDartColor(Get.theme.accentColor),
        data: widget.stats,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (DeepStat stat, _) => '',
        //     '${stat.name}: ${Utilities.roundOffPercentageValue(stat.value)}',
        // insideLabelStyleAccessorFn: (DeepStat stat, _) {
        //   return new charts.TextStyleSpec(color: charts.MaterialPalette.white);
        // },
        // outsideLabelStyleAccessorFn: (DeepStat stat, _) {
        //   return new charts.TextStyleSpec(color: charts.MaterialPalette.white);
        // },
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: true,
      vertical: false,
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          String name = model.selectedDatum.first.datum.name;
          if (name != "Physical" && widget.shouldShowSub)
            showDialog(
                context: context,
                builder: (_) {
                  return DeepStatsDialog(
                    chartType: name,
                  );
                });
        })
      ],
      barGroupingType: charts.BarGroupingType.stacked,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(color: charts.MaterialPalette.white),
          lineStyle: new charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shade900),
        ),
      ),
    );
  }
}
