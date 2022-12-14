import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/select/golf/golf_challenge_card.dart';
import 'package:ss_golf/app/home/select/golf/golf_challenge_filter_dialog.dart';
import 'package:ss_golf/app/home/select/golf/golf_challenge_state.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';

class SelectGolfChallengePage extends StatefulWidget {
  final String? title;
  final String? skillIdElementId;

  SelectGolfChallengePage({this.title, this.skillIdElementId});

  @override
  _SelectGolfChallengePageState createState() =>
      _SelectGolfChallengePageState();
}

class _SelectGolfChallengePageState extends State<SelectGolfChallengePage> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    var itemWidth = MediaQuery.of(context).size.width * 0.4;
    var itemHeight = MediaQuery.of(context).size.height * 0.225;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: widget.title),
      body: Consumer(
        builder: (context, ref, child) {
          final golfChallengeState = ref.watch(golfChallengeStateProvider);
          return Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                //filterButton(),
                Expanded(child: challengesStream(golfChallengeState)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget filterButton() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) => GolfChallengeFilterDialog(),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.secondary,
          borderRadius: new BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.filter_alt_outlined, color: Colors.grey),
            SizedBox(
              width: 5,
            ),
            Text(
              'filter',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget challengesStream(golfChallengeState) {
    return StreamBuilder(
      stream: _dataService.streamedChallenges(
          true, 'skillIdElementId', widget.skillIdElementId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snap.hasData && !snap.hasError && snap.data != null) {
          // print('DATA: ' + snap.data.snapshot.value.toString());

          final rawChallengeData = (snap.data! as DatabaseEvent).snapshot.value
              as Map<Object?, dynamic>;

          //Map rawChallengeData = snap.data as Map<dynamic, dynamic>;
          List<GolfChallengeCard> challengeCards = [];

          rawChallengeData.keys.forEach((key) {
            if (rawChallengeData[key]['status'] == true) {
              if (golfChallengeState.challengeTypeFilter ==
                      GolfChallengeTypeFilter.Course &&
                  rawChallengeData[key]['type'] == 'course') {
                challengeCards.add(GolfChallengeCard(
                    challenge: GolfChallenge(rawChallengeData[key], key)));
              } else if (golfChallengeState.challengeTypeFilter ==
                      GolfChallengeTypeFilter.Range &&
                  rawChallengeData[key]['type'] == 'range') {
                challengeCards.add(GolfChallengeCard(
                    challenge: GolfChallenge(rawChallengeData[key], key)));
              } else if (golfChallengeState.challengeTypeFilter ==
                  GolfChallengeTypeFilter.All) {
                challengeCards.add(GolfChallengeCard(
                    challenge: GolfChallenge(rawChallengeData[key], key)));
              }
            }
          });

          if (challengeCards.length == 0) {
            return Center(
              child: Text(
                'No challenges.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1.6 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: challengeCards.length,
              itemBuilder: (BuildContext ctx, index) {
                return challengeCards[index];
              });

          // return ListView.builder(
          //   itemCount: challengeCards.length,
          //   itemBuilder: (context, index) {
          //     return challengeCards[index];
          //   },
          // );
        }

        return Center(
          child: Text(
            'No challenges yet.',
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
