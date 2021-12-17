import 'package:ss_golf/shared/models/benchmark.dart';
import 'package:ss_golf/shared/models/challenge_input.dart';
import 'package:ss_golf/shared/models/challenge_input_result.dart';
import 'package:ss_golf/shared/models/challenge_note.dart';
import 'package:ss_golf/shared/models/challenge_note_result.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';
import 'package:ss_golf/shared/models/tip.dart';

class GolfChallenge {
  String name,
      id,
      description,
      purpose,
      duration,
      type,
      difficulty,
      videoUrl,
      imageUrl;
  List<String> equipment, instructions;
  List<ChallengeNote> notes;

  List<TipGroup> tipGroups;

  bool active;

  ChallengeWeightings weightings;
  List<ChallengeInput> inputs;
  // List<dynamic> inputs;

  String weightingBandId;
  Benchmark benchmarks;

  GolfChallenge([data, key]) {
    if (data != null) {
      this.name = data['name'];
      this.id = data['id'] ?? key;
      this.description = data['description'];
      this.purpose = data['purpose'];
      this.duration = data['duration'];
      this.type = data['type']; // range, course
      this.difficulty = data['difficulty'];
      this.videoUrl = data['videoUrl'];
      this.imageUrl = data['imageUrl'];
      // lists
      this.equipment = data['equipment'] != null
          ? data['equipment'].map<String>((text) => text.toString()).toList()
          : [];
      this.instructions = data['instructions'] != null
          ? data['instructions'].map<String>((text) => text.toString()).toList()
          : [];
      this.tipGroups = data['tips'] != null
          ? data['tips'].map<TipGroup>((tipData) => TipGroup(tipData)).toList()
          : [];
      this.notes = [];
      int tempNotesIndex = 0;
      (data['notes'] ?? []).forEach((noteData) {
        print('NOTESSSSS: ' + noteData.toString());
        this.notes.add(ChallengeNote(noteData, tempNotesIndex));
        tempNotesIndex++;
      });
      // add custom notes
      this.notes.add(ChallengeNote({'title': 'Custom notes'}, tempNotesIndex));

      this.active = data['active'];

      // form inputs
      var inputsData = data['fieldInputs'];
      // print('FIELD INPUTS: ' + data['equipment'].toString());
      // var fieldInputs = inputsData != null ? inputsData : [];
      int tempInputsIndex = 0;
      this.inputs = [];
      inputsData.forEach((fieldInput) {
        if (fieldInput != null) {
          if (fieldInput['type'] == 'select') {
            inputs.add(ChallengeInputSelect(fieldInput, tempInputsIndex));
          } else if (fieldInput['type'] == 'score' ||
              fieldInput['type'] == 'inverted-score') {
            inputs.add(ChallengeInputScore(fieldInput, tempInputsIndex));
          } else if (fieldInput['type'] == 'select-score') {
            inputs.add(ChallengeInputSelectScore(fieldInput, tempInputsIndex));
          }
        }
        tempInputsIndex++;
      });

      // weightings
      this.weightings = ChallengeWeightings(data['weightings']);
      this.benchmarks = data['benchmarks'] != null
          ? Benchmark(data['benchmarks'])
          : Benchmark.init();
      // bands
      this.weightingBandId = data['weightingBandId'];
    }
  }

  List<ChallengeInputResult> getAllChallengeInputResults() {
    List<ChallengeInputResult> challengeInputResults = [];

    this.inputs.forEach((input) {
      // print('NAME: ' + input.name.toString() + ' INDXE: ' + input.index.toString());

      if (input.type == 'score') {
        challengeInputResults.add(ChallengeInputScoreResult(
            {'name': input.name, 'type': input.type, 'index': input.index}));
      } else if (input.type == 'select-score') {
        challengeInputResults.add(ChallengeInputSelectScoreResult({
          'name': input.name,
          'type': input.type,
          // 'selectedOption': input.selectionOptions[0],
          'index': input.index
        }));
      } else {
        challengeInputResults.add(ChallengeInputSelectResult({
          'name': input.name,
          'type': input.type,
          // 'selectedOption': input.selectionOptions[0],
          'index': input.index
        }));
      }
    });
    return challengeInputResults;
  }

  List<ChallengeNoteResult> getChallengeNoteResults() {
    return this
        .notes
        .map<ChallengeNoteResult>((note) =>
            ChallengeNoteResult({'title': note.title, 'index': note.index}))
        .toList();
  }
}
