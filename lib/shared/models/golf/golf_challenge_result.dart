import 'package:ss_golf/shared/models/challenge_input_result.dart';
import 'package:ss_golf/shared/models/challenge_note_result.dart';

class GolfChallengeResult {
  String challengeId, challengeName, difficulty, dateTimeCreated, index;
  List<ChallengeNoteResult> notes;
  List<dynamic> inputResults;
  double percentage;

  List<ElementContribution> elementContributions;

  GolfChallengeResult([data, skillIdElementId]) {
    if (data != null) {
      this.index = data['index'];
      this.challengeId = data['challengeId'];
      this.challengeName = data['challengeName'] ?? '';
      this.difficulty = data['difficulty'] ?? '0';
      this.percentage = data['percentage'].toDouble();
      this.dateTimeCreated = data['dateTimeCreated'] ?? '';
      // this.timeCreated = data['timeCreated'];
      this.inputResults = data['inputResults'] != null
          ? data['inputResults'].map<ChallengeInputResult>((resultData) {
              if (resultData['type'] == 'select') {
                return ChallengeInputSelectResult(resultData);
              } else if (resultData['type'] == 'select-score') {
                return ChallengeInputSelectScoreResult(resultData);
              } else if (resultData['type'] == 'score') {
                return ChallengeInputScoreResult(resultData);
              }
            }).toList()
          : [];

      this.notes = data['notes'] != null
          ? data['notes'].map<ChallengeNoteResult>((noteData) {
              return ChallengeNoteResult(noteData);
            }).toList()
          : [];

      this.elementContributions = [];
      if (skillIdElementId != null) {
        this.elementContributions = [
          ElementContribution({
            'skillIdElementId': skillIdElementId,
            'percentage':
                data[skillIdElementId] != null ? data[skillIdElementId]['value'] : 0,
          })
        ];
      }
    } else {
      this.elementContributions = [];
    }
  }

  getJson() {
    Map<String, dynamic> jsonObject = {
      'index': this.index,
      'challengeId': this.challengeId ?? '',
      'challengeName': this.challengeName ?? '',
      'difficulty': this.difficulty ?? '0',
      'inputResults': this
              .inputResults
              .map((dynamic challengeInputResult) => challengeInputResult.getJson())
              .toList() ??
          0,
      'notes': this.notes.map((note) => note.getJson()).toList(),
      'percentage': this.percentage ?? 0.0,
      'dateTimeCreated': this.dateTimeCreated,
    };

    this.elementContributions.forEach((e) => jsonObject['${e.skillIdElementId}'] = {
          'value': e.percentage,
          'skillIdElementId_index': '${e.skillIdElementId}_${this.index}'
        });

    return jsonObject;
  }
}

class ElementContribution {
  double percentage;
  String skillIdElementId;

  ElementContribution([data]) {
    if (data != null) {
      this.percentage = data['percentage'].toDouble() ?? null;
      this.skillIdElementId = data['skillIdElementId'] ?? '';
    }
  }

  getJson() {
    return {
      'percentage': this.percentage ?? null,
      'skillIdElementId': this.skillIdElementId ?? '',
    };
  }
}