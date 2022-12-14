import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/challenge_feedback.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';

class FeedbackDialog extends StatefulWidget {
  final VoidCallback? feedbackSubmitted;
  final String? userId;
  final String? challengeId;
  FeedbackDialog({this.feedbackSubmitted, this.userId, this.challengeId});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final DataService _dataService = new DataService();
  bool _isClosing = false;
  bool _isLoading = false;
  bool _completed = false;
  late ChallengeFeedback _feedback;

  void _handleClose() {
    if (!_isClosing) {
      _isClosing = true;
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _feedback = new ChallengeFeedback({
      'userId': widget.userId,
      'challengeId': widget.challengeId,
      'rating': 0.0,
      'ratingNotes': ''
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleClose();
      },
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.black,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.black,
          child: _buildDialogContent(),
        ),
      ),
    );
  }

  Widget _buildDialogContent() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: Get.size.height,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ratingBar(),
            ratingNotes(),
            actionButtons(),
          ],
        ),
      ),
    );
  }

  Widget ratingBar() {
    return Column(
      children: [
        title('How do you rate the challenge?'),
        RatingBar.builder(
          initialRating: _feedback.rating!,
          minRating: 0,
          // allowHalfRating: true,
          itemCount: 5,
          itemSize: 35,
          itemPadding: const EdgeInsets.all(2),
          unratedColor: Colors.grey,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  size: 40,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                  size: 40,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                  size: 40,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                  size: 40,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                  size: 80,
                );
              default:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  size: 40,
                );
            }
          },

          onRatingUpdate: (double val) {
            setState(() {
              _feedback.rating = val;
            });
          },
        ),
      ],
    );
  }

  Widget ratingNotes() {
    return Column(
      children: [
        title('Feedback notes'),
        TextField(
          onChanged: (text) {
            setState(() {
              _feedback.ratingNotes = text;
            });
          },
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          textInputAction: TextInputAction.done,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            fillColor: Colors.black,
            filled: true,
            labelText: 'Notes',
            labelStyle: TextStyle(color: Colors.grey[300]),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget actionButtons() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _completed
            ? Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: Get.size.width * 0.35,
                    child: PrimaryButton(
                      onPressed: _handleClose,
                      text: 'Cancel',
                      primary: false,
                    ),
                  ),
                  Container(
                    width: Get.size.width * 0.35,
                    child: PrimaryButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await _dataService.submitChallengeFeedback(_feedback);
                        widget.feedbackSubmitted!();
                        _handleClose();
                        setState(() {
                          _isLoading = false;
                          _completed = true;
                        });
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
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
