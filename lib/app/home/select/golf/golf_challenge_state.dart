import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GolfChallengeTypeFilter { Range, Course, All }

class GolfChallengeState extends ChangeNotifier {
  // final DataService _dataService = DataService();
  bool _filterChangesMade = true;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

// *** total tally
  int _totalResults = 0;
  int get totalResults => _totalResults;
  void setTotalResults(int val) {
    if (_filterChangesMade) {
      _totalResults = val;
      _filterChangesMade = false;
      notifyListeners();
    }
  }

  // ** Filter fields
  GolfChallengeTypeFilter _challengeTypeFilter = GolfChallengeTypeFilter.All;
  GolfChallengeTypeFilter get challengeTypeFilter => _challengeTypeFilter;
  void setChallengeType(GolfChallengeTypeFilter type) {
    _challengeTypeFilter = type;
    _filterChangesMade = true;
    notifyListeners();
  }

  // double _difficultyFilter = 0;
  // double get difficultyFilter => _difficultyFilter;
  // void setChalle(double difficultyVal) {
  //   _difficultyFilter = difficultyVal;
  //   _filterChangesMade = true;
  //   notifyListeners();
  // }
}

final golfChallengeStateProvider = ChangeNotifierProvider((ref) => GolfChallengeState());
