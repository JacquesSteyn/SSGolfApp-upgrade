import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_root.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/landing/landing_page.dart';
import 'package:ss_golf/state/auth.provider.dart';

FirebaseAnalytics firebaseAnalytics;

Future<void> main() async {
  firebaseAnalytics = FirebaseAnalytics();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        primaryColor: Color(0xFF17171A), // Colors.black,
        accentColor: Color(0xFF222229),
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
  Widget build(BuildContext context, ScopedReader watch) {
    final authStateChanges = watch(authStateChangesProvider);

    return authStateChanges.when(
      data: (User user) => _data(context, user),
      loading: () => loadingScaffold(),
      error: (_, __) => Center(child: Text('TODO ERROR PAGE')),
    );
  }

  Widget _data(BuildContext context, User user) {
    print('BUILD DATA AUTH STATE CHANGES: ' + user.toString());
    if (user != null) {
      // Authenticated
      context.read(userStateProvider).initUser(user);
      return AppRoot(userId: user.uid);
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
