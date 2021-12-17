abstract class ChallengeInput {
  String type, name;
  int index, maxScore;

  ChallengeInput({
    this.type,
    this.name,
    this.index,
  });
}

class ChallengeInputSelect extends ChallengeInput {
  List<SelectOptionScore> selectionOptions;

  ChallengeInputSelect(data, index) {
    this.type = data['type'];
    this.name = data['name'];
    this.index = index;
    // this.selectionOptions = List<String>.from(data['selectOptions'] ?? []);
    this.selectionOptions = List<SelectOptionScore>.from(data['selectOptions']
            .map<SelectOptionScore>(
                (selectOption) => SelectOptionScore(selectOption)) ??
        []);
  }
}

class SelectOptionScore {
  String option;
  double score;

  SelectOptionScore(data) {
    this.option = data['option'];
    this.score = (data['score'] ?? 0).toDouble();
  }

  getJson() {
    return {
      'option': this.option,
      'score': this.score,
    };
  }
}

class ChallengeInputSelectScore extends ChallengeInput {
  List<SelectOptionScore> selectionOptions;

  ChallengeInputSelectScore(data, index) {
    this.type = data['type'];
    this.name = data['name'];
    this.maxScore = data['maxScore'];
    this.index = index;

    this.selectionOptions = List<SelectOptionScore>.from(data['selectOptions']
            .map<SelectOptionScore>(
                (selectOption) => SelectOptionScore(selectOption)) ??
        []);
  }
}

class ChallengeInputScore extends ChallengeInput {
  int maxScore;

  ChallengeInputScore(data, index) {
    this.type = data['type'];
    this.name = data['name'];
    this.index = index;
    this.maxScore = data['maxScore'];
  }
}
