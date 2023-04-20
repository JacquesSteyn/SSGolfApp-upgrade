import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/bottom_navbar.dart';
import 'package:ss_golf/app/home/home_view.dart';
import 'package:ss_golf/app/profile/profile_view.dart';
import 'package:ss_golf/app/stats/stats_view.dart';
import 'package:ss_golf/app/tickets/ticket_main.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/bottom_navbar_index.provider.dart';

import 'app_router.dart';

class AppRoot extends ConsumerStatefulWidget {
  final String? userId;
  final bool isSignUp;
  AppRoot({this.userId, this.isSignUp = false});

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  @override
  void initState() {
    super.initState();
    // initialize app state
    ref.read(appStateProvider.notifier).initAppState(widget.userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isSignUp == true) {
        Get.toNamed(AppRoutes.subscription);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Consumer(
        builder: (context, ref, child) {
          final navbarIndex = ref.watch(indexStateProvider);

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
        return TicketMainScreen();
      case 3:
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
