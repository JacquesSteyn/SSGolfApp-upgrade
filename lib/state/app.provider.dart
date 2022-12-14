import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/benchmark.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/stat.dart';

final DataService _dataService = DataService();

class AppStateModel {
  // Skills & Attributes
  List<Skill> skills;
  Benchmark? overallPhysicalBenchmark;
  List<Attribute> attributes;
  // Stats
  List<Stat> stats;
  Stat? latestStat;
  // general
  bool isLoading;
  // already set
  bool initSet;

  AppStateModel(
      {this.skills = const [],
      this.overallPhysicalBenchmark,
      this.attributes = const [],
      this.stats = const [],
      this.latestStat,
      this.isLoading = false,
      this.initSet = false});
}

// class StatsStateModel {
//   List<Stat> stats;
//   Stat latestStat;
//   bool isLoading, initSet;

//   StatsStateModel(
//       {this.stats = const [],
//       this.latestStat,
//       this.isLoading = false,
//       this.initSet = false});
// }

class AppState extends StateNotifier<AppStateModel> {
  AppState([List<Skill>? skills, bool? isLoading])
      : super(
          AppStateModel(
            skills: [],
            overallPhysicalBenchmark: Benchmark.init(),
            attributes: [],
            stats: [],
            isLoading: false,
            latestStat: null,
          ),
        );

  void initAppState(String? userId) async {
    if (!state.initSet) {
      state.isLoading = true;
      // fetch skills
      List<Skill> fetchedSkills = await _dataService.fetchSkills();

      Benchmark fetchedOverallPhysicalBenchmark =
          await _dataService.fetchOverallPhysicalBenchmark();

      // fetch attributes
      List<Attribute> fetchedAttributes = await _dataService.fetchAttributes();

      // fetch latest state
      Stat latest = await _dataService.getLatestStat(
          '$userId', fetchedSkills, fetchedAttributes);

      // print('LATESTTTTT STAT:::: ' + latest.getJson().toString());

      // set state
      state = AppStateModel(
          skills: fetchedSkills,
          overallPhysicalBenchmark: fetchedOverallPhysicalBenchmark,
          attributes: fetchedAttributes,
          latestStat: latest,
          isLoading: false,
          initSet: true);
    }
  }

  void updateLatestStat(Stat newLatest) {
    state.latestStat = newLatest;
  }

  void resetAppState() {
    state = AppStateModel(
      skills: [],
      overallPhysicalBenchmark: new Benchmark.init(),
      attributes: [],
      stats: [],
      isLoading: false,
      latestStat: null,
    );
  }
}

final appStateProvider =
    StateNotifierProvider<AppState, AppStateModel>((ref) => AppState());

// class StatsState extends StateNotifier<StatsStateModel> {
//   StatsState([List<Stat> stats, Stat latestStat, bool isLoading])
//       : super(StatsStateModel());

//   void initLatestStat(String userId, List<Skill> skills) async {
//     state.isLoading = true;
//     Stat latest = await _dataService.getLatestStat('$userId/golf', skills);
//     // List<Stat> fetchedStats = await _dataService.fetchStats(userId, skills);
//     state =
//         StatsStateModel(stats: [], latestStat: latest, isLoading: false, initSet: true);
//   }
// }

// final statsStateProvider = StateNotifierProvider((ref) => StatsState());
