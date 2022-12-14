import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Instructions extends StatefulWidget {
  final List<String>? instructions;

  Instructions({this.instructions});

  @override
  _InstructionsState createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  final List<Widget> items = [];

  @override
  void initState() {
    int i = 0;
    widget.instructions!.forEach((instruction) {
      if (i == 0) {
        items.add(title(widget.instructions![0]));
        i++;
      } else {
        items.add(subTitle('$i)', instruction));
        i++;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: items,
        ),
      ),
    );
  }

  Widget title(String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 15, 5, 10),
      // color: Colors.orange,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_searching,
            color: Get.theme.backgroundColor,
            size: 18,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Get.theme.backgroundColor, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget subTitle(String bulletNumber, String text) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            bulletNumber,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
