import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/history/history_filter_dialog.dart';
import 'package:ss_golf/app/home/history/history_state.dart';
import 'package:ss_golf/app/home/history/result_card.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge_result.dart';
import 'package:ss_golf/state/auth.provider.dart';

class HistoryView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider).user!;
    final historyViewState = ref.watch(historyStateProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Column(
        children: [
          tabsSwitch(historyViewState),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Get.theme.colorScheme.secondary),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => HistoryFilterDialog(),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.filter_alt_outlined, color: Colors.grey),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
              child: challengeResultsStream(historyViewState, userState.id)),
        ],
      ),
    );
  }

  Widget tabsSwitch(historyViewState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          tabItem('Skill', ChallengeTypeFilter.Golf, historyViewState),
          tabItem('Physical', ChallengeTypeFilter.Physical, historyViewState),
        ],
      ),
    );
  }

  Widget tabItem(String title, mode, historyViewState) {
    final bool tabIsSelected = historyViewState.challengeTypeFilter == mode;
    return ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Get.theme.highlightColor, width: 2))),
          backgroundColor: tabIsSelected
              ? MaterialStateProperty.all<Color>(Colors.white)
              : MaterialStateProperty.all<Color>(
                  Get.theme.colorScheme.secondary)),
      onPressed: () {
        historyViewState.setTypeFilter(mode);
        print("$mode is selected");
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(5.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color:
                tabIsSelected ? Get.theme.colorScheme.secondary : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget challengeResultsStream(historyViewState, String? userId) {
    return StreamBuilder(
      stream: historyViewState.challengeResultsStream(userId),
      builder: (context, snap) {
        if (snap.hasData && !snap.hasError && snap.data != null) {
          Map? rawChallengeData =
              (snap.data as DatabaseEvent).snapshot.value as Map?;

          List<ChallengeResultCard> challengeCards = [];

          if (rawChallengeData != null) {
            var rawChallengeDataKeys = [];
            rawChallengeDataKeys = rawChallengeData.keys.toList();
            rawChallengeDataKeys.sort((a, b) => b.compareTo(a));

            rawChallengeDataKeys.forEach((key) {
              if (historyViewState.difficultyFilter > -1) {
                // GolfChallengeResult result =
                //     GolfChallengeResult(rawChallengeData[key], key);

                if (double.parse(rawChallengeData[key]['difficulty']) ==
                    historyViewState.difficultyFilter) {
                  challengeCards.add(ChallengeResultCard(
                    result: GolfChallengeResult(rawChallengeData[key], key),
                  ));
                }
              } else {
                challengeCards.add(ChallengeResultCard(
                  result: GolfChallengeResult(rawChallengeData[key], key),
                ));
              }
            });

            // only call setstate after build method is complete
            if (challengeCards.length != historyViewState.totalResults) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print('Post frame ${challengeCards.length}');
                historyViewState.setTotalResults(challengeCards.length);
              });
            }
          }

          if (rawChallengeData == null || challengeCards.length == 0) {
            return Center(
              child: Text(
                'No completed challenges yet.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: challengeCards.length,
            itemBuilder: (context, index) {
              return challengeCards[index];
            },
          );
        }

        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // No Results
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('POST FRAME CALLBACKKKK');
          historyViewState.setTotalResults(0);
        });
        return Center(
          child: Text(
            'None',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
