import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/widgets/neo/challenge_difficulty_rating.dart';

class GolfChallengeDetailsSheet extends StatefulWidget {
  final GolfChallenge? challenge;

  GolfChallengeDetailsSheet({this.challenge});

  @override
  _GolfChallengeDetailsSheetState createState() =>
      _GolfChallengeDetailsSheetState();
}

class _GolfChallengeDetailsSheetState extends State<GolfChallengeDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: detailsCard(),
        ),
      ),
    );
  }

  Widget detailsCard() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 45,
              height: 8,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.challenge!.name!,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            descriptionContent(),
            difficultyContent(),
            purposeContent(),
            equipmentContent(),
          ],
        ),
      ),
    );
  }

  Widget descriptionContent() {
    return Column(
      children: [
        title('Description'),
        subTitle(widget.challenge!.description!),
      ],
    );
  }

  Widget difficultyContent() {
    return Column(
      children: [
        title('Difficulty'),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 5, 5),
            child: ChallengeDifficultyRating(
              showText: false,
              iconColor: Colors.white,
              difficultyRating: double.parse(widget.challenge!.difficulty!),
            ),
          ),
        ),
      ],
    );
  }

  Widget purposeContent() {
    return Column(
      children: [
        title('Purpose'),
        subTitle(widget.challenge!.purpose!),
      ],
    );
  }

  Widget equipmentContent() {
    List<Widget> equipmentContent = [
      title('Equipment needed'),
    ];
    widget.challenge!.equipment!.forEach((text) {
      equipmentContent.add(subTitle('$text'));
    });
    return Column(
      children: equipmentContent,
    );
  }

  Widget title(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Get.theme.backgroundColor, fontSize: 22),
      ),
    );
  }

  Widget subTitle(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
