import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/models/challenge_input.dart';
import 'package:ss_golf/shared/models/challenge_note.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge_result.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge_weightings.dart';
import 'package:ss_golf/shared/models/stat.dart';

class PhysicalScoreState extends ChangeNotifier {
  final DataService _dataService = DataService();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // form field values

  // *** DYNAMIC USER INPUT FIELDS - FieldInputs cycles though the set user inputs and creates user input results to store in results.
  bool _userInputResultsSet = false;
  List<ChallengeInput>? _userInputs = [];
  void setUserInputs(PhysicalChallenge? challenge) {
    if (!_userInputResultsSet) {
      _userInputs = challenge!.inputs;
      _challengeNotes = challenge.notes;
      challengeResult.inputResults = challenge.getAllChallengeInputResults();
      challengeResult.notes = challenge.getChallengeNoteResults();
      _userInputResultsSet = true;
    }
  }

  List<ChallengeNote>? _challengeNotes = [];
  List<dynamic>? get challengeNotes => _challengeNotes;
  String? getChallengeNoteResult(int index) {
    return challengeResult.notes![index].selectedOption;
  }

  void setChallengeNoteResult(int index, String selectedOption) {
    challengeResult.notes![index].selectedOption = selectedOption;
    notifyListeners();
  }

  List<dynamic>? get userInputs => _userInputs;
  List<dynamic>? get inputResults => challengeResult.inputResults;
  PhysicalChallengeResult challengeResult = PhysicalChallengeResult();

  setInputScoreResult(int scoreIndex, int selectedScore) {
    challengeResult.inputResults![scoreIndex].selectedScore = selectedScore;
    notifyListeners();
  }

  int? getInputScoreResult(int inputIndex) {
    return inputResults![inputIndex].selectedScore;
  }

  setInputSelectScoreResult(
      int inputIndex, SelectOptionScore selectedScoreOption) {
    challengeResult.inputResults![inputIndex].selectedOption =
        selectedScoreOption;
    notifyListeners();
  }

  SelectOptionScore? getInputSelectScoreResult(int inputIndex) {
    return inputResults![inputIndex].selectedOption;
  }

  setInputSelectResult(int scoreIndex, String selectedOption) {
    challengeResult.inputResults![scoreIndex].selectedOption = selectedOption;
    notifyListeners();
  }

  String? getInputSelectResult(int inputIndex) {
    return inputResults![inputIndex].selectedOption;
  }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  void setIsCompleted(bool val) {
    _isCompleted = val;
    notifyListeners();
  }

  void resetScoreState() {
    _isLoading = false;
    _isCompleted = false;
    _userInputResultsSet = false;
    _userInputs = [];
    _challengeNotes = [];
    challengeResult = PhysicalChallengeResult();
    // notifyListeners();
  }

