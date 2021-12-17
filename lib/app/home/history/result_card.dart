import 'package:flutter/material.dart';
import 'package:ss_golf/app/home/history/challenge_result_dialog.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge_result.dart';
import 'package:ss_golf/shared/widgets/neo/challenge_difficulty_rating.dart';

class ChallengeResultCard extends StatefulWidget {
  final GolfChallengeResult result;
  final String type;
  ChallengeResultCard({this.result, this.type});

  @override
  _ChallengeResultCardState createState() => _ChallengeResultCardState();
}

class _ChallengeResultCardState extends State<ChallengeResultCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
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
                child: ChallengeResultDialog(
                  result: widget.result,
                ),
              );
            },
            pageBuilder: (BuildContext context, Animation animation,
                Animation secondaryAnimation) {
              return null;
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1C1E23),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Utilities.gradedColors(widget.result.percentage),
                width: 1.2),
          ),
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: titleAndDuration(),
              ),
              Expanded(
                flex: 2,
                child: difficultyAndGolfType(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleAndDuration() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.result.challengeName == ''
                ? 'Challenge Name'
                : widget.result.challengeName,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Score: ',
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text:
                      '${Utilities.roundOffPercentageValue(widget.result.percentage)}',
                  style: TextStyle(
                      color: Utilities.gradedColors(widget.result.percentage),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget difficultyAndGolfType() {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              Utilities.formatDate(
                  DateTime.parse(widget.result.dateTimeCreated)),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Center(
            child: ChallengeDifficultyRating(
              difficultyRating: double.parse(widget.result.difficulty),
              reverse: true,
            ),
          ),
        ],
      ),
    );
  }
}
