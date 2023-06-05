import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/shared/widgets/orbitron_heading.dart';
import 'package:get/get.dart';
import 'package:ss_golf/state/auth.provider.dart';
import 'package:ss_golf/state/draws.provider.dart';

import '../../shared/models/draws/transaction.dart';

class TicketMainScreen extends ConsumerStatefulWidget {
  const TicketMainScreen({Key? key}) : super(key: key);

  @override
  _TicketMainScreenState createState() => _TicketMainScreenState();
}

class _TicketMainScreenState extends ConsumerState<TicketMainScreen> {
  final customDateFormat = DateFormat('MMMM d, y H:m');

  @override
  void initState() {
    super.initState();
    ref.read(drawStateProvider.notifier).initDrawsState();
  }

  shadowContainer(String heading, Widget child) => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              heading,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.textScaleFactor * 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: Get.width * 0.97,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  blurRadius: 15.0,
                  color: Color.fromARGB(111, 255, 255, 255),
                )
              ],
            ),
            child: child,
          ),
        ],
      );

  Widget transactionImage(String? type) {
    if (type == 'check-in') {
      return Image.asset('assets/images/calender.png');
    } else if (type == 'challenge') {
      return Image.asset('assets/images/golf_flag.png');
    } else if (type == '3day') {
      return Image.asset('assets/images/flame.png');
    } else if (type == 'spent') {
      return Container();
    } else {
      return Image.asset('assets/images/gift.png');
    }
  }

  Widget earningSummery(String? userID) {
    DataService _db = DataService();
    Widget child = FutureBuilder(
      future: _db.fetchUserTodayTransaction(userID, false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> result = snapshot.data as Map<String, dynamic>;
            UserTransaction? transaction = result['transaction'] != null
                ? result['transaction'] as UserTransaction?
                : null;
            double? total =
                result['total'] != null ? result['total'] as double? : 0;
            if (transaction != null) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            'Earned',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.textScaleFactor * 12,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Text(
                            '+',
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: Get.textScaleFactor * 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Image.asset('assets/images/ticket_gold.png',
                              width: Get.width * 0.06),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Text(
                            total!.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: Get.textScaleFactor * 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(87, 255, 255, 255),
                            ),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: transactionImage(transaction.type),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: 160),
                                width: Get.width * 0.5,
                                child: Text(
                                  transaction.name!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.textScaleFactor * 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '+ ' + transaction.price!.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.ticketHistory);
                    },
                    child: Container(
                      width: Get.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(87, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'See All Transactions',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Text(
                    "Nothing to show today",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.ticketHistory);
                    },
                    child: Container(
                      width: Get.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(87, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'See All Transactions',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Column(
              children: [
                Text(
                  "Nothing to show today",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.ticketHistory);
                  },
                  child: Container(
                    width: Get.width * 0.8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(87, 255, 255, 255),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'See All Transactions',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );

    return shadowContainer('Earning Summery', child);
  }

  Widget spendingSummery(String? userID) {
    DataService _db = DataService();
    Widget child = FutureBuilder(
      future: _db.fetchUserTodayTransaction(userID, true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map<String, dynamic> result = snapshot.data as Map<String, dynamic>;
            UserTransaction? transaction = result['transaction'] != null
                ? result['transaction'] as UserTransaction?
                : null;
            double? total =
                result['total'] != null ? result['total'] as double? : 0;
            if (transaction != null) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            'Spent',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Get.textScaleFactor * 12,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Text(
                            '-',
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: Get.textScaleFactor * 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Image.asset('assets/images/ticket_gold.png',
                              width: Get.width * 0.06),
                          SizedBox(
                            width: Get.width * 0.01,
                          ),
                          Text(
                            total!.toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: Get.textScaleFactor * 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(87, 255, 255, 255),
                            ),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: transactionImage(transaction.type),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(maxWidth: 160),
                                width: Get.width * 0.5,
                                child: Text(
                                  "${transaction.name} Draw",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Get.textScaleFactor * 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '- ' + transaction.price!.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.ticketHistory);
                    },
                    child: Container(
                      width: Get.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(87, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'See All Transactions',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Text(
                    "Nothing to show today",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.ticketHistory);
                    },
                    child: Container(
                      width: Get.width * 0.8,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(87, 255, 255, 255),
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        'See All Transactions',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }
          } else {
            return Column(
              children: [
                Text(
                  "Nothing to show today",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.ticketHistory);
                  },
                  child: Container(
                    width: Get.width * 0.8,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(87, 255, 255, 255),
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      'See All Transactions',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
      },
    );

    return shadowContainer('Spending History', child);
  }

  var howToEarnContainer = GestureDetector(
    onTap: () {
      Get.toNamed(AppRoutes.earnMore);
    },
    child: Container(
      width: Get.width,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color.fromARGB(87, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("assets/images/earn_coins.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.6), BlendMode.dstATop),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'How to Earn Golf Coins',
          maxLines: 1,
          style: TextStyle(
              color: Colors.white,
              fontSize: Get.textScaleFactor * 20,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'There are many ways to earn some Golf Coins',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Color.fromARGB(87, 255, 255, 255),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            'Earn More',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Get.textScaleFactor * 14,
            ),
          ),
        ),
      ]),
    ),
  );

  Widget earWidget() => GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.openDraws);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Color.fromARGB(87, 255, 255, 255),
              image: DecorationImage(
                  image: AssetImage('assets/images/spend_ticket.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop)),
              borderRadius: BorderRadius.circular(10)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Spend Golf',
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.textScaleFactor * 14,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Coins',
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.textScaleFactor * 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(87, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Spend Coins',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.textScaleFactor * 14,
                ),
              ),
            ),
          ]),
        ),
      );

  Widget spendWidget() => GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.redeem);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Color.fromARGB(87, 255, 255, 255),
              image: DecorationImage(
                  image: AssetImage('assets/images/redeem_pig.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.6), BlendMode.dstATop)),
              borderRadius: BorderRadius.circular(10)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Redeem BONUS Golf Coins',
              maxLines: 2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Get.textScaleFactor * 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color.fromARGB(87, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                'Redeem',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: Get.textScaleFactor * 14,
                ),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final drawState = ref.watch(drawStateProvider);
    UserProfile? userState = ref.watch(userStateProvider).user;

    String? userBalance = userState?.balance != null
        ? userState?.balance?.toStringAsFixed(2)
        : '0.00';

    if (drawState.isLoading) {
      return SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  OrbitronHeading(
                    title: 'Balance',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(3.0, 3.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(218, 245, 244, 164),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: userState!.plan == 'free'
                              ? Image.asset('assets/images/ticket_plat.png')
                              : Image.asset('assets/images/ticket_gold.png'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        userBalance!,
                        style: GoogleFonts.orbitron(
                          textStyle: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(3.0, 2.0),
                                  blurRadius: 4.0,
                                  color: Color.fromARGB(143, 245, 244, 164),
                                ),
                              ],
                              color: userState.plan == 'free'
                                  ? Color.fromARGB(255, 200, 183, 145)
                                  : Colors.yellow[700],
                              fontSize: Get.textScaleFactor * 40,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (userState.plan == "free")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.subscription);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(218, 255, 255, 255),
                                ),
                              ],
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 16),
                                child: Text(
                                  'GO PRO',
                                  style: TextStyle(
                                      color: Colors.yellow[700],
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.yourTickets);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(218, 255, 255, 255),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ImageIcon(
                                    AssetImage('assets/images/ticket_icon.png'),
                                    color: Colors.yellow[700],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Your Tickets',
                                    style: TextStyle(
                                        color: Colors.yellow[700],
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.yourTickets);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 10.0,
                              color: Color.fromARGB(218, 255, 255, 255),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/ticket_icon.png'),
                                color: Colors.yellow[700],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Your Tickets',
                                style: TextStyle(
                                    color: Colors.yellow[700],
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: earWidget()),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(child: spendWidget()),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  howToEarnContainer,
                  SizedBox(
                    height: 20,
                  ),
                  earningSummery(userState.id),
                  SizedBox(
                    height: 20,
                  ),
                  spendingSummery(userState.id),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
