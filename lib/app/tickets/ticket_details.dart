import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/app/tickets/purchase_popup.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/models/draws/ticket.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/shared/widgets/glow_button.dart';
import 'package:ss_golf/state/auth.provider.dart';
import 'package:ss_golf/state/draws.provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/image_carousel.dart';

class TicketDetails extends ConsumerStatefulWidget {
  const TicketDetails({Key? key}) : super(key: key);

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends ConsumerState<TicketDetails> {
  bool _aboutDrawOpen = false;
  final customDateFormat = DateFormat('MMMM d, y H:mm');

  Container headerImages(PromotionalDraw draw) => Container(
        color: Colors.white,
        height: Get.height * 0.3,
        width: double.infinity,
        child: Stack(children: [
          ImageCarousel(
            images: [
              draw.image1Url,
              draw.image2Url,
              draw.image3Url,
            ],
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 40,
              width: 40,
              margin: EdgeInsets.only(top: 10, left: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(85, 0, 0, 0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      );

  Container dateContainer(PromotionalDraw draw) => Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(children: [
          winnerContainer(draw),
          Text(
            draw.drawDate != null
                ? customDateFormat.format(draw.drawDate!)
                : "Unknown",
            style: TextStyle(
                color: Colors.white,
                overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Draw Date',
            style: TextStyle(
              color: Colors.white,
              overflow: TextOverflow.ellipsis,
              fontSize: 14,
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(39, 255, 255, 255),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      Text(
                        draw.totalTicketsIssued.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Tickets',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                  VerticalDivider(color: Colors.white),
                  Expanded(
                    child: Column(children: [
                      Text(
                        draw.getTicketsLeft().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tickets Left',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ]),
      );

  Container ticketHoldersContainer(
          PromotionalDraw passedDraw, PromotionalTicket? ticket) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Consumer(
          builder: (context, ref, child) {
            PromotionalDraw? draw =
                ref.read(drawStateProvider.notifier).getDraw(passedDraw.id!);
            if (draw == null)
              return Container();
            else
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Ticket Holders',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: '  ${draw.tickets!.length}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(85, 92, 92, 92),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            List<PromotionalTicket>? tickets = draw.tickets;
                            Get.toNamed(AppRoutes.allEntries,
                                arguments: tickets);
                          },
                          child: Text(
                            'See All',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (ticket != null)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(83, 174, 174, 174),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  maxRadius: 16,
                                  child: Text(
                                    ticket.userName!.substring(0, 1),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width * 0.32,
                                      child: Text(
                                        ticket.userName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      customDateFormat
                                          .format(ticket.purchaseDate!),
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(89, 255, 255, 255),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: Get.width * 0.4,
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "#${ticket.ticketNumber}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
          },
        ),
      );

  Container aboutDrawContainerOpen(PromotionalDraw draw) => Container(
        key: UniqueKey(),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'About this offer',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                draw.aboutOffer!,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _aboutDrawOpen = !_aboutDrawOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(85, 92, 92, 92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Show Less',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
      );

  Container aboutDrawContainerClose(PromotionalDraw draw) => Container(
        key: UniqueKey(),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'About this offer',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                draw.aboutOffer!,
                maxLines: _aboutDrawOpen ? null : 3,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _aboutDrawOpen = !_aboutDrawOpen;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(85, 92, 92, 92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Show More',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ]),
      );

  Container rulesContainer(PromotionalDraw draw) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Draw Rules',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            InkWell(
              onTap: () {
                List<String> rules = [...draw.rules ?? []];
                rules.add("TEES_CEES");
                Get.toNamed(AppRoutes.drawRules, arguments: rules);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(90, 133, 132, 132),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Container sponsorContainer(PromotionalDraw draw) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.7),
              child: Text(
                draw.sponsorName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.sponsorDetails, arguments: draw);
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(90, 133, 132, 132),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget buyContainer(PromotionalDraw draw) => GlowButton(
        onPress: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PurchasePopup(
                  draw: draw,
                );
              });
        },
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Buy Tickets from ",
              style: TextStyle(
                  color: Colors.yellow[700], fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: Image.asset('assets/images/ticket_gold.png'),
            ),
            Text(
              " " + draw.ticketPrice!.toStringAsFixed(2),
              style: TextStyle(
                  color: Colors.yellow[700], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  Widget winnerContainer(PromotionalDraw draw) {
    return FutureBuilder(
      future: draw.getTicketWinner(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            TicketWinner? winner = snapshot.data as TicketWinner?;
            if (winner != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "WINNER",
                    style: TextStyle(
                        color: Colors.green[400],
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 18,
                        backgroundColor: Color.fromARGB(84, 139, 139, 139),
                        child: Text(
                          winner.userName != null
                              ? winner.userName!.substring(0, 1)
                              : "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        winner.userName != null ? winner.userName! : "",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            } else {
              return Container();
            }
          } else
            return Container();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  String checkUrl(String url) {
    if (!url.contains("https://") || !url.contains("http://")) {
      return "http://$url";
    } else {
      return url;
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile? user = ref.read(userStateProvider).user;
    if (user == null) {
      Get.back();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Consumer(builder: (context, ref, child) {
          PromotionalDraw? draw = ref.watch(drawStateProvider).selectedDraw;
          if (draw != null) {
            return Column(
              children: [
                headerImages(draw),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              draw.name!,
                              style: TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Retail Price: R' +
                                  draw.retailPrice.toStringAsFixed(2),
                              style: TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          dateContainer(draw),
                          Divider(
                            color: Colors.white,
                            height: 30,
                          ),
                          ticketHoldersContainer(
                              draw, draw.getMostRecentTicket()),
                          Divider(
                            color: Colors.white,
                            height: 30,
                          ),
                          if (draw.drawStatus != 'closed' &&
                              user!.plan != "free")
                            Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: buyContainer(draw),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'About this Draw',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SizeTransition(
                                  sizeFactor: animation, child: child);
                            },
                            child: _aboutDrawOpen
                                ? aboutDrawContainerOpen(draw)
                                : aboutDrawContainerClose(draw),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          rulesContainer(draw),
                          SizedBox(
                            height: 10,
                          ),
                          sponsorContainer(draw),
                          Column(
                            children: [
                              Divider(
                                color: Colors.white,
                                height: 30,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Links',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                constraints:
                                    BoxConstraints(maxWidth: Get.width - 10),
                                height: 120,
                                decoration: BoxDecoration(
                                  color: draw.webImageUrl!.isEmpty
                                      ? Colors.grey[800]
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: draw.webImageUrl!.isNotEmpty
                                          ? Image.network(
                                              draw.webImageUrl ?? "",
                                              fit: BoxFit.fitHeight,
                                            )
                                          : Container(),
                                    ),
                                    if (draw.sponsorLink != null)
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            launch(checkUrl(draw.sponsorLink!));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.south_america,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "View Website",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
