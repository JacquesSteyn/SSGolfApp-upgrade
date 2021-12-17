import 'package:ss_golf/shared/models/golf/skill_element.dart';

class ChallengeWeightings {
  String skill, skillId; // TODO -> skill should be skillName
  int elementId;
  List<ChallengeWeighting> weightings;

  ChallengeWeightings([data]) {
    if (data != null) {
      this.skill = data['skill'];
      this.skillId = data['skillId'];
      this.elementId = data['elementId'];
      this.weightings = data['weightings']
          .map<ChallengeWeighting>((weightingData) => ChallengeWeighting(weightingData))
          .toList();
    }
  }

  getTotal() {}

  getJson() {
    return {
      'skill': this.skill,
      'skillId': this.skillId,
      'elementId': this.elementId,
      'weightings': this.weightings,
    };
  }
}

class ChallengeWeighting {
  SkillElement element;
  int weight;

  ChallengeWeighting([data]) {
    if (data != null) {
      this.element = SkillElement(data['element']);
      this.weight = data['weight'];
    }
  }

  double getWeightingBandContribution(List<ChallengeBand> bands) {
    double percentageContribution = 0;
    bands.forEach((band) {
      if (this.weight >= band.lowerRange && this.weight <= band.upperRange) {
        percentageContribution = band.percentage;
      }
    });

    return percentageContribution;
  }

  int getNumberOfPrevResultsToUse(List<ChallengeBand> bands) {
    int noOfPrevResults = 20;
    bands.forEach((band) {
      if (this.weight >= band.lowerRange && this.weight <= band.upperRange) {
        noOfPrevResults = band.numberOfPreviousResults;
      }
    });

    return noOfPrevResults;
  }

  getJson() {
    return {
      'element': this.element,
      'weight': this.weight,
    };
  }
}

class ChallengeBand {
  int id, upperRange, lowerRange, numberOfPreviousResults;
  double percentage;

  ChallengeBand([data]) {
    if (data != null) {
      this.id = data['id'];
      this.upperRange = data['upperRange'];
      this.lowerRange = data['lowerRange'];
      this.numberOfPreviousResults = data['numberOfPreviousResults'];
      this.percentage = data['percentage'].toDouble();
    }
  }

  getJson() {
    return {
      'id': this.id,
      'upperRange': this.upperRange,
      'lowerRange': this.lowerRange,
      'numberOfPreviousResults': this.numberOfPreviousResults,
      'percentage': this.percentage,
    };
  }
}
