import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/golf/skill_element.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';
import 'package:ss_golf/state/app.provider.dart';

class SelectElementAttributePage extends StatefulWidget {
  final Skill? skill;

  SelectElementAttributePage({this.skill});

  @override
  _SelectElementAttributePageState createState() =>
      _SelectElementAttributePageState();
}

class _SelectElementAttributePageState
    extends State<SelectElementAttributePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(title: widget.skill!.name),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: Get.height * 0.35,
              child: header(),
            ),
            Flexible(
              fit: FlexFit.loose,
              // flex: 3,
              child: elementAndAttributeSelection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      // color: Colors.orange,
      child: Consumer(
        builder: (context, ref, child) {
          final appState = ref.watch(appStateProvider);
          final int skillStatIndex = appState.latestStat != null
              ? appState.latestStat!.findSkillIndex(widget.skill!.id)
              : -1;
          if (skillStatIndex > -1) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment(-0.55, -0.1),
                  child: Text(
                    'Overall\nscore',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[200]),
                  ),
                ),
                Center(
                  child: DonutChart(
                      value: appState
                          .latestStat?.skillStats![skillStatIndex].value),
                )
                // Align(
                //   alignment: Alignment(-0.2, 0),
                //   // child: CustomPaint(
                //   //   painter: CustomRadialPainter(
                //   //     percentage: appState.latestStat.skillStats[skillStatIndex].value,
                //   //     dimension: Get.height * 0.25,
                //   //     strokeWidth: 15,
                //   //     color: Colors.tealAccent,
                //   //   ),
                //   // ),
                // ),
              ],
            );
          } else {
            return Center(
              child: Text(
                'Complete more challenges to get a score.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget elementAndAttributeSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        title('${widget.skill!.name} Challenges'),
        elements(),
        SizedBox(height: 10),
        title('Physical Challenges'),
        attributes(),
      ],
    );
  }

  Widget elements() {
    return Container(
      padding: const EdgeInsets.all(5), //only(top: 5, bottom: 5),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0, // gap between lines
        children: widget.skill!.elements!
            .map<Widget>((SkillElement element) => elementContainer(element))
            .toList(),
      ),
    );
  }

  Widget attributes() {
    return Container(
      padding: const EdgeInsets.all(5), // only(top: 5, bottom: 5),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10.0, // gap between lines
        children: widget.skill!.attributes!
            .map<Widget>((Attribute attribute) => attributeContainer(attribute))
            .toList(),
      ),
    );
  }

  Widget title(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  Widget elementContainer(SkillElement element) {
    return InkWell(
      onTap: () {
        String pageTitle = '${widget.skill!.name} - ${element.name}';
        String challengesRef = '${widget.skill!.id}${element.id}';
        print('On tapped: ' + challengesRef.toString());
        Get.toNamed(AppRoutes.selectGolfChallengesPage,
            arguments: {'title': pageTitle, 'skillIdElementId': challengesRef});
      },
      child: Chip(
        shape: StadiumBorder(
          side: BorderSide(
              color: Get.theme.colorScheme.secondary), // Colors.grey[700]),
        ),
        padding: const EdgeInsets.all(10),
        elevation: 1,
        label: Text(
          element.name!,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Get.theme.colorScheme.secondary,
        // .withOpacity(0.95), // Colors.blueGrey,
        shadowColor: Colors.grey[300],
      ),
    );
  }

  Widget attributeContainer(Attribute attribute) {
    return InkWell(
      onTap: () {
        String pageTitle = '${widget.skill!.name} - ${attribute.name}';
        String challengesRef = '${attribute.id}';
        print('On tapped: ' + challengesRef.toString());
        Get.toNamed(AppRoutes.selectPhysicalChallengesPage,
            arguments: {'title': pageTitle, 'attributeId': challengesRef});
      },
      child: Chip(
        shape: StadiumBorder(
          side: BorderSide(color: Get.theme.colorScheme.secondary),
        ),
        padding: const EdgeInsets.all(10),
        elevation: 1,
        label: Text(
          attribute.name!,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Get.theme.colorScheme.secondary,
        shadowColor: Colors.grey[300],
      ),
    );
  }
}
