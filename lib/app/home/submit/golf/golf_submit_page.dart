import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/submit/golf/golf_score_view.dart';
import 'package:ss_golf/app/home/submit/instructions.dart';
import 'package:ss_golf/app/home/submit/tips_and_advice.dart';
import 'package:ss_golf/app/home/submit/video_player_screen.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';

class GolfSubmitPage extends StatefulWidget {
  final GolfChallenge? challenge;

  GolfSubmitPage({this.challenge});

  @override
  _GolfSubmitPageState createState() => _GolfSubmitPageState();
}

class _GolfSubmitPageState extends State<GolfSubmitPage> {
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
    print("THRESHOLD: ${widget.challenge!.benchmarks.threshold}");
    switch (activeHandicap) {
      case 'Pro':
        return widget.challenge!.benchmarks.pro.toDouble();
      case '0-9':
        return widget.challenge!.benchmarks.zero_to_nine.toDouble();
      case '10-19':
        return widget.challenge!.benchmarks.ten_to_nineteen.toDouble();
      case '20-29':
        return widget.challenge!.benchmarks.twenty_to_twenty_nine.toDouble();
      case '30+':
        return widget.challenge!.benchmarks.thirty_plus.toDouble();
      default:
        return widget.challenge!.benchmarks.thirty_plus.toDouble();
    }
  }

  Widget handicapItem(String name) => GestureDetector(
        onTap: () => {updateStatus(name)},
        child: Container(
          width: Get.width * 0.14,
          height: Get.width * 0.14,
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
        title: widget.challenge!.name,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Consumer(
            builder: (ctx, ref, child) {
              final golfSubmitViewState = ref.watch(golfSubmitStateProvider);
              double proLevel = widget.challenge!.benchmarks.pro.toDouble();
              double threshold =
                  widget.challenge!.benchmarks.threshold.toDouble();
              double total = threshold > 0
                  ? threshold
                  : proLevel > 0
                      ? proLevel
                      : 100;
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
                              width: Get.width * 0.2,
                              height: Get.width * 0.2,
                              child: DonutChart(
                                value: getTargetVal(),
                                total: total,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Get.width * 0.008),
                    child: Text(
                      'Handicap Benchmark',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Get.width * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: handicapWidget(),
                  ),
                  if (widget.challenge!.videoUrl!.isNotEmpty)
                    collapsibleVideoView(golfSubmitViewState),
                  if (!golfSubmitViewState.showVideo)
                    Expanded(
                      child: Column(
                        children: [
                          tabsSwitch(ref, golfSubmitViewState),
                          Divider(color: Colors.grey[300]),
                          Expanded(
                            child: Container(
                              // color: Get.theme.accentColor,
                              child: viewsSwitch(golfSubmitViewState),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget collapsibleVideoView(golfSubmitViewState) {
    return Column(
      children: [
        // VIDEO PLAYER
        if (golfSubmitViewState.showVideo)
          VideoPlayerScreen(
            videoUrl: widget.challenge!.videoUrl,
          ),
        // collapsible button

        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          tileColor: Get.theme.colorScheme.secondary,
          leading: Icon(Icons.ondemand_video_outlined, color: Colors.white),
          trailing: Icon(
              golfSubmitViewState.showVideo
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down,
              color: Colors.white),
          title: Text(
            golfSubmitViewState.showVideo ? 'hide video' : 'show video',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          onTap: () {
            golfSubmitViewState.toggleShowVideo();
          },
        ),
      ],
    );
  }

  Widget tabsSwitch(ref, golfSubmitViewState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          tabItem(ref, golfSubmitViewState, ViewMode.Score, 'Score'),
          tabItem(
              ref, golfSubmitViewState, ViewMode.Instructions, 'Instructions'),
          tabItem(ref, golfSubmitViewState, ViewMode.Tips, 'Tips + Advice'),
        ],
      ),
    );
  }

  Widget tabItem(ref, golfSubmitViewState, ViewMode mode, String text) {
    final bool tabIsSelected = golfSubmitViewState.viewMode == mode;
    return InkWell(
      onTap: () {
        ref.read(golfSubmitStateProvider).switchViewMode(mode);
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
        return Instructions(instructions: widget.challenge!.instructions);
      case ViewMode.Tips:
        return TipsAndAdvice(tips: widget.challenge!.tipGroups);
      case ViewMode.Score:
        return ScoreView(challenge: widget.challenge);
      default:
        return Container(
          color: Colors.red,
        );
    }
  }
}

enum ViewMode { Instructions, Tips, Score }

class GolfSubmitPageState extends ChangeNotifier {
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

final golfSubmitStateProvider =
    ChangeNotifierProvider((ref) => GolfSubmitPageState());
