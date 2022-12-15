import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/shared/widgets/glow_button.dart';
import 'package:ss_golf/state/auth.provider.dart';

import '../../shared/widgets/orbitron_heading.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int pageIndex = 0;
  int monthSubIndex = 0;
  bool isLoading = false;
  String loadingMessage = "";
  String errorMessage = "";

  List<Package> packagesList = [];

  List<Map<String, String>> subList = [
    {'title': '3 Months', 'price': 'R 299.00', 'label': 'PRO - 3 Months'},
    {'title': '6 Months', 'price': 'R 499.00', 'label': 'PRO - 6 Months'},
    {'title': '12 Months', 'price': 'R 599.00', 'label': 'PRO - 12 Months'}
  ];
  UserProfile? user;

  @override
  void initState() {
    user = ref.read(userStateProvider).user;
    fetchOffers();
    if (user != null && user!.plan != null && user!.plan != "free") {
      setState(() {
        pageIndex = 1;
      });
    }
    checkTrailAllowed();
    super.initState();
  }

  void fetchOffers() async {
    final offerings = await Purchases.getOfferings();
    if (offerings.current != null) {
      setState(() {
        packagesList = offerings.current!.availablePackages;
      });
    }
  }

  void checkTrailAllowed() async {
    CustomerInfo info = await Purchases.getCustomerInfo();
    print(info.latestExpirationDate);
  }

  void startPurchase(bool trail) async {
    final userState = ref.read(userStateProvider.notifier);
    if (user != null) {
      setState(() {
        isLoading = true;
        loadingMessage = "Connecting to store..";
      });
      try {
        if (trail) {
          setState(() {
            loadingMessage = "Updating app subscription...";
          });

          await userState.updateUserPlan("pro", true);
        } else {
          CustomerInfo customerInfo =
              await Purchases.purchasePackage(packagesList[monthSubIndex]);

          if (customerInfo.entitlements.active.length > 0) {
            setState(() {
              loadingMessage = "Updating app subscription...";
            });
            await userState.updateUserPlan("pro", false);
          }
        }
        setState(() {
          isLoading = false;
          loadingMessage = "";
          errorMessage = "";
        });
      } catch (e) {
        print(e);
        setState(() {
          isLoading = false;
          errorMessage = "Something went wrong, Please try again.";
          loadingMessage = "";
        });
      }
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Something went wrong, Please try again.";
        loadingMessage = "";
      });
    }
  }

  Widget pageSelector() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pageIndex == 0
              ? GlowButton(
                  onPress: () {},
                  content: Text(
                    'Free',
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  borderRadius: 20,
                  width: 100,
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      color: Color.fromARGB(141, 125, 125, 125),
                    ),
                    child: Text(
                      "Free",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          SizedBox(
            width: 20,
          ),
          pageIndex == 1
              ? GlowButton(
                  onPress: () {},
                  content: Text(
                    'PRO',
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  borderRadius: 20,
                  width: 100,
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      color: Color.fromARGB(141, 125, 125, 125),
                    ),
                    child: Text(
                      "PRO",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
        ],
      );

  Widget proPage() => Column(
        children: [
          priceSelector(),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              listItem(
                  'assets/images/color_chart.png',
                  "In-Depth Stats and Comparisons",
                  "See your overall Golfer and Physical Scores as well as skill and attribute breakdowns with comparisons."),
              listItem(
                  'assets/images/ticket_gold.png',
                  "Earn Coins and Win Prizes",
                  "Earn Golf Coins by using the app and completing challenges so you can enter special PRO Draws."),
              listItem('assets/images/rocket.png', "Upcoming PRO Features",
                  "Stay up to date with all our upcoming updates and PRO features."),
              if (user != null &&
                  user!.plan == "free" &&
                  packagesList.length > 0 &&
                  user!.freeTrailExpireDate == null &&
                  !isLoading)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: GlowButton(
                    onPress: () {
                      if (packagesList.length > 0) {
                        monthSubIndex = 0;
                        startPurchase(true);
                      }
                    },
                    content: Text(
                      'Start 1 month trail for FREE',
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                )
            ],
          ),
        ],
      );

  Widget freePage() => Column(
        children: [
          isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        loadingMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Text(
                      "Free",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    Text(
                      "R 0.00",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 34),
                    ),
                  ],
                ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              listItem('assets/images/chart.png', "Basic Stats View",
                  "Only see your overall Golfer and Physical Scores with no further skill breakdowns and comparisons"),
              listItem('assets/images/ticket_plat.png', "Earn Coins Only",
                  "Earn Golf Coins by using the app and completing challenges so you can enter FREE Draws only"),
              listItem('assets/images/swing.png', "Unlimited Challenge Entries",
                  "Complete as many skill and physical challenges as you like to build your Golfer and Physical Scores"),
              if (user != null &&
                  user!.plan == "free" &&
                  packagesList.length > 0 &&
                  user!.freeTrailExpireDate == null &&
                  !isLoading)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: GlowButton(
                    onPress: () {
                      if (packagesList.length > 0) {
                        monthSubIndex = 0;
                        startPurchase(true);
                      }
                    },
                    content: Text(
                      'Try PRO for FREE',
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                )
            ],
          ),
        ],
      );

  Widget listItem(String image, String title, String description) => Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color.fromARGB(102, 92, 92, 92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              height: Get.width * 0.15,
              child: Image.asset(image),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    description,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget priceSelector() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(
              height: 5,
            ),
            Text(
              loadingMessage,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return packagesList.isNotEmpty
          ? Container(
              child: Column(children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: packagesList.map((package) {
                      int index = packagesList.indexOf(package);
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              monthSubIndex = index;
                            });
                          },
                          child: Text(
                            package.storeProduct.title,
                            style: TextStyle(
                                color: index == monthSubIndex
                                    ? Colors.yellow[700]
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                decoration: index == monthSubIndex
                                    ? TextDecoration.underline
                                    : TextDecoration.none),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  packagesList[monthSubIndex].storeProduct.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                Text(
                  packagesList[monthSubIndex].storeProduct.priceString,
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: GlowButton(
                    onPress: () {
                      startPurchase(false);
                    },
                    content: Text(
                      'Subscribe',
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                )
              ]),
            )
          : Center(
              child: Text(
                'No subscriptions available at the moment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile user = ref.watch(userStateProvider).user!;

    if (user == null) {
      Get.back();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: OrbitronHeading(
          title: 'Subscriptions',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                pageSelector(),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: Get.width * 0.3,
                      child: pageIndex == 0
                          ? Image.asset("assets/images/ticket_plat.png")
                          : Image.asset("assets/images/ticket_gold.png"),
                    ),
                    if ((user.plan == "free" && pageIndex == 0) ||
                        user.plan == "pro" && pageIndex == 1)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 81, 220, 57),
                              ),
                              Text(
                                'Active',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                pageIndex == 0 ? freePage() : proPage(),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
