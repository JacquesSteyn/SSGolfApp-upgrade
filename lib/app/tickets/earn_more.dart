import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/orbitron_heading.dart';

class EarnMore extends StatelessWidget {
  const EarnMore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container earnItem(
            {required String image,
            required String title,
            required String content,
            String? route,
            bool isLink = false}) =>
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Color.fromARGB(111, 82, 82, 82),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Image.asset(image),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: Get.width * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      content,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      if (route != null) {
                        Get.toNamed(route);
                      }
                      if (isLink) {
                        Uri url = Uri(
                          scheme: 'https',
                          host: 'www.smartstats.co.za',
                          path:
                              '/smart-stats-rewards-program-terms-conditions/',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(87, 255, 255, 255),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: OrbitronHeading(
          title: 'Earn More',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/blue_lines.jpg'),
                    ),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need More Coins?',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Check out the options below to earn more',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              earnItem(
                image: 'assets/images/calender.png',
                title: 'Daily Check-In',
                content: 'Earn coins by opening the app at least once a day',
                route: AppRoutes.redeem,
              ),
              earnItem(
                  image: 'assets/images/golf_flag.png',
                  title: 'Enter Challenge Scores',
                  content:
                      'Earn coins for each challenge completed (Max 2/day)',
                  route: AppRoutes.redeem),
              earnItem(
                image: 'assets/images/flame.png',
                title: 'Complete Check-In Streaks',
                content: 'Check-In on consecutive days to earn extra coins',
                route: AppRoutes.redeem,
              ),
              earnItem(
                image: 'assets/images/gift.png',
                title: 'Redeem Voucher Codes',
                content:
                    'Look out for promotions or win voucher codes from our online and live events',
                route: AppRoutes.redeem,
              ),
              earnItem(
                image: 'assets/images/ticket_gold.png',
                title: 'How to use your coins?',
                content:
                    'Buy entries into draws for some awesome physical and digital prizes',
                route: AppRoutes.openDraws,
              ),
              earnItem(
                  image: 'assets/images/magnifier.png',
                  title: 'Terms of Use and Draws',
                  content:
                      'See Terms and Conditions about the use of coins and draw',
                  isLink: true),
            ],
          ),
        ),
      ),
    );
  }
}
