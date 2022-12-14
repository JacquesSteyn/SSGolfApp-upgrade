import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/shared/widgets/neo/challenge_difficulty_rating.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';

class GolfChallengeDetailsPage extends StatefulWidget {
  final GolfChallenge? challenge;

  GolfChallengeDetailsPage({this.challenge});

  @override
  _GolfChallengeDetailsPageState createState() => _GolfChallengeDetailsPageState();
}

class _GolfChallengeDetailsPageState extends State<GolfChallengeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: widget.challenge!.name),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 2),
          child: detailsCard(),
        ),
      ),
    );
  }

  Widget detailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            descriptionContent(),
            difficultyContent(),
            purposeContent(),
            equipmentContent(),
            startButton(),
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
          child: ChallengeDifficultyRating(
            difficultyRating: double.parse(widget.challenge!.difficulty!),
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
      equipmentContent.add(subTitle('•  $text'));
    });
    return Column(
      children: equipmentContent,
    );
  }

  Widget startButton() {
    return Column(
      children: [
        SizedBox(height: 10),
        Divider(color: Colors.grey[200]),
        SizedBox(height: 5),
        PrimaryButton(
          text: 'Start',
          onPressed: () {
            Get.toNamed(AppRoutes.golfChallengeSubmitPage, arguments: widget.challenge);
          },
        ),
        SizedBox(height: 10),
      ],
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
      padding: const EdgeInsets.fromLTRB(20, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
