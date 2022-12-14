import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/home/select/golf/golf_challenge_state.dart';

class GolfChallengeFilterDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final golfChallengeState = ref.watch(golfChallengeStateProvider);
    return AlertDialog(
      title: Text(
        'Filter the challenges',
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: [
          ListTile(
            title: Text('Range'),
            leading: Radio(
              value: GolfChallengeTypeFilter.Range,
              groupValue: golfChallengeState.challengeTypeFilter,
              onChanged: (dynamic _) {
                golfChallengeState
                    .setChallengeType(GolfChallengeTypeFilter.Range);
              },
            ),
          ),
          ListTile(
            title: Text('Course'),
            leading: Radio(
              value: GolfChallengeTypeFilter.Course,
              groupValue: golfChallengeState.challengeTypeFilter,
              onChanged: (dynamic _) {
                golfChallengeState
                    .setChallengeType(GolfChallengeTypeFilter.Course);
              },
            ),
          ),
          ListTile(
            title: Text('Range and Course'),
            leading: Radio(
              value: GolfChallengeTypeFilter.All,
              groupValue: golfChallengeState.challengeTypeFilter,
              onChanged: (dynamic _) {
                golfChallengeState
                    .setChallengeType(GolfChallengeTypeFilter.All);
              },
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          // Difficulty Filter
        ],
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
}
