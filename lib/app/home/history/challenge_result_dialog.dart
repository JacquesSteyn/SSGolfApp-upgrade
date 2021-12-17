import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/models/challenge_note_result.dart';
import 'package:ss_golf/shared/widgets/custom_app_bar.dart';
import 'package:ss_golf/shared/widgets/custom_radial_painter.dart';
import 'package:ss_golf/shared/widgets/custome_donut.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';

class ChallengeResultDialog extends StatefulWidget {
  final dynamic result;
  ChallengeResultDialog({this.result});

  @override
  _ChallengeResultDialogState createState() => _ChallengeResultDialogState();
}

class _ChallengeResultDialogState extends State<ChallengeResultDialog> {
  bool _isClosing = false;

  void _handleClose() {
    if (!_isClosing) {
      _isClosing = true;
      Get..back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: widget.result.challengeName,
        showActions: false,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: _buildDialogContent(),
      ),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Get.size.height * 0.9,
      ),
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            scoreAndDate(),
            Divider(color: Colors.grey),
            resultInputs(),
            Divider(color: Colors.grey),
            resultNotes(),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget scoreAndDate() {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Center(
              // color: Colors.yellow,
              // child: CustomPaint(
              //   painter: CustomRadialPainter(
              //     percentage: widget.result.percentage,
              //     dimension: Get.height * 0.25,
              //     strokeWidth: 15,
              //   ),
              // ),
              child: DonutChart(value: widget.result.percentage),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Utilities.formatDate(DateTime.parse(
                      widget.result.dateTimeCreated)), //'2020-09-06',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  Utilities.formatTime(DateTime.parse(
                      widget.result.dateTimeCreated)), //'2020-09-06',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget resultInputs() {
    return Column(
      children: widget.result.inputResults
          .map<Widget>((input) => individualInputResult(input))
          .toList(),
    );
  }

  Widget individualInputResult(dynamic input) {
    String value = input.type == 'score' || input.type == 'inverted-score'
        ? input.selectedScore.toString()
        : (input.type == 'select-score'
            ? input.selectedOption.option.toString()
            : input.selectedOption.toString());
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          title(input.name),
          titleContent(value),
        ],
      ),
    );
  }

  Widget resultNotes() {
    return widget.result.notes.length > 0
        ? Column(
            children: widget.result.notes
                .map<Widget>((note) => individualNote(note))
                .toList(),
          )
        : Center(
            child: Text(
              'No notes.',
              style: TextStyle(color: Colors.grey),
            ),
          );
  }

  Widget individualNote(ChallengeNoteResult note) {
    // Don't show if selectedOption is null

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        children: [
          title(note.title),
          titleContent(note.selectedOption),
          // Divider(
          //   color: Colors.grey,
          // ),
        ],
      ),
    );
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   width: Get.size.width * 0.35,
        //   child: PrimaryButton(
        //     onPressed: _handleClose,
        //     text: 'Cancel',
        //     primary: false,
        //   ),
        // ),
        Container(
          width: Get.size.width * 0.35,
          child: PrimaryButton(
            onPressed: () async {
              _handleClose();
            },
            text: 'Done',
          ),
        ),
      ],
    );
  }

  Widget title(String text) {
    return Container(
      padding: const EdgeInsets.all(5), //fromLTRB(10, 5, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$text:',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  Widget titleContent(String text) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
