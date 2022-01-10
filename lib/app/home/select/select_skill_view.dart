import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/state/app.provider.dart';

class SelectSkillView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var itemWidth = MediaQuery.of(context).size.width * 0.4;
    var itemHeight = MediaQuery.of(context).size.height * 0.225;
    final appState = watch(appStateProvider.state);

    return appState.isLoading
        ? Center(child: CircularProgressIndicator())
        : GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(10),
            children: appState.skills
                .map<Widget>((skill) => skillCard(skill, itemWidth))
                .toList(),
          );
  }

  Widget skillCard(Skill skill, double itemWidth) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          highlightColor: Color(0xFF595959),
          onTap: () {
            print('Selected: ' + skill.name.toString());
            Get.toNamed(AppRoutes.selectElementAttributePage, arguments: skill);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  color: Get.theme.accentColor, // Color(0xFF1E1E1E),
                  // Color(0xFF23252F), //  Get.theme.accentColor, //Color(0xFF232233),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Color(0xFF282828)),
                  ),
                  shadowColor: Color(0xFF454545),
                  elevation: 10,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      width: itemWidth * 0.6,
                      height: itemWidth * 0.6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/${skill.iconName}.png'),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                skill.name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}
