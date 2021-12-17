import 'package:ss_golf/shared/models/challenge_input.dart';

abstract class ChallengeInputResult {
  String name, type;
  int index;
  ChallengeInputResult({this.name, this.type, this.index});
}

class ChallengeInputSelectResult implements ChallengeInputResult {
  String selectedOption, name, type;
  int index;

  ChallengeInputSelectResult(data) {
    this.name = data['name'];
    this.type = data['type'];
    this.selectedOption = data['selectedOption'];
    this.index = data['index'];
  }

  getJson() {
    return {
      'name': this.name ?? null,
      'type': this.type ?? null,
      'selectedOption': this.selectedOption ?? null,
    };
  }
}

class ChallengeInputSelectScoreResult extends ChallengeInputResult {
  SelectOptionScore selectedOption;

  ChallengeInputSelectScoreResult(data) {
    this.name = data['name'];
    this.type = data['type'];
    this.selectedOption =
        data['selectedOption'] != null ? SelectOptionScore(data['selectedOption']) : null;
    this.index = data['index'];
  }

  getJson() {
    return {
      'name': this.name ?? null,
      'type': this.type ?? null,
      'selectedOption': this.selectedOption.getJson() ?? null,
    };
  }
}

class ChallengeInputScoreResult implements ChallengeInputResult {
  int selectedScore, index;
  String name, type;

  ChallengeInputScoreResult(data) {
    this.name = data['name'];
    this.type = data['type'];
    this.selectedScore = data['selectedScore'] ?? -1;
    this.index = data['index'];
  }

  getJson() {
    return {
      'name': this.name ?? null,
      'type': this.type ?? null,
      'selectedScore': this.selectedScore ?? null,
    };
  }
}
