import 'package:ss_golf/shared/models/challenge_input_result.dart';
import 'package:ss_golf/shared/models/challenge_note_result.dart';

class PhysicalChallengeResult {
  String? challengeId, challengeName, difficulty, dateTimeCreated, index;
  List<ChallengeNoteResult>? notes;
  List<dynamic>? inputResults;
  double? percentage;

  late List<AttributeContribution> attributeContributions;

  PhysicalChallengeResult([data, attributeId]) {
    if (data != null) {
      this.index = data['index'];
      this.challengeId = data['challengeId'];
      this.challengeName = data['challengeName'];
      this.difficulty = data['difficulty'];
      this.percentage = data['percentage'].toDouble();
      this.dateTimeCreated = data['dateTimeCreated'] ?? '';

      this.inputResults = data['inputResults'] != null
          ? (data?['inputResults'] as Iterable).map((resultData) {
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
          ? (data?['notes'] as Iterable).map((noteData) {
              return ChallengeNoteResult(noteData);
            }).toList()
          : [];

      this.attributeContributions = [];
      if (attributeId != null) {
        this.attributeContributions = [
          AttributeContribution({
            'attributeId': attributeId,
            'percentage': data[attributeId]['value'],
          })
        ];
      }
    } else {
      this.attributeContributions = [];
    }
  }

  getJson() {
    Map<String, dynamic> jsonObject = {
      'index': this.index,
      'challengeId': this.challengeId ?? '',
      'challengeName': this.challengeName ?? '',
      'difficulty': this.difficulty ?? '0',
      'inputResults': this
          .inputResults!
          .map((dynamic challengeInputResult) => challengeInputResult.getJson())
          .toList(),
      'notes': this.notes!.map((note) => note.getJson()).toList(),
      'percentage': this.percentage ?? 0.0,
      'dateTimeCreated': this.dateTimeCreated,
    };

    this.attributeContributions.forEach((e) =>
        jsonObject['${e.attributeId}'] = {
          'value': e.percentage,
          'attributeId_index': '${e.attributeId}_${this.index}'
        });

    return jsonObject;
  }
}

class AttributeContribution {
  double? percentage;
  String? attributeId;

  AttributeContribution([data]) {
    if (data != null) {
      this.percentage = data['percentage'].toDouble() ?? null;
      this.attributeId = data['attributeId'] ?? '';
    }
  }

  getJson() {
    return {
      'percentage': this.percentage ?? null,
      'attributeId': this.attributeId ?? '',
    };
  }
}
