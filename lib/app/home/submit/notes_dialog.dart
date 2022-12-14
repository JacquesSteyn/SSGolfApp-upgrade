import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/models/challenge_note.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';

class NotesDialog extends StatefulWidget {
  final scoreState;
  NotesDialog({this.scoreState});

  @override
  _NotesDialogState createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  List<ChallengeNote>? challengeNotes = [];
  // List<ChallengeNoteResult> challengeNoteResults = [];
  bool _isClosing = false;

  // @override
  // void initState() {
  //   challengeNotes = widget.scoreState.challengeNotes;
  //   // challengeNotes.forEach((note) {
  //   //   challengeNoteResults
  //   //       .add(ChallengeNoteResult({'title': note.title, 'index': note.index}));
  //   // });
  //   super.initState();
  // }

  void _handleClose() {
    if (!_isClosing) {
      _isClosing = true;
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final scoreState = watch(golfScoreStateProvider);

    challengeNotes = widget.scoreState.challengeNotes;

    return GestureDetector(
      onTap: () {
        _handleClose();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        color: Colors.black,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          child: _buildDialogContent(widget.scoreState),
        ),
      ),
    );
  }

  Widget _buildDialogContent(scoreState) {
    return Container(
      child: Scrollbar(
        child: SingleChildScrollView(
          // child: ConstrainedBox(
          //   constraints: BoxConstraints(
          //     maxHeight: Get.size.height,
          //   ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              viewNotes(scoreState),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: actionButtons(),
              ),
            ],
            // ),
          ),
        ),
      ),
    );
  }

  Widget viewNotes(scoreState) {
    return Column(
      children: challengeNotes!
          .map<Widget>((note) => individualNote(note, scoreState))
          .toList(),
    );
  }

  Widget individualNote(ChallengeNote note, scoreState) {
    return Container(
      child: Column(
        children: [
          title(note.title!),
          Theme(
            data: Theme.of(Get.context!).copyWith(
              unselectedWidgetColor: Colors.grey,
            ),
            child: note.title == 'Custom notes'
                ? TextFormField(
                    initialValue: scoreState.getChallengeNoteResult(note.index),
                    maxLines: 4,
                    style: TextStyle(color: Colors.black),
                    onChanged: (String val) {
                      setState(() {
                        scoreState.setChallengeNoteResult(note.index, val);
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter custom notes here...',
                      hintStyle: TextStyle(color: Colors.grey),
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(18),
                      //   borderSide: const BorderSide(color: Colors.grey),
                      // ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: note.options!
                        .map((option) => SizedBox(
                              height: 50,
                              child: RadioListTile(
                                  activeColor: Colors.blue,
                                  title: Text(
                                    option,
                                    style: TextStyle(
                                        color:
                                            (scoreState.getChallengeNoteResult(
                                                        note.index) ==
                                                    option)
                                                ? Colors.black
                                                : Colors.grey),
                                  ),
                                  value: option,
                                  groupValue: scoreState
                                      .getChallengeNoteResult(note.index),
                                  onChanged: (dynamic val) {
                                    setState(() {
                                      scoreState.setChallengeNoteResult(
                                          note.index, val);
                                    });
                                  }),
                            ))
                        .toList(),
                  ),
          ),
          Divider(
            color: Colors.grey,
          ),
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
      padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black, fontSize: 22),
      ),
    );
  }
}
