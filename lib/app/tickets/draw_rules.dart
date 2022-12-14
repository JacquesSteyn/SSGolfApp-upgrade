import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ss_golf/shared/widgets/orbitron_heading.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawRules extends StatelessWidget {
  const DrawRules({Key? key, this.rules}) : super(key: key);

  final List<String>? rules;

  Container numberContainer(String num) => Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromARGB(255, 33, 33, 33),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 10,
            ),
          ]),
      child: FittedBox(
        child: Text(
          num,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ));

  Container ruleContainer({required String num, required String title}) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            numberContainer(num),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 16),
                softWrap: true,
              ),
            ),
          ],
        ),
      );

  Container teesAndCeesContainer({required String num}) => Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            numberContainer(num),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                    text:
                        "For more rules, Terms and Conditions please read the full ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      TextSpan(
                          text: "Terms Agreement",
                          style:
                              TextStyle(color: Colors.blue[300], fontSize: 16),
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
                          style:
                              TextStyle(color: Colors.blue[300], fontSize: 16),
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
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: OrbitronHeading(
          title: 'Draw Rules',
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: rules!.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  if (rules![index] == "TEES_CEES") {
                    return teesAndCeesContainer(num: (index + 1).toString());
                  }
                  return ruleContainer(
                      num: (index + 1).toString(), title: rules![index]);
                }))),
      ),
    );
  }
}
