import 'package:flutter/material.dart';
import 'package:ss_golf/app/app_root.dart';
import 'package:ss_golf/app/home/details/golf_challenge_details_page.dart';
import 'package:ss_golf/app/home/details/physical_challenge_details_page.dart';
import 'package:ss_golf/app/home/select/physical/select_physical_challenge_page.dart';
import 'package:ss_golf/app/home/submit/physical/physical_submit_page.dart';
import 'package:ss_golf/app/home/submit/result_page.dart';
import 'package:ss_golf/app/home/submit/golf/golf_submit_page.dart';
import 'package:ss_golf/app/home/select/golf/select_golf_challenge_page.dart';
import 'package:ss_golf/app/home/select/select_element_attribute_page.dart';
import 'package:ss_golf/app/tickets/all_entries.dart';
import 'package:ss_golf/app/tickets/draw_rules.dart';
import 'package:ss_golf/app/tickets/earn_more.dart';
import 'package:ss_golf/app/tickets/open_draws.dart';
import 'package:ss_golf/app/tickets/redeem.dart';
import 'package:ss_golf/app/tickets/sponsor_details.dart';
import 'package:ss_golf/app/tickets/subscription_screen.dart';
import 'package:ss_golf/app/tickets/ticket_details.dart';
import 'package:ss_golf/app/tickets/ticket_history.dart';
import 'package:ss_golf/app/tickets/ticket_main.dart';
import 'package:ss_golf/app/tickets/your_tickets.dart';
import 'package:ss_golf/landing/landing_page.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/models/draws/ticket.dart';

import '../shared/models/golf/golf_challenge.dart';
import '../shared/models/golf/skill.dart';
import '../shared/models/physical/physical_challenge.dart';

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

  // Ticket
  static const ticketMain = '/main-ticket';
  static const yourTickets = '/your-tickets';
  static const earnMore = '/earn-more';
  static const ticketDetails = '/ticket-details';
  static const drawRules = '/draw-rules';
  static const allEntries = '/all-entries';
  static const sponsorDetails = '/sponsor-details';
  static const redeem = '/redeem';
  static const openDraws = '/openDraws';
  static const ticketHistory = '/ticketHistory';
  static const subscription = '/subscription';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
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
          builder: (_) => SelectElementAttributePage(skill: args as Skill?),
        );

      // *** CHALLENGE SELECT
      case AppRoutes.selectGolfChallengesPage:
        final mapArgs = args as Map<String, dynamic>;
        final title = mapArgs['title'] as String?;
        final skillIdElementId = mapArgs['skillIdElementId'] as String?;
        return MaterialPageRoute(
          builder: (_) => SelectGolfChallengePage(
            title: title,
            skillIdElementId: skillIdElementId,
          ),
        );
      case AppRoutes.selectPhysicalChallengesPage:
        final mapArgs = args as Map<String, dynamic>;
        final title = mapArgs['title'] as String?;
        final attributeId = mapArgs['attributeId'] as String?;
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
            challenge: args as GolfChallenge?,
          ),
        );
      case AppRoutes.physicalChallengeDetailsPage:
        return MaterialPageRoute(
          builder: (_) => PhysicalChallengeDetailsPage(
            challenge: args as PhysicalChallenge?,
          ),
        );

      // *** CHALLENGE SUBMIT
      case AppRoutes.golfChallengeSubmitPage:
        return MaterialPageRoute(
          builder: (_) => GolfSubmitPage(
            challenge: args as GolfChallenge?,
          ),
        );
      case AppRoutes.physicalChallengeSubmitPage:
        return MaterialPageRoute(
          builder: (_) => PhysicalSubmitPage(
            challenge: args as PhysicalChallenge?,
          ),
        );

      // ***CHALLENGE RESULT
      case AppRoutes.challengeResultPage:
        final mapArgs = args as Map<String, dynamic>;
        final userId = mapArgs['userId'] as String?;
        final challengeId = mapArgs['challengeId'] as String?;
        final challengeName = mapArgs['challengeName'] as String?;
        final challengeScore = mapArgs['challengeScore'] as double?;
        return MaterialPageRoute(
          builder: (_) => ResultPage(
            userId: userId,
            challengeId: challengeId,
            challengeName: challengeName,
            challengeScore: challengeScore,
          ),
        );

      // ***TICKETS
      case AppRoutes.ticketMain:
        return MaterialPageRoute(
          builder: (_) => TicketMainScreen(),
        );
      case AppRoutes.yourTickets:
        return MaterialPageRoute(
          builder: (_) => YourTickets(),
        );
      case AppRoutes.earnMore:
        return MaterialPageRoute(
          builder: (_) => EarnMore(),
        );
      case AppRoutes.ticketDetails:
        return MaterialPageRoute(
          builder: (_) => TicketDetails(),
        );

      case AppRoutes.drawRules:
        {
          final mapArgs = args as List<String>?;
          return MaterialPageRoute(
            builder: (_) => DrawRules(rules: mapArgs),
          );
        }
      case AppRoutes.allEntries:
        {
          final mapArgs = args as List<PromotionalTicket>?;
          return MaterialPageRoute(
            builder: (_) => AllEntries(
              tickets: mapArgs,
            ),
          );
        }
      case AppRoutes.sponsorDetails:
        {
          final mapArgs = args as PromotionalDraw?;

          return MaterialPageRoute(
            builder: (_) => SponsorDetails(
              draw: mapArgs,
            ),
          );
        }
      case AppRoutes.redeem:
        return MaterialPageRoute(
          builder: (_) => Redeem(),
        );
      case AppRoutes.openDraws:
        return MaterialPageRoute(
          builder: (_) => OpenDraws(),
        );
      case AppRoutes.ticketHistory:
        return MaterialPageRoute(
          builder: (_) => TicketHistoryScreen(),
        );
      case AppRoutes.subscription:
        return MaterialPageRoute(
          builder: (_) => SubscriptionScreen(),
        );
      default:
        return null;
    }
  }
}
