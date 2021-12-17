import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'
    as FirebaseStoragePackage;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_golf/shared/models/challenge_feedback.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge_result.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge_result.dart';
import 'package:ss_golf/shared/models/stat.dart';
import 'package:ss_golf/shared/models/user.dart';

// DATABASE PATHS
const usersPath = 'Users';
const resultsPath = 'Results';
const statsPath = 'Stats';
const challengeFeedbackPath = 'Feedback';
const countsPath = 'Counts';
// admin content
const skillsPath = 'Content/Golf/Skills';
const golfChallengesPath = 'Content/Golf/Challenges';
const physicalChallengesPath = 'Content/Physical/Challenges';
const attributesPath = 'Content/Physical/Attributes';
const weightingBandsPath = 'Content/Bands';

class DataService {
  final dbReference = FirebaseDatabase.instance.reference();
  // final dbReference = FirebaseDatabase(
  //         databaseURL: 'https://smart-stats-golf-dev-database.firebaseio.com/')
  //     .reference();

  // *** ===================== USER

  Future<UserProfile> fetchUser(String userId) async {
    DataSnapshot snapshot =
        await dbReference.child(usersPath).child(userId).once();
    return UserProfile(snapshot.value);
  }

  Future<void> createUser(UserProfile user) async {
    String newUserPath = '$usersPath/${user.id}';
    await dbReference.child(newUserPath).set(user.getJson());
  }

  Future<void> updateUserProfile(UserProfile user) async {
    String userPath = '$usersPath/${user.id}';
    await dbReference.child(userPath).update(user.getJson());
  }

  // *** ===================== SKILLS

  Future<List<Skill>> fetchSkills() async {
    try {
      DataSnapshot snapshot = await dbReference
          .child(skillsPath)
          // .orderByChild('index')
          // .startAt(0)
          // .endAt(3)
          .once();

      var skillKeys = snapshot.value.keys;

      List<Skill> skills = skillKeys
          .map<Skill>((key) => Skill(snapshot.value[key], key))
          .toList();

      skills.sort((a, b) => a.index.compareTo(b.index));

      return skills;
    } catch (e) {
      debugPrint('Error -> fetchSkills -> $e');
      return [];
    }
  }

  // *** ===================== ATTRIBUTES

  Future<List<Attribute>> fetchAttributes() async {
    try {
      DataSnapshot snapshot = await dbReference.child(attributesPath).once();

      var attributeKeys = snapshot.value.keys;
      List<Attribute> attributes = attributeKeys.map<Attribute>((key) {
        var rawData = snapshot.value[key];
        rawData["id"] = key;
        return Attribute(rawData);
      }).toList();

      return attributes;
    } catch (e) {
      debugPrint('Error -> fetchAttributes -> $e');
      return [];
    }
  }

  // *** ===================== CHALLENGES

  Future<void> submitGolfChallengeResult(
      String userId, GolfChallengeResult result) async {
    // String usersResultPath = '$resultsPath/$userId/golf';
    result.index = '${userId}_golf';
    // print('GOLF RESULTTT: ' + result.getJson().toString());
    await dbReference.child(resultsPath).push().set(result.getJson());

    await _incrementCount('$countsPath/Results/${result.challengeId}');
  }

  Future<void> submitPhysicalChallengeResult(
      String userId, PhysicalChallengeResult result) async {
    // String usersResultPath = '$resultsPath/$userId/physical';
    result.index = '${userId}_physical';
    print('PHYSICAL RESULTTT: ' + result.getJson().toString());
    await dbReference.child(resultsPath).push().set(result.getJson());
    await _incrementCount('$countsPath/Results/${result.challengeId}');
  }

  Stream<Event> streamedChallenges(bool golf, String refName, String refValue) {
    String basePath = golf ? golfChallengesPath : physicalChallengesPath;
    return dbReference
        .child(basePath)
        .orderByChild(refName)
        .equalTo(refValue)
        .onValue;
  }

  Future<List<ChallengeBand>> getChallengeBands(String weightingBandId) async {
    String bandsPath = '$weightingBandsPath/$weightingBandId';
    DataSnapshot bandsSnapshot = await dbReference.child(bandsPath).once();

    var rawData = bandsSnapshot.value['bands'] != null
        ? bandsSnapshot.value['bands']
        : [];

    return rawData
        .map<ChallengeBand>((rawBand) => ChallengeBand(rawBand))
        .toList();
  }

  Stream<Event> streamedChallengeResults(String userId, String refValue) {
    // String userResultsPath = '$resultsPath/$userId';
    return dbReference
        .child(resultsPath)

        // .orderByChild('dateTimeCreated')
        .orderByChild('index')
        .equalTo(refValue)
        .onValue;
  }

  // *** ===================== STATS

  Stream<Event> datedProgressionStatsStream(
    String userId,
    String startDay,
    String endDay,
  ) {
    print('START: ' + startDay + '   END: ' + endDay);
    return dbReference
        .child('$statsPath/$userId')
        .orderByKey()
        .startAt(startDay)
        .endAt(endDay)
        .onValue;
  }

