import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/widgets/image_carousel.dart';
import 'package:ss_golf/state/draws.provider.dart';

import '../../state/auth.provider.dart';

class OpenDraws extends ConsumerWidget {
  OpenDraws({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawState = ref.watch(drawStateProvider);
    final userState = ref.watch(userStateProvider).user;

    String? userBalance = userState?.balance != null
        ? userState?.balance?.toStringAsFixed(2)
        : '0.00';

    String? userPlan = userState != null ? userState.plan : "free";

    if (drawState.isLoading) {
      return SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    } else
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: userPlan == 'free'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(120),
                        color: Color.fromARGB(141, 125, 125, 125),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.subscription);
                        },
                        child: Text(
                          "GO PRO",
                          style: TextStyle(
                              color: Colors.yellow[700],
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              : Container(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image.asset('assets/images/ticket_gold.png',
                        width: Get.width * 0.04),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      userBalance!,
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Open Draws",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      List<PromotionalDraw> draws =
                          ref.watch(drawStateProvider).draws;

                      return draws.length == 0
                          ? Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Center(
                                child: Text(
                                  "No draws to show yet.",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: draws.length,
                              padding: EdgeInsets.only(bottom: 20),
                              itemBuilder: ((context, index) {
                                PromotionalDraw draw = draws[index];
                                return Container(
                                  padding: EdgeInsets.only(bottom: 10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 26, 26, 26),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 10.0,
                                        color:
                                            Color.fromARGB(218, 255, 255, 255),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: InkWell(
                                      onTap: (() {
                                        ref
                                            .read(drawStateProvider.notifier)
                                            .setSelectedDraw(draw);
                                        Get.toNamed(AppRoutes.ticketDetails);
                                      }),
                                      child: Column(children: [
                                        SizedBox(
                                          height: Get.height * 0.2,
                                          child: ImageCarousel(images: [
                                            draw.image1Url,
                                            draw.image2Url,
                                            draw.image3Url,
                                          ]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0, left: 12, right: 12),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              draw.name!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              userPlan == 'free' &&
                                                      draw.drawType != "free"
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Unavailable",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Cost",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                'assets/images/ticket_gold.png',
                                                                width:
                                                                    Get.width *
                                                                        0.04),
                                                            SizedBox(
                                                              width: 2,
                                                            ),
                                                            Text(
                                                              draw.ticketPrice !=
                                                                      null
                                                                  ? draw
                                                                      .ticketPrice!
                                                                      .toStringAsFixed(
                                                                          2)
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .yellow[
                                                                      700],
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "${draw.ticketsSold}/${draw.totalTicketsIssued}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text("Tickets Sold",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 10))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
