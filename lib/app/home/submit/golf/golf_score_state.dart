import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/models/challenge_input.dart';
import 'package:ss_golf/shared/models/challenge_note.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge_result.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/golf/skill_element.dart';
import 'package:ss_golf/shared/models/stat.dart';

class ScoreState extends ChangeNotifier {
  final DataService _dataService = DataService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  void setIsCompleted(bool val) {
    _isCompleted = val;
    notifyListeners();
  }

  // *** DYNAMIC USER INPUT FIELDS - FieldInputs cycles though the set user inputs and creates user input results to store in results.
  bool _userInputResultsSet = false;
  List<ChallengeInput>? _userInputs = [];
  void setUserInputs(GolfChallenge? challenge) {
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
  GolfChallengeResult challengeResult = GolfChallengeResult();

  // ** SCORE INPUT
  setInputScoreResult(int scoreIndex, int selectedScore) {
    challengeResult.inputResults![scoreIndex].selectedScore = selectedScore;
    notifyListeners();
  }

  int? getInputScoreResult(int inputIndex) {
    return inputResults![inputIndex].selectedScore;
  }

  // ** SELECT SCORE INPUT
  setInputSelectScoreResult(
      int inputIndex, SelectOptionScore selectedScoreOption) {
    challengeResult.inputResults![inputIndex].selectedOption =
        selectedScoreOption;
    notifyListeners();
  }

  SelectOptionScore? getInputSelectScoreResult(int inputIndex) {
    return inputResults![inputIndex].selectedOption;
  }

  // ** SELECT INPUT
  setInputSelectResult(int scoreIndex, String selectedOption) {
    challengeResult.inputResults![scoreIndex].selectedOption = selectedOption;
    print("Selected Index:$scoreIndex Option:$selectedOption");
    notifyListeners();
  }

  String? getInputSelectResult(int inputIndex) {
    return inputResults![inputIndex].selectedOption;
  }

  void resetScoreState() {
    _isLoading = false;
    _isCompleted = false;
    _userInputResultsSet = false;
    _userInputs = [];
    _challengeNotes = [];
    challengeResult = GolfChallengeResult();
    // notifyListeners();
  }

  Future<double?> submit(
    String userId,
    GolfChallenge challenge,
    Stat latestStat,
    List<Skill> skills,
  ) async {
    if (validateInputs()) {
      challengeResult.challengeId = challenge.id;
      challengeResult.challengeName = challenge.name;
      challengeResult.difficulty = challenge.difficulty;
      challengeResult.dateTimeCreated = DateTime.now().toString();
      try {
        setIsLoading(true);

        // 1. GolfChallenge score
        challengeResult.percentage =
            _calculateChallengeScorePercentage(challenge);

        // 2. Element and skill score updates
        await _updateElementsAndSkillScores(
            userId, challenge, challengeResult.percentage, latestStat, skills);

        // 3. Save challenge result
        await _dataService.submitGolfChallengeResult(userId, challengeResult);

        // 4. reset - done after changing route in score view
        // resetState();

        return challengeResult.percentage;
      } catch (e) {
        print("ERRoR: Golf Submit Result: " + e.toString());
      }
    }
    setIsLoading(false);
    return null;
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  void setErrorMessage(String val) {
    _errorMessage = val;
    notifyListeners();
  }

  bool validateInputs() {
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

  double _calculateChallengeScorePercentage(GolfChallenge challenge) {
    // print('\n\n==================================== CHALLENGE RESULT SCORE: ${challenge.name}\n\n');

    // ** 1. Total points from each elements contribution
    int totalPoints = 0;
    challenge.weightings.weightings!
        .forEach((value) => totalPoints = totalPoints + value.weight!);
    // print('Challenge weightings: ' + challenge.weightings.getJson().toString());
    // print('\nChallenge weightings total: ' + totalPoints.toString());

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
        // TODO: find max score - this is not ideal but works
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

    if (challenge.benchmarks.threshold != null &&
        challenge.benchmarks.threshold.toDouble() > 0) {
      if (score >= challenge.benchmarks.threshold.toDouble()) {
        points = (_maxScore / _maxScore) * totalPoints;
      }
    }

    // ** 4. Adjusted points (times by difficulty)
    double difficulty = double.parse(challenge.difficulty!);
    double adjustedPoints = points * (difficulty / 5);

    // ** 5. GolfChallenge score as percentage
    double _calculatedScorePercentage = ((adjustedPoints / totalPoints) * 100);

    print(
        '\n*** CHALLENGE PERCENTAGE: ' + _calculatedScorePercentage.toString());
    return _calculatedScorePercentage;
  }

  _updateElementsAndSkillScores(
    String userId,
    GolfChallenge challenge,
    double? newScorePercentage,
    Stat updatedStatScores,
    List<Skill> skills,
  ) async {
    String? relevantSkillId = challenge.weightings.skillId;

    // *** 1. Get the challenge weighting bands
    List<ChallengeBand>? challengeBands =
        await _dataService.getChallengeBands(challenge.weightingBandId);
    print(
        'Challenge band id: ' + challenge.weightingBandId.toString() + '\n\n');

    // *** 2. Updated stat - only updates the specific skill-element - check if it exists or create a new one
    updatedStatScores.day = Utilities.getCurrentDayId();
    // updatedStatScores.name = 'Overall'; // what's this??
    int skillStatIndex =
        updatedStatScores.findSkillIndex(challenge.weightings.skillId);
    if (skillStatIndex == -1) {
      updatedStatScores.skillStats!.add(
        SkillStat(
            {'value': 0},
            challenge.weightings.skillId,
            Skill(
              {'name': challenge.weightings.skill},
            )),
      );
      skillStatIndex = 0;
    }
    print('0. SKILL STAT INDEX => ' + skillStatIndex.toString() + '\n');

    // *** 3. UPDATE SKILL-ELEMENTS SCORES
    await _updateElementScores(userId, challenge, newScorePercentage,
        updatedStatScores, challengeBands, skillStatIndex);

    // *** 2. UPDATE SKILL SCORE
    print('\n*** UPDATE SKILL SCORE');

    double totalSkillPercentageScore = 0;
    int fixedSkillIndex =
        skills.indexWhere((skill) => skill.id == relevantSkillId);
    // 1. Cycle through elements for the skill
    updatedStatScores.skillStats![skillStatIndex].elementStats!
        .forEach((elementStat) {
      // ** 1. Find element
      SkillElement skillElement = skills[fixedSkillIndex]
          .elements!
          .firstWhere((element) => element.id == elementStat.id);
      print('\n   ${skillElement.name} -> ' + skillElement.weight.toString());

      // ** 2. Add updated element score to new skill score - element score is weighted.
      totalSkillPercentageScore = totalSkillPercentageScore +
          (elementStat.value! * (skillElement.weight! / 100));
      print('   totalSkillPercentageScore: ' +
          totalSkillPercentageScore.toString());
    });
    updatedStatScores.skillStats![skillStatIndex].value =
        totalSkillPercentageScore;
    print('UPDATED SKILL SCORE => $totalSkillPercentageScore');

    // *** 3. UPDATE OVERALL SCORE
    print('\n*** UPDATE OVERALL SCORE');
    int totalSkills = skills.length + 1; // NB: plus 1 for physical score.
    double totalSkillsScore = 0;
    updatedStatScores.skillStats!.forEach(
        (skillStat) => totalSkillsScore = totalSkillsScore + skillStat.value!);

    // add physical score
    totalSkillsScore =
        totalSkillsScore + (updatedStatScores.physicalValue ?? 0);
    updatedStatScores.golfValue = totalSkillsScore / totalSkills;
    print('UPDATED OVERALL SCORE => ${updatedStatScores.golfValue}');

    // *** 4. Persist the updated stat
    print('\n*** FINAL UPDATED STAT => ' +
        updatedStatScores.getJson().toString());
    await _dataService.updateStat(userId, updatedStatScores);
  }

  _updateElementScores(
    String userId,
    GolfChallenge challenge,
    double? newScorePercentage,
    Stat updatedStatScores,
    List<ChallengeBand>? challengeBands,
    int skillStatIndex,
  ) async {
    // *** CYCLE THROUGH ELEMENT CONTRIBUTIONS
    print('\n\n *** UPDATE ELEMENT SCORES *** \n\n');
    for (ChallengeWeighting weighting in challenge.weightings.weightings!) {
      if (weighting.weight! > 0) {
        // ** 1. Either exists or create a new one
        int exisitingElementStatIndex = updatedStatScores
            .skillStats![skillStatIndex]
            .findElementIndex(weighting.element!.id);

        print('   1. EXISTING ELEMENT INDEX => ' +
            exisitingElementStatIndex.toString());
        bool elementStatAlreadyExists = true;
        ElementStat updatedElementStat = exisitingElementStatIndex > -1
            ? updatedStatScores.skillStats![skillStatIndex]
                .elementStats![exisitingElementStatIndex]
            : ElementStat(
                {'id': weighting.element!.id, 'value': 0}, weighting.element);

        print('ELEMENT NAME::: ' + weighting.getJson().toString());
        if (exisitingElementStatIndex == -1) {
          exisitingElementStatIndex = 0;
          elementStatAlreadyExists = false;
        }

        print('   2. ELEMENT ID - NAME => ' +
            updatedElementStat.id.toString() +
            ' - ' +
            updatedElementStat.name.toString());

        // ** 2. Unique index reference for skill element
        String skillIdElementId =
            '${challenge.weightings.skillId}${weighting.element!.id}';
        print('   3. SKILL-ELEMENT ID => ' + skillIdElementId.toString());

        // ** 3. Which band does current weighting fall into - get percentageContribution and noOfPrevResults of band
        double? elementPercentageContribution =
            weighting.getWeightingBandContribution(challengeBands!);
        int noOfPreviousResults =
            weighting.getNumberOfPrevResultsToUse(challengeBands)!;
        print(
            '   4. WEIGHTING BAND => percentageContribution - noOfPrevResults => $elementPercentageContribution - $noOfPreviousResults');

        // ** 4. While we're at it - set the new element band/contribution for the result
        challengeResult.elementContributions!.add(ElementContribution({
          'percentage': elementPercentageContribution,
          'skillIdElementId': skillIdElementId
        }));

        // ** 5. get previous results for this element
        List<GolfChallengeResult> previousResults =
            await _dataService.getLatestResultsForSkillElement(
                userId, skillIdElementId, noOfPreviousResults);
        print('   5. PREVIOUS RESULTS TOTAL => ' +
            previousResults.length.toString());

        // ** 6. Split/sort out into their respective bands
        Map<double?, List<double?>> filteredPreviousElementScores = {};
        previousResults.forEach((previousResult) {
          if (filteredPreviousElementScores[
                  previousResult.elementContributions![0].percentage] !=
              null) {
            filteredPreviousElementScores[
                    previousResult.elementContributions![0].percentage]!
                .add(previousResult.percentage);
          } else {
            filteredPreviousElementScores[previousResult.elementContributions![0]
                .percentage] = [previousResult.percentage];
          }
        });

        print('   6. BANDS SORTED via contributions => ' +
            filteredPreviousElementScores.toString());

        // ** 7. Add in new score to contribute
        if (filteredPreviousElementScores[elementPercentageContribution] !=
            null) {
          filteredPreviousElementScores[elementPercentageContribution]!
              .add(newScorePercentage);
        } else {
          filteredPreviousElementScores[elementPercentageContribution] = [
            newScorePercentage
          ];
        }

        print('   7. BANDS SORTED with new score => ' +
            filteredPreviousElementScores.toString());

        // ** Redistribution here!!!
        double bandsWithNoScoreTally = 0;
        double bandsWithScoreCount = 0;
        double redistributionVal = 0;
        // Iterable<double> contributionValueKeys = filteredPreviousElementScores.keys;

        Iterable<double?> contributionPercentageValues =
            filteredPreviousElementScores.keys;

        for (var band in challengeBands) {
          if (contributionPercentageValues.contains(band.percentage)) {
            bandsWithScoreCount++; // should always be min of 1
          } else {
            bandsWithNoScoreTally = bandsWithNoScoreTally + band.percentage!;
          }
        }
        redistributionVal = bandsWithNoScoreTally / bandsWithScoreCount;
        // cycle through bands and
        //    - bandsWithNoScoreTally = tally bands with no scores
        //    - bandsWithScoreCount = total count of bands with scores
        // redistrubtionVal = bandsWithNoScoreTally/bandsWithScoreCount
        // then add redistributionVal to below calc

        // print('AAAAAAAAAAAAAAAAA; ' + redistributionVal.toString() + '\n\n');

        // ** 8. Cycle through sorted bands and do calc
        List<double> elementContributionValues = [];
        for (double? key in contributionPercentageValues) {
          int totalScores = filteredPreviousElementScores[key]!.length;
          double totalScoresValue =
              filteredPreviousElementScores[key]!.reduce((a, b) => a! + b!)!;

          elementContributionValues.add((totalScoresValue / totalScores) *
              ((key! + redistributionVal) / 100));

          // print('BBBBBBBBBBBBBBBBBBBBBB: ' +
          //     key.toString() +
          //     ' => ' +
          //     (key + redistributionVal).toString());
        }

        print('   8. CONTRIBUTION VALUES => ' +
            elementContributionValues.toString());

        // ** 9. Finally add all together for new element score
        double updatedElementPercentage =
            elementContributionValues.reduce((a, b) => a + b);
        updatedElementStat.value = updatedElementPercentage;

        print('   9. UPDATED ELEMENT PERCENTAGE => ' +
            updatedElementPercentage.toString() +
            '\n');

        // ** 10. Add to the stat object if it didn't exist, otherwise replace it with new element stat
        if (!elementStatAlreadyExists) {
          updatedStatScores.skillStats![skillStatIndex].elementStats!
              .add(updatedElementStat);
        } else {
          updatedStatScores.skillStats![skillStatIndex]
              .elementStats![exisitingElementStatIndex] = updatedElementStat;
        }
      }
    }
  }
}

final golfScoreStateProvider = ChangeNotifierProvider((ref) => ScoreState());
