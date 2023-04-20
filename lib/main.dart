import 'dart:io' show Platform;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ss_golf/app/app_root.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/landing/landing_page.dart';
import 'package:ss_golf/revanuecat.dart';
import 'package:ss_golf/state/auth.provider.dart';

FirebaseAnalytics? firebaseAnalytics;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseAnalytics = FirebaseAnalytics.instance;

  if (Platform.isAndroid) {
    await Purchases.configure(RevanuecatConfig.purchasesConfigurationAndroid);
  } else {
    await Purchases.configure(RevanuecatConfig.purchasesConfigurationIOS);
  }

  SystemChrome.restoreSystemUIOverlays();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Stats Golf',
      theme: ThemeData(
        primaryColor: Color(0xFF17171A),
        appBarTheme: AppBarTheme(color: Color(0xFF222229)),
        // Color(0xFF0169FF)
        // primaryColorLight: Color(0xFF0169FF),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF0169FF), // 0561A4
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Color(0xFF222229))
            .copyWith(background: Color(0xFF0169FF)),
      ),
      // darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black),
      home: AuthWidget(),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}

class AuthWidget extends ConsumerWidget {
  final bool isSignUp;
  AuthWidget({this.isSignUp = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChanges = ref.watch(authStateChangesProvider);

    return authStateChanges.when(
      data: (User? user) => _data(context, ref, user),
      loading: () => loadingScaffold(),
      error: (_, __) => Center(child: Text('TODO ERROR PAGE')),
    );
  }

  Widget _data(BuildContext context, WidgetRef ref, User? user) {
    //print('BUILD DATA AUTH STATE CHANGES: ' + user.toString());
    if (user != null) {
      // Authenticated
      return FutureBuilder(
          future: ref.watch(userStateProvider.notifier).initUser(user),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AppRoot(
                userId: user.uid,
                isSignUp: isSignUp,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }));
    }
    // Not authenticated
    return LandingPage();
  }

  Widget loadingScaffold() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
