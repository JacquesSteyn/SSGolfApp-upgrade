import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/models/tip.dart';

class TipsAndAdvice extends StatefulWidget {
  final List<TipGroup>? tips;

  TipsAndAdvice({this.tips});

  @override
  _TipsAndAdviceState createState() => _TipsAndAdviceState();
}

class _TipsAndAdviceState extends State<TipsAndAdvice> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: widget.tips!
              .map<Widget>((tipGroup) => tipGroupWidget(tipGroup))
              .toList(),
        ),
      ),
    );
  }

  Widget tipGroupWidget(TipGroup tipGroup) {
    List<Widget> columnTips =
        tipGroup.tips!.map<Widget>((tip) => tipWidget(tip)).toList();

    columnTips.insert(
      0,
      Text(
        '${tipGroup.title}',
        style:
            TextStyle(color: Colors.white, fontSize: Get.textScaleFactor * 18),
      ),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Column(
        children: columnTips,
      ),
    );
  }

  Widget tipWidget(Tip tip) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Icon(
            tip.checked! ? Icons.check : Icons.clear,
            color: tip.checked! ? Colors.green : Colors.red,
          ),
          SizedBox(width: 5),
          Flexible(
            child: Text(
              tip.text!,
              style: TextStyle(
                  color: tip.checked! ? Colors.green : Colors.red,
                  fontSize: Get.textScaleFactor * 18),
            ),
          ),
        ],
      ),
    );
  }
}
