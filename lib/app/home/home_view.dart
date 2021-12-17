import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/history/history_view.dart';
import 'package:ss_golf/app/home/select/select_skill_view.dart';
import 'package:ss_golf/shared/widgets/logo.dart';
import 'package:ss_golf/state/auth.provider.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // final Shader linearGradient = LinearGradient(
  //   colors: <Color>[
  //     Color(0xFF00b09b),
  //     Color(0xFF96c93d),
  //   ], //[Color(0xFFf12711), Color(0xFFf5af19)],
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  // ).createShader(Rect.fromLTWH(0.0, 0.0, 10.0, 10.0));

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final userState = watch(userStateProvider.state)?.user;
        final viewState = watch(viewStateProvider);

        String titleText =
            userState?.name != null ? 'Hello,\n${userState?.name}' : 'Hello';

        return Container(
          color: Colors.black, //Color(0xFF1F192D),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  // color: Colors.orange,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(0.75, 0),
                        child: Logo(
                          dimension: Get.size.width * 0.25,
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.65, -0.2),
                        child: Text(titleText,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      Align(
                        alignment: Alignment(0, 0.8),
                        child: tabsSwitch(viewState),

                        // Text(
                        //   'Challenges with a Purpose',
                        //   style: new TextStyle(
                        //       fontSize: 20.0,
                        //       fontWeight: FontWeight.bold,
                        //       foreground: Paint()..shader = linearGradient),
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Center(
                  child: viewsSwitch(viewState),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget tabsSwitch(viewState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          tabItem(viewState, ViewMode.Challenges, 'Challenges'),
          tabItem(viewState, ViewMode.History, 'Score History'),
        ],
      ),
    );
  }

  Widget tabItem(viewState, ViewMode mode, String text) {
    final bool tabIsSelected = viewState.viewMode == mode;
    return GestureDetector(
      onTap: () {
        print('Home view switch: ' + text.toString());
        context.read(viewStateProvider).switchViewMode(mode);
      },
      child: Container(
        width: Get.size.width * 0.4,
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tabIsSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: tabIsSelected ? 17 : 15,
            // foreground: tabIsSelected ? (Paint()..shader = linearGradient) : null,
          ),
        ),
        decoration: BoxDecoration(
          // color: Colors.orange,
          border: Border(
            bottom: BorderSide(
              color:
                  tabIsSelected ? Colors.white : Colors.grey.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  Widget viewsSwitch(viewState) {
    switch (viewState.viewMode) {
      case ViewMode.Challenges:
        return SelectSkillView();
      case ViewMode.History:
        return HistoryView();

      default:
        return Container(
          color: Colors.red,
        );
    }
  }
}

enum ViewMode { Challenges, History }

class ViewState extends ChangeNotifier {
  ViewMode _viewMode = ViewMode.Challenges;

  ViewMode get viewMode => _viewMode;
  void switchViewMode(ViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }
}

final viewStateProvider = ChangeNotifierProvider((ref) => ViewState());
