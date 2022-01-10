import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/home/submit/feedback_dialog.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';

class ResultPage extends StatefulWidget {
  final String challengeName;
  final String challengeId;
  final String userId;
  final double challengeScore;

  ResultPage({
    this.challengeId,
    this.challengeName,
    this.userId,
    this.challengeScore,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // final DataService _dataService = new DataService();
  bool _feedbackSubmitted = false;

  _onFeedbackSubmitted() {
    print("Feedback sumbitted!!!");
    setState(() {
      _feedbackSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Get.theme.primaryColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title('${widget.challengeName} Result'),
            // title('You scored'),
            DonutChart(
              value: widget.challengeScore,
            ),
            title('Well Done!'),
            challengeRating(),
            actions(),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  Widget actions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: Get.size.width * 0.35,
          child: PrimaryButton(
            onPressed: () {
              Get.back();
            },
            text: 'Try again',
            primary: false,
          ),
        ),
        Container(
          width: Get.size.width * 0.35,
          child: PrimaryButton(
            onPressed: () {
              Get.toNamed(AppRoutes.appRoot);
            },
            text: 'Home',
          ),
        ),
      ],
    );
  }

  Widget challengeRating() {
    return Center(
      child: _feedbackSubmitted
          ? Text(
              'Thank you for your feedback!',
              style: TextStyle(color: Colors.white),
            )
          : SizedBox(
              width: 200,
              child: RaisedButton(
                color: Colors.black,
                onPressed: () {
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
                        child: FeedbackDialog(
                          feedbackSubmitted: _onFeedbackSubmitted,
                          userId: widget.userId,
                          challengeId: widget.challengeId,
                        ),
                      );
                    },
                    pageBuilder: (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                      return null;
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Give feedback for this challenge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),

      // Container(
      //   // width: Get.size.width * 0.35,
      //   child: PrimaryButton(
      //     onPressed: () {},
      //     text: 'Give feedback for this challenge',
      //     primary: false,
      //   ),
      // ),
    );
  }
}
