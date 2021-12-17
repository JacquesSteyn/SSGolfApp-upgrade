import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/home/details/golf_challenge_sheet.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/widgets/neo/challenge_difficulty_rating.dart';

class GolfChallengeCard extends StatefulWidget {
  final GolfChallenge challenge;
  GolfChallengeCard({this.challenge});

  @override
  _GolfChallengeCardState createState() => _GolfChallengeCardState();
}

class _GolfChallengeCardState extends State<GolfChallengeCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.golfChallengeSubmitPage,
              arguments: widget.challenge);
        },
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFF1C1E23),
              border: Border.all(color: Colors.white)),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            widget.challenge.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          difficultyAndGolfType(),
                          IconButton(
                              onPressed: () => showSheet(),
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                                size: 30,
                              ))
                        ],
                      ),
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

  Widget difficultyAndGolfType() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: Text(
          //     widget.challenge.type,
          //     textAlign: TextAlign.center,
          //     style: TextStyle(color: Get.theme.backgroundColor, fontSize: 18),
          //   ),
          // ),

          Center(
            child: ChallengeDifficultyRating(
              showText: false,
              iconColor: Colors.white,
              difficultyRating: double.parse(widget.challenge.difficulty),
            ),
          ),

          // Column(
          //   children: [
          //     Text('Difficulty', style: TextStyle(color: Colors.grey[300])),
          //     RatingBar.builder(
          //       initialRating: double.parse(widget.challenge.difficulty),
          //       minRating: 0,
          //       allowHalfRating: true,
          //       itemCount: 5,
          //       itemSize: 20,
          //       unratedColor: Colors.grey,
          //       itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          //       onRatingUpdate: null,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }

  showSheet() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return GolfChallengeDetailsSheet(
            challenge: widget.challenge,
          );
        });
  }
}
