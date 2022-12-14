import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/shared/models/draws/ticket.dart';
import 'package:ss_golf/shared/widgets/orbitron_heading.dart';

class AllEntries extends StatelessWidget {
  AllEntries({Key? key, this.tickets}) : super(key: key);

  final List<PromotionalTicket>? tickets;
  final customDateFormat = DateFormat('MMMM d, y H:m');

  Container cardContainer(PromotionalTicket ticket) => Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 92, 92, 92),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  maxRadius: 16,
                  backgroundColor: Color.fromARGB(84, 139, 139, 139),
                  child: Text(
                    ticket.userName!.substring(0, 1),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
                        ticket.userName != null ? ticket.userName! : "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      customDateFormat.format(ticket.purchaseDate!),
                      style: TextStyle(
                          color: Color.fromARGB(144, 255, 255, 255),
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            Container(
              width: Get.width * 0.4,
              padding: EdgeInsets.only(right: 10),
              child: Text(
                "#${ticket.ticketNumber}",
                maxLines: 1,
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: OrbitronHeading(
          title: 'All Entries',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tickets!.length,
            itemBuilder: (context, index) {
              if (tickets![index].id != null) {
                return cardContainer(tickets![index]);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
