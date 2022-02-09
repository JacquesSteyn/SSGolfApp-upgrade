import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/home/details/physical_challenge_sheet.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge.dart';
import 'package:ss_golf/shared/widgets/neo/challenge_difficulty_rating.dart';

class PhysicalChallengeCard extends StatefulWidget {
  final PhysicalChallenge challenge;
  PhysicalChallengeCard({this.challenge});

  @override
  _PhysicalChallengeCardState createState() => _PhysicalChallengeCardState();
}

class _PhysicalChallengeCardState extends State<PhysicalChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.physicalChallengeSubmitPage,
              arguments: widget.challenge);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF1C1E23),
            border: Border.all(color: Colors.white),
          ),
          height: 100,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                child: widget.challenge.imageUrl == null ||
                        widget.challenge.imageUrl.isEmpty
                    ? Image.asset(
                        'assets/images/default_image.png',
                        fit: BoxFit.fitWidth,
                      )
                    : Image.network(
                        widget.challenge.imageUrl,
                        fit: BoxFit.cover,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      titleAndDuration(),
                      difficultyAnd(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleAndDuration() {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Flexible(
              child: Text(
                widget.challenge.name,
                style: TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              child: Text(
                'Duration: ${widget.challenge.duration}',
                style:
                    TextStyle(color: Get.theme.backgroundColor, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget difficultyAnd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ChallengeDifficultyRating(
          iconColor: Colors.white,
          showText: false,
          difficultyRating: double.parse(widget.challenge.difficulty),
        ),
        IconButton(
            onPressed: () => showSheet(),
            icon: Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 30,
            ))
      ],
    );
  }

  showSheet() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return PhysicalChallengeDetailsSheet(
            challenge: widget.challenge,
          );
        });
  }
}
