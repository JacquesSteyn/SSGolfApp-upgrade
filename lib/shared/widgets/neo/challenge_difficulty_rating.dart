import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ChallengeDifficultyRating extends StatefulWidget {
  const ChallengeDifficultyRating(
      {Key? key,
      this.difficultyRating = 0,
      this.reverse = false,
      this.showText = true,
      this.iconColor = Colors.amber})
      : super(key: key);
  final double difficultyRating;
  final bool reverse;
  final bool showText;
  final Color iconColor;

  @override
  _ChallengeDifficultyRatingState createState() =>
      _ChallengeDifficultyRatingState();
}

class _ChallengeDifficultyRatingState extends State<ChallengeDifficultyRating> {
  String ratingText = '';

  _setRatingText() {
    if (widget.difficultyRating <= 0.5) {
      ratingText = "Easy";
    } else if (widget.difficultyRating <= 1) {
      ratingText = 'Easy+';
    } else if (widget.difficultyRating <= 1.5) {
      ratingText = 'Intermediate';
    } else if (widget.difficultyRating <= 2) {
      ratingText = 'Intermediate+';
    } else if (widget.difficultyRating <= 2.5) {
      ratingText = 'Hard';
    } else if (widget.difficultyRating <= 3) {
      ratingText = 'Hard+';
    } else if (widget.difficultyRating <= 3.5) {
      ratingText = 'Advanced';
    } else if (widget.difficultyRating <= 4) {
      ratingText = 'Advanced+';
    } else if (widget.difficultyRating <= 4.5) {
      ratingText = 'Pro';
    } else if (widget.difficultyRating <= 5) {
      ratingText = 'Pro+';
    }
  }

  @override
  Widget build(BuildContext context) {
    _setRatingText();
    return Column(
      children: [
        if (widget.reverse) difficultyText(),
        RatingBar.builder(
          initialRating: widget.difficultyRating,
          minRating: 0,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 18,
          unratedColor: Colors.grey,
          itemBuilder: (context, _) =>
              Icon(Icons.star, color: widget.iconColor),
          onRatingUpdate: (_) {},
        ),
        if (widget.showText)
          if (!widget.reverse) difficultyText(),
      ],
    );
  }

  Widget difficultyText() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(
        ratingText,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }
}
