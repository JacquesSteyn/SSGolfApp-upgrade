import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/app/app_router.dart';
import 'package:ss_golf/shared/models/draws/ticket.dart';
import 'package:ss_golf/shared/widgets/orbitron_heading.dart';
import 'package:get/get.dart';

import '../../shared/models/draws/promotional_draw.dart';
import '../../state/draws.provider.dart';

class YourTickets extends StatefulWidget {
  const YourTickets({Key? key}) : super(key: key);

  @override
  State<YourTickets> createState() => _YourTicketsState();
}

class _YourTicketsState extends State<YourTickets> {
  int pageIndex = 0;
  final customDateFormat = DateFormat('MMMM d, y H:mm');
  String? openDrawID = "";

  TextStyle activePageStyle(int index) {
    if (pageIndex == index) {
      return TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.underline,
      );
    } else
      return TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600);
  }

  Widget ticketContainer(PromotionalDraw draw) => Consumer(
        builder: (context, ref, child) => InkWell(
          onTap: () {
            ref.read(drawStateProvider.notifier).setSelectedDraw(draw);
            Get.toNamed(AppRoutes.ticketDetails, arguments: draw);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(85, 92, 92, 92),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: draw.image1Url != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                draw.image1Url!,
                              ),
                            )
                          : SizedBox(
                              height: 30,
                              width: 30,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: Get.width * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Draw',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            draw.name!,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Date',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            draw.drawDate != null
                                ? customDateFormat.format(draw.drawDate!)
                                : "",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${draw.tickets!.length}  X',
                                style: TextStyle(
                                    color: Colors.yellow[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ImageIcon(
                                AssetImage(
                                  'assets/images/ticket_icon.png',
                                ),
                                size: 26,
                                color: Colors.yellow[700],
                              ),
                            ],
                          ),
                          if (draw.hasWinningTicket())
                            Text(
                              'WINNER!!!',
                              style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                subTicketContainer(draw, draw.tickets)
              ],
            ),
          ),
        ),
      );

  subTicketContainer(PromotionalDraw draw, List<PromotionalTicket>? tickets) {
    if (draw.id != openDrawID) {
      return InkWell(
        onTap: (() {
          setState(() {
            openDrawID = draw.id;
          });
        }),
        child: Container(
          height: 30,
          padding: EdgeInsets.only(bottom: 5),
          alignment: Alignment.center,
          child: RotatedBox(
            quarterTurns: 3,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            InkWell(
              onTap: (() {
                setState(() {
                  openDrawID = "";
                });
              }),
              child: Container(
                width: double.infinity,
                height: 30,
                padding: EdgeInsets.only(top: 8),
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            tickets!.length == 0
                ? Center(
                    child: Text(
                      "No tickets to show yet.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: tickets.length,
                    itemBuilder: ((context, index) {
                      PromotionalTicket ticket = tickets[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(85, 92, 92, 92),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    height: 30,
                                    width: 30,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: draw.image1Url != null
                                        ? Image.network(
                                            draw.image1Url!,
                                          )
                                        : Container()),
                                SizedBox(
                                  width: 10,
                                ),
                                FittedBox(
                                  child: Text(
                                    "Ticket #${ticket.id}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  right: 8, left: 4, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(85, 92, 92, 92)),
                              child: RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: OrbitronHeading(
            title: 'Your Tickets',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                  child: Text(
                    'Upcoming',
                    style: activePageStyle(0),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                  child: Text(
                    'Completed',
                    style: activePageStyle(1),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  List<PromotionalDraw> userDraws = ref
                      .watch(drawStateProvider.notifier)
                      .getFilteredDraws(pageIndex == 0 ? 'open' : 'closed');
                  return userDraws.length == 0
                      ? Center(
                          child: Text(
                            "No tickets to show yet.",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: userDraws.length,
                          itemBuilder: ((context, index) {
                            PromotionalDraw draw = userDraws[index];
                            return ticketContainer(draw);
                          }));
                },
              ),
            ),
          ]),
        ));
  }
}
