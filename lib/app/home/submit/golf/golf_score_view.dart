import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/home/submit/field_inputs.dart';
import 'package:ss_golf/app/home/submit/golf/golf_score_state.dart';
import 'package:ss_golf/app/home/submit/notes_dialog.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/widgets/primary_icon_button.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/auth.provider.dart';

class ScoreView extends StatefulWidget {
  final GolfChallenge? challenge;
  ScoreView({this.challenge});

  @override
  _ScoreViewState createState() => _ScoreViewState();
}

class _ScoreViewState extends State<ScoreView> {
  String? userId;
  late dynamic localScoreState;

  void _showErrorDialog(scoreState) {
    Get.defaultDialog(
      title: '', // 'Authentication failed!',
      content: Text(scoreState.errorMessage),
      actions: [
        TextButton(
          child: Text(
            'Ok',
            textAlign: TextAlign.end,
          ),
          onPressed: () {
            Get.back();
            scoreState.setErrorMessage('');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(
        builder: (context, ref, child) {
          final scoreState = ref.watch(golfScoreStateProvider);
          final userState = ref.watch(userStateProvider).user!;
          final appState = ref.watch(appStateProvider);
          final skills = appState.skills;
          final latestStat = appState.latestStat;

          localScoreState = scoreState;

          scoreState.setUserInputs(widget.challenge);
          userId = userState.id;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: FieldInputs(scoreState: scoreState)),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: iconButton(scoreState),
                    ),
                    Expanded(
                      flex: 1,
                      child: submitButton(scoreState, latestStat, skills),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget iconButton(scoreState) {
    return PrimaryIconButton(
      icon: Icon(
        Icons.note,
        color: Colors.grey,
      ),
      onPressed: () {
        print('Open note dialog!');
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
              child: NotesDialog(
                scoreState: scoreState,
              ),
            );
          },
          pageBuilder: (BuildContext context, Animation animation,
              Animation secondaryAnimation) {
            return Container();
          },
        );
      },
      text: 'Notes',
      primary: false,
    );
  }

  Widget submitButton(scoreState, latestStat, skills) {
    return scoreState.isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : scoreState.isCompleted
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                ),
              )
            : PrimaryIconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () async {
                  double? challengeScore = await scoreState.submit(
                      userId, widget.challenge, latestStat, skills);

                  if (challengeScore != null) {
                    // scoreState.resetScoreState();
                    Get.offAndToNamed(AppRoutes.challengeResultPage,
                        arguments: {
                          'userId': userId,
                          'challengeId': widget.challenge!.id,
                          'challengeName': widget.challenge!.name,
                          'challengeScore': challengeScore,
                        });
                  } else {
                    _showErrorDialog(scoreState);
                  }
                },
                text: 'Submit',
              );
  }

  @override
  void dispose() {
    print('DISPOSE GOLF SCORE VIEWWWWW');
    localScoreState.resetScoreState();
    super.dispose();
  }
}
