// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ss_golf/app/home/submit/score_view.dart';
// import 'package:ss_golf/app/home/submit/video_player_screen.dart';
// import 'package:ss_golf/shared/models/challenge.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class TabSwitcher extends StatefulWidget {
//   // TabSwitcher();

//   @override
//   _TabSwitcherState createState() => _TabSwitcherState();
// }

// class _TabSwitcherState extends State<TabSwitcher> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           tabItem(performState, ProfileMode.User, 'Instructions'),
//           tabItem(performState, ProfileMode.Physical, 'Tips + Advice'),
//           tabItem(performState, ProfileMode.Golf, 'Score'),
//         ],
//       ),
//     );
//   }

//   Widget tabItem(performState, ProfileMode mode, String text) {
//     final bool tabIsSelected = performState.viewMode == mode;
//     return InkWell(
//       onTap: () {
//         context.read(performStateProvider).switchViewMode(mode);
//       },
//       child: Text(
//         text,
//         style: TextStyle(
//           color: tabIsSelected ? Colors.white : Colors.grey,
//           fontWeight: FontWeight.bold,
//           fontSize: tabIsSelected ? 17 : 15,
//         ),
//       ),
//     );
//   }
// }

// enum ProfileMode { User, Physical, Golf }

// class ProfileState extends ChangeNotifier {
//   ProfileMode _profileMode = ProfileMode.User;

//   ProfileMode get profileMode => _profileMode;
//   void switchProfileMode(ProfileMode mode) {
//     _profileMode = mode;
//     notifyListeners();
//   }
// }

// final profileStateProvider = ChangeNotifierProvider((ref) => ProfileState());
