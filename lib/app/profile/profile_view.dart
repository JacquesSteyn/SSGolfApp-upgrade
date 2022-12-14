import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/app/profile/golf_profile_view.dart';
import 'package:ss_golf/app/profile/physical_profile_view.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/app/profile/save_button.dart';
import 'package:ss_golf/app/profile/settings.dart';
import 'package:ss_golf/app/profile/user_profile_view.dart';
import 'package:ss_golf/state/auth.provider.dart';

class ProfileView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider).user;
    final profileState = ref.watch(profileStateProvider);
    // init
    profileState.initProfile(userState);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      color: Colors.black,
      child: SafeArea(
        child: Consumer(
          builder: (ctx, ref, child) {
            final profileState = ref.watch(profileStateProvider);
            return Column(
              children: [
                editableUserImage(profileState),
                tabsSwitch(profileState),
                Divider(
                  color: Colors.grey,
                ),
                Expanded(child: viewsSwitch(profileState)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget editableUserImage(profileState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 10),
      // color: Colors.orange,
      child: Stack(
        children: [
          if (profileState?.profileChangesMade)
            Align(
              alignment: Alignment.bottomLeft,
              child: SaveButton(
                onPressed: profileState.updateUserProfile,
                isLoading: profileState.isLoading,
                isSaved: profileState?.profileChangesSaved,
              ),
            ),
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: Container(
                color: Colors.white,
                width: Get.size.height * 0.15,
                height: Get.size.height * 0.15,
                child: (profileState != null &&
                        profileState.imageUrl != null &&
                        profileState.imageUrl.isNotEmpty)
                    ? Image.network(
                        profileState?.imageUrl,
                        fit: BoxFit.fill,
                      )
                    : Image.asset('assets/images/default_image.png',
                        fit: BoxFit.scaleDown),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.35, 0.4),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Get.theme.colorScheme.secondary.withOpacity(0.8),
              ),
              child: IconButton(
                // padding: const EdgeInsets.all(5.0),
                icon: Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  // size: 15,
                ),
                onPressed: profileState?.uploadImage,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0.9, 0),
            child: Container(
                padding: const EdgeInsets.only(top: 15),
                child: settingsButton()),
          ),
        ],
      ),
    );
  }

  Widget settingsButton() {
    return GestureDetector(
      onTap: () => showGeneralDialog(
        barrierDismissible: false,
        context: Get.context!,
        barrierColor: Colors.black87,
        transitionDuration: Duration(milliseconds: 200),
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.decelerate,
                reverseCurve: Curves.easeOutCubic),
            child: Settings(),
          );
        },
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Container();
        },
      ),
      child: Icon(
        Icons.settings,
        color: Colors.grey,
        size: 30,
      ),
    );
  }

  Widget tabsSwitch(profileState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          tabItem(profileState, ProfileMode.User, 'User'),
          tabItem(profileState, ProfileMode.Physical, 'Physical'),
          tabItem(profileState, ProfileMode.Golf, 'Golf'),
        ],
      ),
    );
  }

  Widget tabItem(profileState, ProfileMode mode, String text) {
    final bool tabIsSelected = profileState.profileMode == mode;
    return InkWell(
      onTap: () {
        profileState.switchProfileMode(mode);
      },
      child: Container(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          text,
          style: TextStyle(
            color: tabIsSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: tabIsSelected ? 17 : 15,
          ),
        ),
        // decoration: BoxDecoration(
        //   border: Border(
        //     bottom: BorderSide(
        //       color: tabIsSelected ? Colors.white : Colors.grey.withOpacity(0.2),
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Widget viewsSwitch(profileState) {
    switch (profileState.profileMode) {
      case ProfileMode.User:
        return UserProfileView();
      case ProfileMode.Physical:
        return PhysicalProfileView();
      case ProfileMode.Golf:
        return GolfProfileView();
      default:
        return Container(
          color: Colors.red,
        );
    }
  }
}
