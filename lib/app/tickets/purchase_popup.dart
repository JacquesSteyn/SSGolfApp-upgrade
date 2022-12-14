import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/widgets/glow_button.dart';

import '../../state/auth.provider.dart';
import '../../state/draws.provider.dart';

class PurchasePopup extends ConsumerStatefulWidget {
  PurchasePopup({Key? key, this.draw}) : super(key: key);

  final PromotionalDraw? draw;

  @override
  _PurchasePopupState createState() => _PurchasePopupState();
}

class _PurchasePopupState extends ConsumerState<PurchasePopup> {
  int numOfTickets = 0;
  double totalPrice = 0;
  bool processing = false;
  String message = "";

  increaseTickets() {
    if (numOfTickets < widget.draw!.maxPerUserEntries) {
      setState(() {
        numOfTickets++;
        totalPrice = numOfTickets * widget.draw!.ticketPrice!;
      });
    }
  }

  decreaseTickets() {
    if (numOfTickets > 0) {
      setState(() {
        numOfTickets--;
        totalPrice = numOfTickets * widget.draw!.ticketPrice!;
      });
    }
  }

  purchaseHandler() {
    final drawState = ref.watch(drawStateProvider.notifier);
    final currentUser = ref.watch(userStateProvider).user;

    if (currentUser != null && currentUser.balance! >= totalPrice) {
      try {
        PromotionalDraw currentDraws = drawState.state.userDraws
            .firstWhere((element) => element.id == widget.draw!.id);
        int currentTicketCount = currentDraws.tickets!.length;
        if ((currentTicketCount + numOfTickets) >
            currentDraws.maxPerUserEntries) {
          setState(() {
            processing = false;
            message =
                "You have bought the maximum number of tickets you are allowed to purchase for this draw.";
          });
          return;
        }
      } catch (e) {}

      setState(() {
        processing = true;
      });

      drawState
          .purchaseTicket(numOfTickets, widget.draw!, currentUser)
          .then((value) {
        setState(() {
          processing = false;
          if (value > 0) {
            message = 'success';
          }
        });
      });
    } else {
      setState(() {
        processing = false;
        message = "Not enough funds.";
      });
    }
  }

  purchaseWidget() => Column(
        children: [
          Text(
            "Number of Tickets",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "Max " + widget.draw!.maxPerUserEntries.toString(),
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: (() => increaseTickets()),
                child: Text(
                  "+",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                numOfTickets.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 20,
              ),
              TextButton(
                onPressed: (() => decreaseTickets()),
                child: Text(
                  "-",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (message.isNotEmpty && message != 'success')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (numOfTickets > 0)
            GlowButton(
              onPress: () => purchaseHandler(),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm ',
                    style: TextStyle(
                        color: Colors.yellow[700], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    numOfTickets.toString(),
                    style: TextStyle(
                        color: Colors.yellow[700], fontWeight: FontWeight.bold),
                  ),
                  Text(
                    numOfTickets > 1 ? ' Tickets for ' : ' Ticket for ',
                    style: TextStyle(
                        color: Colors.yellow[700], fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: Image.asset('assets/images/ticket_gold.png'),
                  ),
                  Text(
                    " " + totalPrice.toStringAsFixed(2),
                    style: TextStyle(
                        color: Colors.yellow[700], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      );

  loadingWidget() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Processing Order...",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(color: Colors.white),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final drawState = ref.watch(drawStateProvider);
    final userState = ref.watch(userStateProvider).user;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color.fromARGB(232, 26, 26, 26),
            border: Border.all(color: Colors.grey, width: 0.5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: (() {
                      Get.back();
                    }),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 86, 86, 86),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                Center(
                  child: Text(
                    "Purchase",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: widget.draw!.image1Url!.isNotEmpty
                          ? Image.network(
                              widget.draw!.image1Url!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/smart_stats_logo_inverse.png')),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Draw",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(widget.draw!.name!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Description", style: TextStyle(color: Colors.grey)),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          widget.draw!.aboutOffer!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            processing
                ? loadingWidget()
                : (message.isNotEmpty && message == 'success')
                    ? Center(
                        child: Column(
                          children: [
                            Text(
                              "Purchase Complete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Icon(
                              Icons.check,
                              size: 100,
                              color: Colors.green,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GlowButton(
                              onPress: () {
                                Get.back();
                              },
                              content: Text(
                                'Close',
                                style: TextStyle(
                                    color: Colors.yellow[700],
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      )
                    : purchaseWidget(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
