import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ss_golf/app/app_root.dart';
import 'package:ss_golf/app/home/details/golf_challenge_details_page.dart';
import 'package:ss_golf/app/home/details/physical_challenge_details_page.dart';
import 'package:ss_golf/app/home/select/physical/select_physical_challenge_page.dart';
import 'package:ss_golf/app/home/submit/physical/physical_submit_page.dart';
import 'package:ss_golf/app/home/submit/result_page.dart';
import 'package:ss_golf/app/home/submit/golf/golf_submit_page.dart';
import 'package:ss_golf/app/home/select/golf/select_golf_challenge_page.dart';
import 'package:ss_golf/app/home/select/select_element_attribute_page.dart';
import 'package:ss_golf/landing/landing_page.dart';

class AppRoutes {
  static const landingPage = '/landing';
  static const appRoot = '/home';
  static const selectElementAttributePage = '/select-challenge-type';
  static const selectGolfChallengesPage = '/golf-challenges';
  static const selectPhysicalChallengesPage = '/physical-challenges';
  static const golfChallengeDetailsPage = '/golf-challenge-details';
  static const physicalChallengeDetailsPage = '/physical-challenge-details';
  static const golfChallengeSubmitPage = '/golf-challenge-submit';
  static const physicalChallengeSubmitPage = '/physical-challenge-submit';
  static const challengeResultPage = 'challenge-result';
  // static const
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    print('ARGS: ' + args.toString());
    switch (settings.name) {
      case AppRoutes.appRoot:
        return MaterialPageRoute(
          builder: (_) => AppRoot(),
        );
      case AppRoutes.landingPage:
        return MaterialPageRoute(
          builder: (_) => LandingPage(),
        );
      case AppRoutes.selectElementAttributePage:
        return MaterialPageRoute(
          builder: (_) => SelectElementAttributePage(skill: args),
        );

      // *** CHALLENGE SELECT
      case AppRoutes.selectGolfChallengesPage:
        final mapArgs = args as Map<String, dynamic>;
        final title = mapArgs['title'] as String;
        final skillIdElementId = mapArgs['skillIdElementId'] as String;
        return MaterialPageRoute(
          builder: (_) => SelectGolfChallengePage(
            title: title,
            skillIdElementId: skillIdElementId,
          ),
        );
      case AppRoutes.selectPhysicalChallengesPage:
        final mapArgs = args as Map<String, dynamic>;
        final title = mapArgs['title'] as String;
        final attributeId = mapArgs['attributeId'] as String;
        return MaterialPageRoute(
          builder: (_) => SelectPhysicalChallengePage(
            title: title,
            attributeId: attributeId,
          ),
        );

      // *** CHALLENGE DETAILS
      case AppRoutes.golfChallengeDetailsPage:
        return MaterialPageRoute(
          builder: (_) => GolfChallengeDetailsPage(
            challenge: args,
          ),
        );
      case AppRoutes.physicalChallengeDetailsPage:
        return MaterialPageRoute(
          builder: (_) => PhysicalChallengeDetailsPage(
            challenge: args,
          ),
        );

      // *** CHALLENGE SUBMIT
      case AppRoutes.golfChallengeSubmitPage:
        return MaterialPageRoute(
          builder: (_) => GolfSubmitPage(
            challenge: args,
          ),
        );
      case AppRoutes.physicalChallengeSubmitPage:
        return MaterialPageRoute(
          builder: (_) => PhysicalSubmitPage(
            challenge: args,
          ),
        );

      // ***CHALLENGE RESULT
      case AppRoutes.challengeResultPage:
        final mapArgs = args as Map<String, dynamic>;
        final userId = mapArgs['userId'] as String;
        final challengeId = mapArgs['challengeId'] as String;
        final challengeName = mapArgs['challengeName'] as String;
        final challengeScore = mapArgs['challengeScore'] as double;
        return MaterialPageRoute(
          builder: (_) => ResultPage(
            userId: userId,
            challengeId: challengeId,
            challengeName: challengeName,
            challengeScore: challengeScore,
          ),
        );
      default:
        return null;
    }
  }
}
