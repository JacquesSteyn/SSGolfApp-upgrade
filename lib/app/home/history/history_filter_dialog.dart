import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/history/history_state.dart';

class HistoryFilterDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final historyViewState = watch(historyStateProvider);
    return AlertDialog(
      title: Text(
        'Filter your results',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //challengeType(historyViewState),
            challengeDifficulty(historyViewState),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Done'),
          onPressed: () {
            return Get.back();
          },
        ),
      ],
    );
  }

  Widget challengeType(historyViewState) {
    return Column(
      children: [
        Text(
          'Type',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.grey),
        ),
        ListTile(
          title: Text('Golf'),
          leading: Radio(
            value: ChallengeTypeFilter.Golf,
            groupValue: historyViewState.challengeTypeFilter,
            onChanged: (_) {
              historyViewState.setTypeFilter(ChallengeTypeFilter.Golf);
            },
          ),
        ),
        ListTile(
          title: Text('Physical'),
          leading: Radio(
            value: ChallengeTypeFilter.Physical,
            groupValue: historyViewState.challengeTypeFilter,
            onChanged: (_) {
              historyViewState.setTypeFilter(ChallengeTypeFilter.Physical);
            },
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
        // Difficulty Filter
      ],
    );
  }

  Widget challengeDifficulty(historyViewState) {
    return Column(
      children: [
        filterTitle('Difficulty'),
        ListTile(
          title: Text('Show all'),
          leading: Radio(
            value: true,
            groupValue: historyViewState.difficultyFilter > -1 ? false : true,
            onChanged: (_) {
              historyViewState.setDifficultyFilter(-1.0);
            },
          ),
        ),
        RatingBar.builder(
          initialRating: historyViewState.difficultyFilter > -1
              ? historyViewState.difficultyFilter
              : 0,
          minRating: 0,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 22,
          unratedColor: Colors.grey,
          itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (double val) {
            historyViewState.setDifficultyFilter(val);
          },
        ),

        // Difficulty Filter
      ],
    );
  }

  Widget filterTitle(text) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(color: Colors.grey),
    );
  }
}
