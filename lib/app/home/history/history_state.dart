import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ss_golf/services/auth_service.dart';
import 'package:ss_golf/services/data_service.dart';

enum ChallengeTypeFilter { Golf, Physical }

class HistoryState extends ChangeNotifier {
  final DataService _dataService = DataService();
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
  ChallengeTypeFilter _challengeTypeFilter = ChallengeTypeFilter.Golf;
  ChallengeTypeFilter get challengeTypeFilter => _challengeTypeFilter;
  void setTypeFilter(ChallengeTypeFilter type) {
    _challengeTypeFilter = type;
    _filterChangesMade = true;
    notifyListeners();
  }

  double _difficultyFilter = -1;
  double get difficultyFilter => _difficultyFilter;
  void setDifficultyFilter(double difficultyVal) {
    _difficultyFilter = difficultyVal;
    _filterChangesMade = true;
    notifyListeners();
  }

  // *** Stream
  Stream<DatabaseEvent> challengeResultsStream(String userId) {
    String type = 'golf';
    if (_challengeTypeFilter == ChallengeTypeFilter.Physical) {
      type = 'physical';
    }
    return _dataService.streamedChallengeResults(userId, '${userId}_$type');
  }
}

final historyStateProvider = ChangeNotifierProvider((ref) => HistoryState());
