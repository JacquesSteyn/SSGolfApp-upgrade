import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/shared/widgets/glow_button.dart';

import '../../shared/widgets/orbitron_heading.dart';
import '../../state/auth.provider.dart';

class Redeem extends ConsumerStatefulWidget {
  const Redeem({Key? key}) : super(key: key);

  @override
  _RedeemState createState() => _RedeemState();
}

class _RedeemState extends ConsumerState<Redeem> {
  final TextEditingController textController = TextEditingController();
  String errorMessage = "";
  double successPrice = 0;
  bool isLoading = false;

  @override
  void initState() {
    UserProfile? user = ref.read(userStateProvider).user;
    if (user != null) {
      ref.read(userStateProvider.notifier).updateRedeemValues(user.id!);
    }
    super.initState();
  }

  void redeemVoucher() {
    if (textController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      var user = ref.read(userStateProvider).user;
      if (user != null) {
        ref
            .read(userStateProvider.notifier)
            .redeemVoucher(textController.text, user.balance!, user.id)
            .then((value) {
          print(value);
          if (value > 0) {
            setState(() {
              errorMessage = "";
              successPrice = value;
              isLoading = false;
            });
          } else {
            setState(() {
              errorMessage = "Invalid voucher number";
              isLoading = false;
            });
          }
        }).catchError((e) {
          setState(() {
            errorMessage = e.toString();
            isLoading = false;
          });
        });
      }
    }
  }

  void redeemGift(String title, double price) {
    setState(() {
      isLoading = true;
    });
    var user = ref.watch(userStateProvider).user;
    if (user != null) {
      ref
          .read(userStateProvider.notifier)
          .redeemGift(title, price, user.balance!, user.id,
              completedChallenges: user.completedChallenges)
          .then((value) {
        if (value > 0) {
          ref.read(userStateProvider.notifier).updateRedeemValues(user.id!);
          setState(() {
            errorMessage = "";
            successPrice = value;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Something went wrong.";
            isLoading = false;
          });
        }
      }).catchError((e) {
        setState(() {
          errorMessage = "Something went wrong.";
          isLoading = false;
        });
      });
    }
  }

  bool allowRedeem(UserProfile? user, String title) {
    if (user != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateToCheck = user.lastClockInTime!;
      final aDate =
          DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

      switch (title) {
        case "Daily Check-In":
          {
            if (aDate == today && user.checkInStreak! >= 1) {
              return true;
            }
            break;
          }
        case "3 Day Check-In Streak":
          {
            if (user.redeemDay3Streak! > 0) {
              return true;
            }
            break;
          }
        case "5 Day Check-In Streak":
          {
            if (user.redeemDay5Streak! > 0) {
              return true;
            }
            break;
          }
        case "7 Day Check-In Streak":
          {
            if (user.redeemDay7Streak! > 0) {
              return true;
            }
            break;
          }
        case "Complete Challenge (1/2)":
          {
            if (user.completedChallenges >= 1 &&
                (user.lastChallengeRedemption == null ||
                    user.lastChallengeRedemption!.compareTo(today) < 0)) {
              return true;
            }
            break;
          }
        case "Complete Challenge (2/2)":
          {
            if (user.completedChallenges >= 2 &&
                (user.lastChallengeRedemptionTwo == null ||
                    user.lastChallengeRedemptionTwo!.compareTo(today) < 0)) {
              return true;
            }
            break;
          }
      }
    }
    return false;
  }

  Container redeemContainer(String title, double price, UserProfile? user) {
    bool isAllowed = allowRedeem(user, title);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(85, 92, 92, 92),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: isAllowed
                ? () => redeemGift(title, price)
                : () {
                    Get.dialog(SimpleDialog(
                      backgroundColor: Color.fromARGB(255, 90, 90, 90),
                      insetPadding: EdgeInsets.symmetric(horizontal: 30),
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey, shape: BoxShape.circle),
                              child: Text(
                                "X",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            "This Bonus can not be redeemed at this time. Please review bonus rules",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              Get.toNamed(AppRoutes.earnMore);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "How to Earn Bonus Coins",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
                  },
            child: Container(
              decoration: BoxDecoration(
                color: isAllowed
                    ? Color.fromARGB(163, 132, 132, 132)
                    : Color.fromARGB(85, 92, 92, 92),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "Redeem",
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset('assets/images/ticket_gold.png'),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    price.toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget messageBox() {
    if (successPrice > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/ticket_gold.png'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    successPrice.toStringAsFixed(2),
                    style: GoogleFonts.orbitron(
                      textStyle: TextStyle(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(3.0, 2.0),
                              blurRadius: 4.0,
                              color: Color.fromARGB(143, 245, 244, 164),
                            ),
                          ],
                          color: Colors.yellow[700],
                          fontSize: Get.textScaleFactor * 50,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Successfully Redeemed',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      );
    } else if (errorMessage.isNotEmpty) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.6,
            child: FittedBox(
              child: Text(
                errorMessage,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                errorMessage = "";
                //textController.clear();
              });
            },
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ));
    } else {
      return Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: TextFormField(
              controller: textController,
              textAlign: TextAlign.center,
              autocorrect: false,
              inputFormatters: [
                const UpperCaseTextFormatter(),
                new MaskTextInputFormatter(
                  mask: '####-####-####-####',
                  filter: {
                    "#": RegExp('[A-Z0-9]'),
                  },
                )
              ],
              cursorColor: Colors.grey,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "XXXX-XXXX-XXXX-XXXX",
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Color.fromARGB(85, 92, 92, 92),
                  filled: true,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  errorMaxLines: 1),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GlowButton(
            onPress: () {
              redeemVoucher();
            },
            content: Text(
              'Redeem Code',
              style: TextStyle(
                  color: Colors.yellow[700], fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile? currentUser = ref.watch(userStateProvider).user;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: OrbitronHeading(
          title: 'Balance',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Consumer(builder: (context, ref, child) {
              final userState = ref.watch(userStateProvider).user;

              String userBalance = (userState?.balance != null
                  ? userState?.balance!.toStringAsFixed(2)
                  : '0.00')!;

              return Column(
                children: [
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
                          width: Get.width * 0.09,
                          height: Get.width * 0.09,
                          child: Image.asset('assets/images/ticket_gold.png'),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            userBalance,
                            style: GoogleFonts.orbitron(
                              textStyle: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(3.0, 2.0),
                                      blurRadius: 4.0,
                                      color: Color.fromARGB(143, 245, 244, 164),
                                    ),
                                  ],
                                  color: Colors.yellow[700],
                                  fontSize: Get.textScaleFactor * 50,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Redeem BONUS Coins by completing certain activities in the app',
                    style: GoogleFonts.orbitron(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (!isLoading)
                    Column(
                      children: [
                        redeemContainer("Daily Check-In", 5.00, currentUser),
                        redeemContainer(
                            "Complete Challenge (1/2)", 5.00, currentUser),
                        redeemContainer(
                            "Complete Challenge (2/2)", 10.00, currentUser),
                        redeemContainer(
                            "3 Day Check-In Streak", 15.00, currentUser),
                        redeemContainer(
                            "5 Day Check-In Streak", 25.00, currentUser),
                        redeemContainer(
                            "7 Day Check-In Streak", 50.00, currentUser),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Redeem with Code',
                      style: GoogleFonts.orbitron(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(85, 92, 92, 92),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Coin Voucher Code',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (isLoading)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        if (!isLoading) messageBox(),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter implements TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
