import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/draws/transaction.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/state/auth.provider.dart';

import '../../shared/widgets/orbitron_heading.dart';

class TicketHistoryScreen extends ConsumerStatefulWidget {
  const TicketHistoryScreen({Key? key}) : super(key: key);

  @override
  _TicketHistoryScreenState createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends ConsumerState<TicketHistoryScreen> {
  final customDateFormat = DateFormat('MMMM d');
  final monthFormat = DateFormat('MMMM');
  final passingMonthFormat = DateFormat('y-MM');
  UserProfile? currentUser;
  bool isLoading = true;
  List<UserTransaction> transactions = [];
  Map<String, List<UserTransaction>> calculatedTransactions = {};
  Map<String, Map<String, double>> calculatedTotals = {};
  Map<String, String> months = {};
  String? selectedMonth;
  String activeKey = "";

  @override
  void initState() {
    super.initState();
    currentUser = ref.read(userStateProvider).user;
    this.loadTransactions();
  }

  void loadTransactions() async {
    if (currentUser != null) {
      DataService ds = new DataService();
      setState(() {
        isLoading = true;
      });
      this.calculateMonths();

      if (selectedMonth == null) {
        selectedMonth = months.keys.first;
      }

      ds
          .fetchUserTransactions(currentUser!.id, months[selectedMonth!])
          .then((value) {
        setState(() {
          transactions = value;
          this.calculateFilteredTransactions();
          isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      Get.back();
    }
  }

  void calculateMonths() {
    for (var i = 0; i < 7; i++) {
      DateTime date = DateTime.now();
      DateTime prevMonth = new DateTime(date.year, date.month - i, 1);
      months.addAll({
        monthFormat.format(prevMonth): passingMonthFormat.format(prevMonth)
      });
    }
  }

  void calculateFilteredTransactions() {
    Map<String, List<UserTransaction>> tempList = {};
    Map<String, Map<String, double>> tempTotals = {};

    if (transactions.isNotEmpty) {
      transactions.forEach((transaction) {
        String d = customDateFormat.format(transaction.purchaseDate!);
        if (tempList.containsKey(d)) {
          tempList[d]!.add(transaction);
        } else {
          tempList[d] = [transaction];
        }
      });

      tempList.forEach(
        (key, trans) {
          if (!tempTotals.containsKey(key)) {
            tempTotals[key] = {};
            tempTotals[key]!['spent'] = 0;
            tempTotals[key]!['earned'] = 0;
          }
          trans.forEach((tran) {
            if (tempTotals.containsKey(key)) {
              if (tran.type == 'spent') {
                tempTotals[key]!['spent'] =
                    tempTotals[key]!['spent']! + tran.price!;
              } else {
                tempTotals[key]!['earned'] =
                    tempTotals[key]!['earned']! + tran.price!;
              }
            }
          });
        },
      );
    }

    setState(() {
      calculatedTransactions = tempList;
      calculatedTotals = tempTotals;
    });
  }

  Widget itemHeader(String title) {
    return Column(
      children: [
        Row(
          children: [
            ExpandIcon(
              isExpanded: title == activeKey,
              color: Colors.white,
              size: 30,
              onPressed: ((value) {
                if (title == activeKey) {
                  setState(() {
                    activeKey = "";
                  });
                } else {
                  setState(() {
                    activeKey = title;
                  });
                }
              }),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.35),
                    child: FittedBox(
                      //fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Get.textScaleFactor * 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Earned',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: Get.width * 0.01,
                      ),
                      Text(
                        '+',
                        style: TextStyle(
                            color: Colors.yellow[700],
                            fontSize: 18,
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
                      SizedBox(
                        width: 60,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            calculatedTotals[title]!['earned']!
                                .toStringAsFixed(2),
                            style: TextStyle(
                                color: Colors.yellow[700],
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Spent',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: Get.width * 0.01,
            ),
            Text(
              '-',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: Get.width * 0.08,
            ),
            Text(
              calculatedTotals[title]!['spent']!.toStringAsFixed(2),
              style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget transactionImage(String? type) {
    if (type == 'check-in') {
      return Image.asset('assets/images/calender.png');
    } else if (type == 'challenge') {
      return Image.asset('assets/images/golf_flag.png');
    } else if (type == '3day') {
      return Image.asset('assets/images/flame.png');
    } else {
      return Image.asset('assets/images/gift.png');
    }
  }

  Widget historyItem(UserTransaction tran) => Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Color.fromARGB(85, 108, 108, 108),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (tran.type != 'spent')
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(85, 108, 108, 108),
                    ),
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: transactionImage(tran.type),
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 160),
                  child: Text(
                    tran.type == 'spent' ? "${tran.name} Draw" : tran.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            FittedBox(
              child: Text(
                tran.type == 'spent'
                    ? '- ${tran.price!.toStringAsFixed(2)}'
                    : '+ ${tran.price!.toStringAsFixed(2)}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget monthsContainer() => SizedBox(
        height: 30,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              mainAxisSize: MainAxisSize.min,
              children: months.keys
                  .map((e) => Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 82,
                        decoration: BoxDecoration(
                            color: selectedMonth == e
                                ? Colors.white
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedMonth = e;
                            });
                            this.loadTransactions();
                          },
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: selectedMonth == e
                                        ? Colors.grey.shade800
                                        : Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList()),
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
          title: 'Transaction History',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    monthsContainer(),
                    SizedBox(
                      height: 10,
                    ),
                    transactions.length == 0
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No transactions found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: calculatedTransactions.length,
                                itemBuilder: ((context, index) {
                                  String key = calculatedTransactions.keys
                                      .elementAt(index);
                                  List<UserTransaction>? trans =
                                      calculatedTransactions[key];
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(80, 141, 141, 141),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        itemHeader(key),
                                        if (activeKey == key)
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: trans!.length,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemBuilder: ((context, i) {
                                              return historyItem(trans[i]);
                                            }),
                                          ),
                                      ],
                                    ),
                                  );
                                })),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
