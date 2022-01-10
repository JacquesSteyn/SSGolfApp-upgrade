import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/submit/golf/golf_score_view.dart';
import 'package:ss_golf/app/home/submit/instructions.dart';
import 'package:ss_golf/app/home/submit/physical/physical_score_state.dart';
import 'package:ss_golf/app/home/submit/physical/physical_score_view.dart';
import 'package:ss_golf/app/home/submit/tips_and_advice.dart';
import 'package:ss_golf/app/home/submit/video_player_screen.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';

class PhysicalSubmitPage extends StatefulWidget {
  final PhysicalChallenge challenge;

  PhysicalSubmitPage({this.challenge});

  @override
  _PhysicalSubmitPageState createState() => _PhysicalSubmitPageState();
}

class _PhysicalSubmitPageState extends State<PhysicalSubmitPage> {
  String activeHandicap = "Pro";
  List<String> handicapLabels = [
    'Pro',
    '0-9',
    '10-19',
    '20-29',
    '30+',
  ];

  updateStatus(String label) {
    setState(() {
      activeHandicap = label;
    });
  }

  double getTargetVal() {
    switch (activeHandicap) {
      case 'Pro':
        return widget.challenge.benchmarks.pro.toDouble();
      case '0-9':
        return widget.challenge.benchmarks.zero_to_nine.toDouble();
      case '10-19':
        return widget.challenge.benchmarks.ten_to_nineteen.toDouble();
      case '20-29':
        return widget.challenge.benchmarks.twenty_to_twenty_nine.toDouble();
      case '30+':
        return widget.challenge.benchmarks.thirty_plus.toDouble();
    }
  }

  Widget handicapItem(String name) => GestureDetector(
        onTap: () => {updateStatus(name)},
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: name == activeHandicap ? Colors.green : Colors.white),
              borderRadius: BorderRadius.circular(200)),
          child: Center(
            child: Text(
              name,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

  Widget handicapWidget() => Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: handicapLabels.map((label) => handicapItem(label)).toList(),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.challenge.name,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Consumer(
            builder: (ctx, watch, child) {
              final physicalSubmitState = watch(physicalSubmitStateProvider);
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Target Score',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: DonutChart(
                                value: getTargetVal(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Handicap Benchmark',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: handicapWidget(),
                  ),
                  if (widget.challenge.videoUrl.isNotEmpty)
                    collapsibleVideoView(physicalSubmitState),
                  if (!physicalSubmitState.showVideo)
                    Expanded(
                      child: Column(
                        children: [
                          tabsSwitch(physicalSubmitState),
                          Divider(color: Colors.grey[300]),
                          Expanded(
                            child: Container(
                              // color: Get.theme.accentColor,
                              child: viewsSwitch(physicalSubmitState),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget collapsibleVideoView(physicalSubmitState) {
    return Column(
      children: [
        // VIDEO PLAYER
        if (physicalSubmitState.showVideo)
          VideoPlayerScreen(
            videoUrl: widget.challenge.videoUrl,
          ),
        // collapsible button
        ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          leading: Icon(Icons.ondemand_video_outlined, color: Colors.white),
          tileColor: Get.theme.accentColor.withOpacity(0.7),
          trailing: Icon(
              physicalSubmitState.showVideo
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              color: Colors.grey[300]),
          title: Text(
            physicalSubmitState.showVideo ? 'hide video' : 'show video',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[300],
            ),
          ),
          onTap: () {
            physicalSubmitState.toggleShowVideo();
          },
        ),
      ],
    );
  }

  Widget tabsSwitch(physicalSubmitState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          tabItem(physicalSubmitState, ViewMode.Score, 'Score'),
          tabItem(physicalSubmitState, ViewMode.Instructions, 'Instructions'),
          tabItem(physicalSubmitState, ViewMode.Tips, 'Tips + Advice'),
        ],
      ),
    );
  }

  Widget tabItem(physicalSubmitState, ViewMode mode, String text) {
    final bool tabIsSelected = physicalSubmitState.viewMode == mode;
    return InkWell(
      onTap: () {
        context.read(physicalSubmitStateProvider).switchViewMode(mode);
      },
      child: Text(
        text,
        style: TextStyle(
          color: tabIsSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: tabIsSelected ? 17 : 15,
        ),
      ),
    );
  }

  Widget viewsSwitch(performState) {
    switch (performState.viewMode) {
      case ViewMode.Instructions:
        return Instructions(instructions: widget.challenge.instructions);
      case ViewMode.Tips:
        return TipsAndAdvice(tips: widget.challenge.tipGroups);
      case ViewMode.Score:
        return PhysicalScoreView(challenge: widget.challenge);
      default:
        return Container(
          color: Colors.red,
        );
    }
  }
}

enum ViewMode { Instructions, Tips, Score }

class PhysicalSubmitPageState extends ChangeNotifier {
  ViewMode _viewMode = ViewMode.Score;
  bool _showVideo = false;

  ViewMode get viewMode => _viewMode;
  void switchViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  bool get showVideo => _showVideo;
  void toggleShowVideo() {
    _showVideo = !_showVideo;
    notifyListeners();
  }
}

final physicalSubmitStateProvider =
    ChangeNotifierProvider((ref) => PhysicalSubmitPageState());
