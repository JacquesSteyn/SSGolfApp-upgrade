import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/app/stats/deep_stats/bar_chart/bar_chart_page.dart';
import 'package:ss_golf/app/stats/deep_stats/donut_chart/donut_chart_page.dart';
import 'package:ss_golf/app/stats/deep_stats/dots_scroll_view_indicator.dart';
import 'package:ss_golf/app/stats/deep_stats/spider_chart/radar_chart.dart';
import 'package:ss_golf/shared/models/benchmark.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/stat.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/auth.provider.dart';

class DeepStat {
  String? name;
  double? value;

  DeepStat({this.name, this.value = 0});
}

class DeepStatsDialog extends StatefulWidget {
  final String? chartType;
  DeepStatsDialog({this.chartType});

  @override
  _DeepStatsDialogState createState() => _DeepStatsDialogState();
}

class _DeepStatsDialogState extends State<DeepStatsDialog> {
  final PageController _pageController = PageController();
  static const _kDuration = const Duration(milliseconds: 200);
  static const _kCurve = Curves.ease;
  String? _title = '';
  String? _nestedStatType;

  @override
  void initState() {
    print('INIT DEEP STATS DIALOG ' + widget.chartType!);
    if (widget.chartType == 'golf') {
      _title = 'Golf attributes';
      _nestedStatType = 'skill-element';
    } else if (widget.chartType == 'physical') {
      _title = 'Physical attributes';
    } else if (widget.chartType != null) {
      _title = widget.chartType;
      // _nestedStatType = null;
    }
    // _feedback = new ChallengeFeedback({
    //   'userId': widget.userId,
    //   'challengeId': widget.challengeId,
    //   'rating': 0.0,
    //   'ratingNotes': ''
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _title,
        showActions: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: SafeArea(child: Center(child: _dialogContent())),
      ),
    );
  }

  List<double> getSkillHandicapValues(List<Skill>? skills, String? userHandicap,
      Benchmark? overallPhysicalBenchmark) {
    List<double> tempList = [];
    if (skills != null) {
      int handicap = 0;

      if (userHandicap == null) {
        userHandicap = "0";
      }

      if (userHandicap == 'N/A') {
        userHandicap = '-1';
      }
      if (userHandicap.contains('+')) {
        handicap = -1;
      } else {
        handicap = 10;
        handicap = int.parse(userHandicap);
      }

      skills.forEach((skill) {
        if (handicap < 0) {
          tempList.add(skill.benchmarks.pro.toDouble());
        } else if (handicap >= 0 && handicap < 10) {
          tempList.add(skill.benchmarks.zero_to_nine.toDouble());
        } else if (handicap < 20) {
          tempList.add(skill.benchmarks.ten_to_nineteen.toDouble());
        } else if (handicap < 30) {
          tempList.add(skill.benchmarks.twenty_to_twenty_nine.toDouble());
        } else {
          tempList.add(skill.benchmarks.thirty_plus.toDouble());
        }
      });

      //Add physical attribute
      if (overallPhysicalBenchmark != null) {
        if (handicap < 0) {
          tempList.add(overallPhysicalBenchmark.pro.toDouble());
        } else if (handicap >= 0 && handicap < 10) {
          tempList.add(overallPhysicalBenchmark.zero_to_nine.toDouble());
        } else if (handicap < 20) {
          tempList.add(overallPhysicalBenchmark.ten_to_nineteen.toDouble());
        } else if (handicap < 30) {
          tempList
              .add(overallPhysicalBenchmark.twenty_to_twenty_nine.toDouble());
        } else {
          tempList.add(overallPhysicalBenchmark.thirty_plus.toDouble());
        }
      } else {
        tempList.add(0);
      }

      return tempList;
    } else {
      if (skills != null) {
        skills.forEach((element) {
          tempList.add(0);
        });
      }
    }
    return tempList;
  }

  Widget _dialogContent() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.size.height,
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final appState = ref.watch(appStateProvider);
          final latestStat = appState.latestStat;
          final allSkills = appState.skills;
          final overallPhysicalBenchmark = appState.overallPhysicalBenchmark;
          final allAttributes = appState.attributes;
          final userState = ref.watch(userStateProvider).user;
          final profileState = ref.watch(profileStateProvider);

          print('CHART TYPE: ' + widget.chartType.toString());

          profileState.initProfile(userState);

          // process which nested stats to display
          List<DeepStat> deepStats = [];
          if (widget.chartType == 'golf') {
            // get skills
            allSkills.forEach((skill) {
              int skillIndex = latestStat!.findSkillIndex(skill.id);

              if (skillIndex > -1) {
                SkillStat skillStat = latestStat.skillStats![skillIndex];
                deepStats.add(
                    DeepStat(name: skillStat.name, value: skillStat.value));
              } else {
                deepStats.add(DeepStat(name: skill.name, value: 0));
              }
            });
            // add physical contribution
            deepStats.add(DeepStat(
                name: 'Physical', value: latestStat!.physicalValue ?? 0));
          } else if (widget.chartType == 'physical') {
            // get attributes
            allAttributes.forEach((attribute) {
              int attributeIndex = latestStat!.findAttributeIndex(attribute.id);
              if (attributeIndex > -1) {
                AttributeStat attributeStat =
                    latestStat.attributeStats![attributeIndex];
                deepStats.add(DeepStat(
                    name: attributeStat.name, value: attributeStat.value));
              } else {
                deepStats.add(DeepStat(name: attribute.name, value: 0));
              }
            });

            // latestStat.attributeStats.forEach((attributeStat) {
            //   deepStats
            //       .add(DeepStat(name: attributeStat.name, value: attributeStat.value));
            // });
          } else if (widget.chartType != null) {
            int? skillIndex =
                latestStat!.findSkillIndexByName(widget.chartType ?? "");
            int allSkillIndex =
                allSkills.indexWhere((skill) => skill.name == widget.chartType);
            if (allSkillIndex > -1 && skillIndex > -1) {
              allSkills[allSkillIndex].elements!.forEach((element) {
                int skillElementIndex = latestStat.skillStats![skillIndex]
                    .findElementIndex(element.id);
                if (skillElementIndex > -1) {
                  ElementStat elementStat = latestStat
                      .skillStats![skillIndex].elementStats![skillElementIndex];
                  print('ELEMENTTT STTATTTTTT: ' +
                      elementStat.getJson().toString());
                  deepStats.add(DeepStat(
                      name: elementStat.name, value: elementStat.value));
                } else {
                  deepStats.add(DeepStat(name: element.name, value: 0));
                }
              });
            } else {
              allSkills[allSkillIndex].elements!.forEach((element) {
                deepStats.add(DeepStat(name: element.name, value: 0));
              });
            }
          }

          return (widget.chartType == 'physical' || widget.chartType == 'golf')
              ? Column(
                  children: [
                    if (widget.chartType == 'golf' &&
                        profileState.handicap == null)
                      Text(
                        "Remember to set your handicap!",
                        style: TextStyle(color: Colors.white),
                      ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            //return SpiderChartPage(deepStats: deepStats);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: CustomRadarChart(
                                  chartType: widget.chartType,
                                  values: deepStats
                                      .map<double?>((e) => e.value)
                                      .toList(),
                                  values2: getSkillHandicapValues(
                                      allSkills,
                                      profileState.handicap,
                                      overallPhysicalBenchmark),
                                  labels: deepStats
                                      .map<String?>((e) => e.name)
                                      .toList()),
                            );
                          } else if (index == 1) {
                            return BarChartPage(
                              deepStats: deepStats,
                              shouldShowSub:
                                  widget.chartType == 'golf' ? true : false,
                              chartType: widget.chartType,
                            );
                          } else {
                            return DonutChartPage(
                                deepStats: deepStats,
                                nestedStatType: _nestedStatType);
                          }
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    dotsScroll(),
                  ],
                )
              : DonutChartPage(
                  deepStats: deepStats,
                  nestedStatType: _nestedStatType,
                );
        },
      ),
    );
  }

  Widget dotsScroll() {
    return Container(
      height: 30,
      // color: ,
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: DotsScrollViewIndicator(
          controller: _pageController,
          itemCount: 3,
          onPageSelected: (int index) {
            _pageController.animateToPage(index,
                duration: _kDuration, curve: _kCurve);
          },
        ),
      ),
    );
  }
}
