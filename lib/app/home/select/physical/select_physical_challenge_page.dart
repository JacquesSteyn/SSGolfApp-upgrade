import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/select/physical/physical_challenge_card.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';

class SelectPhysicalChallengePage extends StatefulWidget {
  final String title;
  final String attributeId;

  SelectPhysicalChallengePage({this.title, this.attributeId});

  @override
  _SelectPhysicalChallengePageState createState() =>
      _SelectPhysicalChallengePageState();
}

class _SelectPhysicalChallengePageState
    extends State<SelectPhysicalChallengePage> {
  final DataService _dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: widget.title),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: challengesStream(),
        ),
      ),
    );
  }

  Widget challengesStream() {
    return StreamBuilder(
      stream: _dataService.streamedChallenges(
          false, 'attributeId', widget.attributeId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          // print('DATA: ' + snap.data.snapshot.value.toString());

          Map rawChallengeData = snap.data.snapshot.value;
          List<PhysicalChallengeCard> challengeCards = [];

          rawChallengeData.keys.forEach((key) => challengeCards.add(
              PhysicalChallengeCard(
                  challenge: PhysicalChallenge(rawChallengeData[key], key))));

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: Get.width * 0.0018,
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

          // Text(
          //   "SUCCCESSS",
          //   style: TextStyle(color: Colors.white),
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
