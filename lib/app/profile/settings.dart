import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider.notifier);
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
                  Get.toNamed(AppRoutes.subscription);
                },
                    Icons.payment_outlined,
                    userState.state.user!.plan != "pro"
                        ? 'Free plan'
                        : 'Pro plan'),
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
                  ref.read(indexStateProvider.notifier).setIndex(0);
                  Get.offAll(LandingPage());
                  ref.read(profileStateProvider).resetProfile();
                  ref.read(appStateProvider.notifier).resetAppState();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: TextButton(
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    deleteAccountDialog(userState, ref))
                          },
                      child: Text(
                        "Delete Account",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                )
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

  AlertDialog deleteAccountDialog(UserState userState, ref) {
    TextEditingController passwordController = TextEditingController();
    return AlertDialog(
      title: Text('Are you sure?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'This will permanently delete all of your data associated to this account as well as the account itself!'),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Enter current password',
            ),
            obscureText: true,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => {Get.back()},
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
            onPressed: () =>
                deleteAccount(userState, passwordController.text, ref),
            child: Text(
              'Delete Account',
              style: TextStyle(
                  color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  void deleteAccount(
      UserState userState, String password, WidgetRef ref) async {
    String? errorMessage = await userState.deleteAccount(password);
    if (errorMessage == null) {
      ref.read(indexStateProvider.notifier).setIndex(0);
      Get.offAll(LandingPage());
      ref.read(profileStateProvider).resetProfile();
      ref.read(appStateProvider.notifier).resetAppState();
    }
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
            'Please leave us a rating or contact us via info@smartstats.co.za \n\nFollow us on social media.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget privacyPolicy() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "For more Terms and Conditions please read the full ",
              style: TextStyle(color: Colors.white, fontSize: 16),
              children: [
                TextSpan(
                    text: "Terms Agreement",
                    style: TextStyle(color: Colors.blue[300], fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Uri url = Uri(
                          scheme: 'https',
                          host: 'www.smartstats.co.za',
                          path: '/terms/',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }),
                TextSpan(text: " and "),
                TextSpan(
                    text: "Privacy Policy Agreement",
                    style: TextStyle(color: Colors.blue[300], fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Uri url = Uri(
                          scheme: 'https',
                          host: 'www.smartstats.co.za',
                          path: '/privacy-policy/',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }),
                TextSpan(text: " on our website."),
              ]),
        ),
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
        color: Get.theme.colorScheme.secondary,

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
