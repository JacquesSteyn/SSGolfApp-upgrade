import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/app/bottom_navbar.dart';
import 'package:ss_golf/app/home/home_view.dart';
import 'package:ss_golf/app/profile/profile_view.dart';
import 'package:ss_golf/app/stats/stats_view.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/bottom_navbar_index.provider.dart';

class AppRoot extends StatefulWidget {
  final String userId;
  AppRoot({this.userId});

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    super.initState();
    // initialise app state
    context.read(appStateProvider).initAppState(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          final navbarIndex = watch(indexStateProvider.state);
          return getViewFromIndex(navbarIndex);
        },
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  Widget getViewFromIndex(int index) {
    switch (index) {
      case 0:
        return HomeView();
      case 1:
        return StatsView();
      case 2:
        return ProfileView();
      // case 3:
      //   return ProfileView();

      default:
        return Container(
          color: Colors.red,
          child: Center(
            child: Text('ERROR - no page'),
          ),
        );
    }
  }
}
