import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/landing/landing_page.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/state/app.provider.dart';
import 'package:ss_golf/state/auth.provider.dart';
import 'package:ss_golf/state/bottom_navbar_index.provider.dart';
import '../../shared/icons/custom_icons.dart' as CustomIcons;
import 'package:url_launcher/url_launcher.dart';

class Settings extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userState = watch(userStateProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Settings',
        showActions: false,
      ),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                settingsButton(() {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) => premiumFeaturesDialog(),
                  );
                }, Icons.payment_outlined, 'Free plan'),
                settingsButton(() {
                  userState.resetPasswordByEmail();
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) =>
                        passwordResetEmailSentDialog(),
                  );
                }, Icons.security, 'Reset password'),
                settingsButton(() async {
                  context.read(indexStateProvider).setIndex(0);
                  Get.offAll(LandingPage());
                  context.read(profileStateProvider).resetProfile();
                  context.read(appStateProvider).resetAppState();
                  userState.logout();
                }, Icons.exit_to_app_sharp, 'Log out'),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                aboutTheApp(),
                socialLinks(),
              ],
            ),
            Expanded(
              child: privacyPolicy(),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordResetEmailSentDialog() {
    return AlertDialog(
      title: Text(
        'Please check your email.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            return Get.back();
          },
        ),
      ],
    );
  }

  Widget premiumFeaturesDialog() {
    return AlertDialog(
      title: Text(
        'Premium features coming soon.',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            return Get.back();
          },
        ),
      ],
    );
  }

  Widget socialLinks() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          socialMediaButton(
            'https://www.facebook.com/smart.statss',
            Icon(
              CustomIcons.CustomIcons.facebook,
              color: Colors.white,
            ),
          ),
          socialMediaButton(
            'https://twitter.com/SmartStats1',
            Icon(
              CustomIcons.CustomIcons.twitter,
              color: Colors.white,
            ),
          ),

          socialMediaButton(
            'https://www.instagram.com/smart.stats/',
            Icon(
              CustomIcons.CustomIcons.instagram,
              color: Colors.white,
            ),
          ),

          socialMediaButton(
            'https://www.youtube.com/channel/UCqF6rByFYdDB9JBS4kDxPIg?view_as=subscriber',
            Icon(
              CustomIcons.CustomIcons.youtube,
              color: Colors.white,
            ),
          ),

          // TODO -> clickable and links
        ],
      ),
    );
  }

  Widget socialMediaButton(String url, Icon icon) {
    return FloatingActionButton(
      child: icon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        side: BorderSide(color: Colors.black54),
      ),
      backgroundColor: Colors.transparent,
      onPressed: () {
        launch(url);
      },
    );
  }

  Widget aboutTheApp() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
            'Please leave us a rating or contact us via support@smartstats.com.\n\nFollow us on social media.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget privacyPolicy() {
    return Center(
      child: Text(
        'Privacy Policy',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget settingsButton(VoidCallback onTapMethod, iconType, String text) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey),
        ),
        color: Get.theme.accentColor,

        // elevation: 10,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // side: BorderSide(color: Colors.grey),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(100),
          // ),
          // tileColor: Get.theme.accentColor,
          leading: Icon(iconType, color: Colors.grey[300]),
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[300],
              ),
            ),
          ),
          onTap: onTapMethod,
        ),
      ),
    );
  }
}
