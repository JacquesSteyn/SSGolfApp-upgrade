import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';

class PhysicalChallengeWeightings {
  String? attributeId;
  List<PhysicalChallengeWeighting>? weightings;

  PhysicalChallengeWeightings([data]) {
    if (data != null) {
      this.attributeId = data['attributeId'];
      this.weightings = data['weightings']
          .map<PhysicalChallengeWeighting>(
              (weightingData) => PhysicalChallengeWeighting(weightingData))
          .toList();
    }
  }

  // getTotal() {}

  getJson() {
    return {
      'attributeId': this.attributeId,
      'weightings': this.weightings,
    };
  }
}

class PhysicalChallengeWeighting {
  Attribute? attribute;
  int? weight;

  PhysicalChallengeWeighting([data]) {
    if (data != null) {
      this.attribute = Attribute(data['attribute']);
      this.weight = data['weight'];
    }
  }

  double? getWeightingBandContribution(List<ChallengeBand> bands) {
    double? percentageContribution = 0;
    bands.forEach((band) {
      if (this.weight! >= band.lowerRange! && this.weight! <= band.upperRange!) {
        percentageContribution = band.percentage;
      }
    });

    return percentageContribution;
  }

  int? getNumberOfPrevResultsToUse(List<ChallengeBand> bands) {
    int? noOfPrevResults = 20;
    bands.forEach((band) {
      if (this.weight! >= band.lowerRange! && this.weight! <= band.upperRange!) {
        noOfPrevResults = band.numberOfPreviousResults;
      }
    });

    return noOfPrevResults;
  }

  getJson() {
    return {
      'attribute': this.attribute,
      'weight': this.weight,
    };
  }
}
