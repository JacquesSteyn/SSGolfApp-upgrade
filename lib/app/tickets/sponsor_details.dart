import 'package:flutter/material.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';

import '../../shared/widgets/orbitron_heading.dart';

class SponsorDetails extends StatelessWidget {
  const SponsorDetails({Key? key, this.draw}) : super(key: key);

  final PromotionalDraw? draw;

  Container textContainer(String title, String content) {
    if (content.isEmpty) {
      return Container();
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            content,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: OrbitronHeading(
          title: 'About',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "${draw!.sponsorName}",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.white,
                ),
                textContainer("Who we are", draw!.sponsorWhoWeAre),
                textContainer("Our Mission", draw!.sponsorMission),
                textContainer("Our Origin", draw!.sponsorOrigin),
                textContainer("Where to find us", draw!.sponsorFindUs),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
