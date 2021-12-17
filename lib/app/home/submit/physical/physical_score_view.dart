import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/home/submit/field_inputs.dart';
import 'package:ss_golf/app/home/submit/notes_dialog.dart';
import 'package:ss_golf/app/home/submit/physical/physical_score_state.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';
import 'package:ss_golf/shared/widgets/primary_icon_button.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/auth.provider.dart';

class PhysicalScoreView extends StatefulWidget {
  final PhysicalChallenge challenge;
  PhysicalScoreView({this.challenge});

  @override
  _PhysicalScoreViewState createState() => _PhysicalScoreViewState();
}

class _PhysicalScoreViewState extends State<PhysicalScoreView> {
  String userId;
  dynamic localScoreState;

  void _showErrorDialog(scoreState) {
    Get.defaultDialog(
      title: '',
      content: Text(scoreState.errorMessage),
      actions: [
        TextButton(
          child: Text('Ok'),
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
        builder: (context, watch, child) {
          final scoreState = watch(physicalScoreStateProvider);
          final userState = watch(userStateProvider.state)?.user;
          final appState = watch(appStateProvider.state);
          // final skills = appState.skills;
          final attributes = appState.attributes;
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
                      child: notesButton(scoreState),
                    ),
                    Expanded(
                      flex: 1,
                      child: submitButton(
                          scoreState, latestStat, attributes, skills),
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

  Widget notesButton(scoreState) {
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
            return null;
          },
        );
      },
      text: 'Notes',
      primary: false,
    );
  }

  Widget submitButton(scoreState, latestStat, attributes, skills) {
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
                  double challengeScore = await scoreState.submit(
                      userId, widget.challenge, attributes, latestStat, skills);
                  if (challengeScore != null) {
                    Get.offAndToNamed(AppRoutes.challengeResultPage,
                        arguments: {
                          'userId': userId,
                          'challengeId': widget.challenge.id,
                          'challengeName': widget.challenge.name,
                          'challengeScore': challengeScore,
                        });
                    // scoreState.resetScoreState();
                  } else {
                    _showErrorDialog(scoreState);
                  }
                },
                text: 'Submit',
              );
  }

  @override
  void dispose() {
    print('DISPOSE GOLF SCORE VIEW');
    localScoreState.resetScoreState();
    super.dispose();
  }
}
