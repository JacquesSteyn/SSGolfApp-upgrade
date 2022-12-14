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
import 'package:ss_golf/state/auth.provider.dart';

FirebaseAnalytics? firebaseAnalytics;

final _purchasesConfigurationIOS =
    PurchasesConfiguration("appl_yACkaxHoViRCpyivgjOqfOwScVi");

final _purchasesConfigurationAndroid =
    PurchasesConfiguration("goog_NpNslQgRkhWEWkDjsJHfKEAYByT");

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  firebaseAnalytics = FirebaseAnalytics.instance;

  if (Platform.isAndroid) {
    await Purchases.configure(_purchasesConfigurationAndroid);
  } else {
    await Purchases.configure(_purchasesConfigurationIOS);
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
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF17171A),
        // ignore: deprecated_member_use
        accentColor: Color(0xFF222229),
        appBarTheme: AppBarTheme(color: Color(0xFF222229)),
        backgroundColor: Color(0xFF0169FF),
        // Color(0xFF0169FF)
        // primaryColorLight: Color(0xFF0169FF),

        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF0169FF), // 0561A4
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.black),
      home: AuthWidget(),
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
    );
  }
}

class AuthWidget extends ConsumerWidget {
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
    print('BUILD DATA AUTH STATE CHANGES: ' + user.toString());
    if (user != null) {
      // Authenticated
      //ref.watch(userStateProvider.notifier).initUser(user);
      return FutureBuilder(
          future: ref.watch(userStateProvider.notifier).initUser(user),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AppRoot(userId: user.uid);
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