  Future<double?> submit(
    String userId,
    PhysicalChallenge challenge,
    List<Attribute> attributes,
    Stat latestStat,
    List<Skill> skills,
  ) async {
    if (validateForm()) {
      challengeResult.challengeId = challenge.id;
      challengeResult.challengeName = challenge.name;
      challengeResult.difficulty = challenge.difficulty;
      challengeResult.dateTimeCreated = DateTime.now().toString();
      try {
        setIsLoading(true);

        // 1. Challenge score
        challengeResult.percentage =
            _calculateChallengeScorePercentage(challenge);

        // 2. Attribute score updates
        await _updateAttributeScores(
          userId,
          challenge,
          challengeResult.percentage,
          attributes,
          latestStat,
          skills.length,
        );

        // 3. Save challenge result
        await _dataService.submitPhysicalChallengeResult(
            userId, challengeResult);

        // 4. Reset
        // setIsLoading(false);
        // resetScoreState();

        return challengeResult.percentage;
      } catch (e) {
        print("ERR Submit Result: " + e.toString());
        return null;
      }
    } else {
      setIsLoading(false);
      return null;
    }
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  void setErrorMessage(String val) {
    _errorMessage = val;
    notifyListeners();
  }

  validateForm() {
    bool validInputs = true;
    for (var inputResult in challengeResult.inputResults!) {
      if (inputResult.type == 'score') {
        if (inputResult.selectedScore < 0) {
          _errorMessage = '${inputResult.name} - please enter a score.';
          print('Invalid score!: ' + inputResult.type.toString());
          validInputs = false;
        }
      } else if (inputResult.selectedOption == null) {
        print('Invalid select!: ' + inputResult.type.toString());
        _errorMessage = _errorMessage +
            '\n\n${inputResult.name} - please select an option.';
        validInputs = false;
      }
    }

    return validInputs;
  }

  double _calculateChallengeScorePercentage(PhysicalChallenge challenge) {
    // ** 1. Total elements contribution points
    int totalPoints = 0;
    challenge.weightings.weightings!
        .forEach((value) => totalPoints = totalPoints + value.weight!);

    // ** 2. Additive total and division factor
    double score = 0;
    int divisionFactor = 0;
    double _maxScore = 0;
    inputResults!.forEach((inputResult) {
      if (inputResult.type == 'score') {
        score = score + inputResult.selectedScore;
        divisionFactor++;
        // find max score - this is not ideal but works
        int userInputIndex =
            userInputs!.indexWhere((input) => input.name == inputResult.name);
        _maxScore = _maxScore + userInputs![userInputIndex].maxScore;
      } else if (inputResult.type == 'inverted-score') {
        score = score + inputResult.selectedScore;
        divisionFactor++;
        // find max score - this is not ideal but works
        int userInputIndex =
            userInputs!.indexWhere((input) => input.name == inputResult.name);
        _maxScore = _maxScore + userInputs![userInputIndex].maxScore;

        //create the inverse of the score
        score = score + (_maxScore - inputResult.selectedScore);
        divisionFactor++;
      } else if (inputResult.type == 'select-score') {
        score = score + inputResult.selectedOption.score;
        divisionFactor++;
        // find max score - this is not ideal but works
        int userInputIndex =
            userInputs!.indexWhere((input) => input.name == inputResult.name);
        double maxScoreForOptions =
            userInputs![userInputIndex].selectionOptions.last.score;
        // .reduce<int>((a, b) => a.score > b.score ? a.score : b.score);
        _maxScore = _maxScore + maxScoreForOptions;
      }
    });

    score = score / divisionFactor;
    _maxScore = _maxScore / divisionFactor;

    // ** 3. Achieved score * total points
    double points = (score / _maxScore) * totalPoints;

    if (challenge.benchmarks.threshold.toDouble() > 0) {
      if (score >= challenge.benchmarks.threshold.toDouble()) {
        points = (_maxScore / _maxScore) * totalPoints;
      }
    }

    // ** 4. Adjusted points (times by difficulty)
    double difficulty = double.parse(challenge.difficulty!);
    double adjustedPoints = points * (difficulty / 5);

    // ** 5. PhysicalChallenge score as percentage
    double _calculatedScorePercentage = ((adjustedPoints / totalPoints) * 100);

    return _calculatedScorePercentage;
  }

  _updateAttributeScores(
    String userId,
    PhysicalChallenge challenge,
    double? newScorePercentage,
    List<Attribute> attributes,
    Stat updatedStatScores,
    int skillsLength,
  ) async {
    // String relevantAttributeId = challenge.weightings.attributeId;

    // *** 1. Get the latest stat and bands
    List<ChallengeBand>? challengeBands =
        await _dataService.getChallengeBands(challenge.weightingBandId);

    // 2. Updated stat - only updates the specific attribute - check if it exists or create a new one
    updatedStatScores.day = Utilities.getCurrentDayId();
    // updatedStatScores.name = 'Overall';

    // *** 3. UPDATE ATTRIBUTE SCORES
    for (PhysicalChallengeWeighting weighting
        in challenge.weightings.weightings!) {
      if (weighting.weight! > 0) {
        print(
            '0. STAT FOR ATTRIBUTE => ' + weighting.attribute!.name.toString());

        // * 1. Either exists or create a new one
        int attributeStatIndex =
            updatedStatScores.findAttributeIndex(weighting.attribute!.id);
        print('1. ATTRIBUTE STAT INDEX => ' + attributeStatIndex.toString());
        if (attributeStatIndex == -1) {
          updatedStatScores.attributeStats!.add(
            AttributeStat(
              {'value': 0, 'id': weighting.attribute!.id},
              weighting.attribute,
            ),
          );
          attributeStatIndex = updatedStatScores.attributeStats!.length - 1;
        }

        // * 2. Which band is current weighting in
        double? attributePercentageContribution =
            weighting.getWeightingBandContribution(challengeBands!);
        int noOfPreviousResults =
            weighting.getNumberOfPrevResultsToUse(challengeBands)!;

        print('2. PERCENTAGE CONTRIBUTION BAND VALUE => ' +
            attributePercentageContribution.toString());

        // * 3. While we're at it - set the attribute band for the result
        challengeResult.attributeContributions.add(AttributeContribution({
          'percentage': attributePercentageContribution,
          'attributeId': weighting.attribute!.id
        }));

        // * 4. get previous results for this attribute
        List<PhysicalChallengeResult> previousResults =
            await _dataService.getLatestResultsForAttribute(
                userId, weighting.attribute!.id, noOfPreviousResults);

        print('5. PREVIOUS RESULTS TOTAL => ' +
            previousResults.length.toString());

        // * 5. split out into their respective bands
        Map<double?, List<double?>> filteredPreviousAttributeScores = {};
        previousResults.forEach((previousResult) {
          if (filteredPreviousAttributeScores[
                  previousResult.attributeContributions[0].percentage] !=
              null) {
            filteredPreviousAttributeScores[
                    previousResult.attributeContributions[0].percentage]!
                .add(previousResult.percentage);
          } else {
            filteredPreviousAttributeScores[previousResult
                .attributeContributions[0]
                .percentage] = [previousResult.percentage];
          }
        });

        print('6. FILTERED BANDS => ' +
            filteredPreviousAttributeScores.toString());

        // * add in new score to contribute
        if (filteredPreviousAttributeScores[attributePercentageContribution] !=
            null) {
          filteredPreviousAttributeScores[attributePercentageContribution]!
              .add(newScorePercentage);
        } else {
          filteredPreviousAttributeScores[attributePercentageContribution] = [
            newScorePercentage
          ];
        }

        print('7. FILTERED BANDS with new score ' +
            filteredPreviousAttributeScores.toString());

        // ** Redistribution
        double bandsWithNoScoreTally = 0;
        double bandsWithScoreCount = 0;
        double redistributionVal = 0;
        // Iterable<double> contributionValueKeys = filteredPreviousElementScores.keys;

        Iterable<double?> contributionPercentageValues =
            filteredPreviousAttributeScores.keys;

        for (var band in challengeBands) {
          if (contributionPercentageValues.contains(band.percentage)) {
            bandsWithScoreCount++; // should always be min of 1
          } else {
            bandsWithNoScoreTally = bandsWithNoScoreTally + band.percentage!;
          }
        }
        redistributionVal = bandsWithNoScoreTally / bandsWithScoreCount;
        print('REDISTribution  $redistributionVal');

        // ** Cycle through and do calc
        List<double> attributeContributionValues = [];
        // var contributionPercentageValues = filteredPreviousAttributeScores.keys;
        for (double? key in contributionPercentageValues) {
          int totalScores = filteredPreviousAttributeScores[key]!.length;
          double totalScoresValue =
              filteredPreviousAttributeScores[key]!.reduce((a, b) => a! + b!)!;

          attributeContributionValues.add((totalScoresValue / totalScores) *
              ((key! + redistributionVal) / 100));

          print('REDISTTTT::: ' + (key + redistributionVal).toString());
        }

        print('8. CONTRIBUTION VALUES => ' +
            attributeContributionValues.toString());

        // finally add all together for new element score
        double updatedAttributePercentage =
            attributeContributionValues.reduce((a, b) => a + b);

        print('9. Updated ATTRIBUTE PERCENTAGE => ' +
            updatedAttributePercentage.toString() +
            '\n\n');

        updatedStatScores.attributeStats![attributeStatIndex].value =
            updatedAttributePercentage;
      }
    }

    // *** 2. UPDATE PHYSICAL OVERALL SCORE
    print('UPDATE OVERALL PHYSICAL SCORE');
    int totalAttributes =
        attributes.length; // updatedStatScores.skillStats.length;
    double totalAttributeScores = 0;
    updatedStatScores.attributeStats!.forEach((attributeStat) =>
        totalAttributeScores = totalAttributeScores + attributeStat.value!);
    updatedStatScores.physicalValue = totalAttributeScores / totalAttributes;

    // *** 3. UPDATE OVERALL GOLF SCORE
    print('\n*** UPDATE OVERALL GOLF SCORE');
    int totalSkills = skillsLength + 1; // NB: plus 1 for physical score.
    double totalSkillsScore = 0;
    updatedStatScores.skillStats!.forEach(
        (skillStat) => totalSkillsScore = totalSkillsScore + skillStat.value!);

    // add physical score
    totalSkillsScore =
        totalSkillsScore + (updatedStatScores.physicalValue ?? 0);
    updatedStatScores.golfValue = totalSkillsScore / totalSkills;
    print('UPDATED OVERALL SCORE => ${updatedStatScores.golfValue}');

    // 4. Persist the updated stat
    print('OHHHH MY WHAT ARE YOUUU: ' + updatedStatScores.getJson().toString());
    await _dataService.updateStat(userId, updatedStatScores);
  }
}

final physicalScoreStateProvider =
    ChangeNotifierProvider((ref) => PhysicalScoreState());
