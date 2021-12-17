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
  final String title;
  final String skillIdElementId;

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
        builder: (context, watch, child) {
          final golfChallengeState = watch(golfChallengeStateProvider);
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
    return Container(
      width: 100,
      child: RaisedButton(
        color: Get.theme.accentColor,
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) => GolfChallengeFilterDialog(),
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
                'filter',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(12.0),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
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

        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          // print('DATA: ' + snap.data.snapshot.value.toString());

          Map rawChallengeData = snap.data.snapshot.value;
          List<GolfChallengeCard> challengeCards = [];

          // print('DATA: ' + rawChallengeData.keys.toString());

          rawChallengeData.keys.forEach((key) {
            // print("TYPEEEEE: " +
            //     rawChallengeData[key]['type'].toString() +
            //     '    filter: ' +
            //     golfChallengeState.challengeTypeFilter.toString());
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