  Future<void> setPercentageScore(String path, double percentage) async {
    String usersResultPath = '$statsPath/$path';
    await dbReference.child(usersResultPath).set({percentage});
  }

  Future<Stat> getLatestStat(
      String userId, List<Skill> skills, List<Attribute> attributes) async {
    String userStatsPath = '$statsPath/$userId';
    DataSnapshot latestStatSnapshot =
        await dbReference.child(userStatsPath).limitToLast(1).once();

    String dayId = latestStatSnapshot.value?.keys?.first;

    var rawData = dayId != null ? latestStatSnapshot.value[dayId] : null;

    return Stat(rawData, dayId, skills, attributes);
  }

  Future<void> updateStat(String userId, Stat updatedStat) async {
    String updatedStatPath = '$statsPath/$userId/${updatedStat.day}';
    await dbReference.child(updatedStatPath).set(updatedStat.getJson());
  }

  Future<List<GolfChallengeResult>> getLatestResultsForSkillElement(
    String userId,
    String skillIdElementId,
    int noOfPreviousResults,
  ) async {
    List<GolfChallengeResult> previousResults = [];

    // String userResultsPath = '$resultsPath/$userId/golf';
    // get last 20 of each element weighting
    DataSnapshot latestResults = await dbReference
        .child(resultsPath)
        .orderByChild('$skillIdElementId/skillIdElementId_index')
        .equalTo('${skillIdElementId}_${userId}_golf')
        .limitToLast(
            noOfPreviousResults) // limitToFirst => check which is right!!
        .once();

    var latestResultsKeys = latestResults.value?.keys ?? [];

    for (var key in latestResultsKeys) {
      previousResults
          .add(GolfChallengeResult(latestResults.value[key], skillIdElementId));
    }
    return previousResults;
  }

  Future<List<PhysicalChallengeResult>> getLatestResultsForAttribute(
    String userId,
    String attributeId,
    int noOfPreviousResults,
  ) async {
    List<PhysicalChallengeResult> previousResults = [];

    // String userResultsPath = '$resultsPath/$userId/physical';
    // get last 20 of each element weighting
    DataSnapshot latestResults = await dbReference
        .child(resultsPath)
        .orderByChild('$attributeId/attributeId_index')
        .equalTo('${attributeId}_${userId}_physical')
        // .limitToFirst(20)
        .limitToLast(noOfPreviousResults)
        .once();

    var latestResultsKeys = latestResults.value?.keys ?? [];

    // print('ATTRRRRR ID ' + attributeId.toString());
    // print('LAST 20000000000000000000000000000000 ' + last20keys.toString());

    for (var key in latestResultsKeys) {
      previousResults
          .add(PhysicalChallengeResult(latestResults.value[key], attributeId));
    }
    return previousResults;
  }

  // *** ===================== FEEDBACK

  Future<void> submitChallengeFeedback(ChallengeFeedback feedback) async {
    // String feedbackPath = '$challengeFeedbackPath/${feedback.userId}';
    print('JSON Feedback: ' + feedback.getJson().toString());
    await dbReference
        .child(challengeFeedbackPath)
        .push()
        .set(feedback.getJson());
    await _incrementCount('$countsPath/Feedback/${feedback.challengeId}');
  }

  // *** ===================== IMAGES

  Future<String> uploadImage(PickedFile pickedImage, String uuid) async {
    try {
      final FirebaseStoragePackage.Reference imagesRef =
          FirebaseStoragePackage.FirebaseStorage.instance.ref().child('Images');
      String timeKey = DateTime.now().millisecondsSinceEpoch.toString();
      String imagePath = '${uuid}_$timeKey';

      final FirebaseStoragePackage.UploadTask uploadTask =
          imagesRef.child(imagePath + ".jpg").putFile(File(pickedImage.path));

      var imageUrl = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();

      return imageUrl.toString();
    } catch (e) {
      print('ERROR -> Image upload failed -> ' + e.toString());
      return null;
    }
  }

  Future<bool> deleteImage(
    String fileUrl,
  ) async {
    try {
      print('Trying to delete at url: ' + fileUrl);
      FirebaseStoragePackage.Reference imageRef =
          FirebaseStoragePackage.FirebaseStorage.instance.refFromURL(fileUrl);

      await imageRef.delete();
      print('Data -> deleteImage -> ' + imageRef.fullPath.toString());
      return true;
    } catch (e) {
      print('ERROR -> deleteImage -> ' + e.toString());
      return null;
    }
  }

  // *** ===================== AGGREGATIONS/COUNTS

  Future<bool> _incrementCount(String countRef) async {
    DatabaseReference countDbRef = dbReference.child(countRef);

    TransactionResult transactionResult =
        await countDbRef.runTransaction((MutableData nodeData) async {
      // ** if null/doesn't exist
      if (nodeData.value == null || nodeData.value['count'] == null) {
        nodeData.value = {'count': 1};
      } else {
        nodeData.value['count'] = (nodeData.value['count'] ?? 0) + 1;
      }
      return nodeData;
    });

    return transactionResult.committed;
  }
}
