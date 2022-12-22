import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart'
    as FirebaseStoragePackage;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ss_golf/shared/models/benchmark.dart';
import 'package:ss_golf/shared/models/challenge_feedback.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/models/draws/redeemed_voucher.dart';
import 'package:ss_golf/shared/models/draws/ticket.dart';
import 'package:ss_golf/shared/models/golf/challenge_weightings.dart';
import 'package:ss_golf/shared/models/golf/golf_challenge_result.dart';
import 'package:ss_golf/shared/models/golf/skill.dart';
import 'package:ss_golf/shared/models/physical/attribute.dart';
import 'package:ss_golf/shared/models/physical/physical_challenge_result.dart';
import 'package:ss_golf/shared/models/stat.dart';
import 'package:ss_golf/shared/models/user.dart';

import '../shared/models/draws/transaction.dart';

// DATABASE PATHS
const usersPath = 'Users';
const resultsPath = 'Results';
const statsPath = 'Stats';
const challengeFeedbackPath = 'Feedback';
const countsPath = 'Counts';
// admin content
const overallPhysicalBenchPath = 'Content/Golf/OverallPhysical';
const skillsPath = 'Content/Golf/Skills';
const golfChallengesPath = 'Content/Golf/Challenges';
const physicalChallengesPath = 'Content/Physical/Challenges';
const attributesPath = 'Content/Physical/Attributes';
const weightingBandsPath = 'Content/Bands';
const promotionalDrawPath = 'PromotionalDraws';
const voucherPath = 'Vouchers';

class DataService {
  final dbReference = FirebaseDatabase.instance.ref();
  // final dbReference = FirebaseDatabase(
  //         databaseURL: 'https://smart-stats-golf-dev-database.firebaseio.com/')
  //     .reference();

  // *** ===================== USER

  Future<UserProfile> fetchUser(String userId) async {
    DatabaseEvent snapshot =
        await dbReference.child(usersPath).child(userId).once();
    return UserProfile(snapshot.snapshot.value);
  }

  Future<void> createUser(UserProfile user) async {
    String newUserPath = '$usersPath/${user.id}';
    await dbReference.child(newUserPath).set(user.getJson());
  }

  Future<void> updateUserProfile(UserProfile user) async {
    String userPath = '$usersPath/${user.id}';
    await dbReference.child(userPath).update(user.getJson());
  }

  Future<Benchmark> fetchOverallPhysicalBenchmark() async {
    try {
      DatabaseEvent snapshot =
          await dbReference.child(overallPhysicalBenchPath).once();

      return Benchmark(snapshot.snapshot.value);
    } catch (e) {
      debugPrint('Error -> fetchOverallPhysicalBenchmark -> $e');
      return new Benchmark.init();
    }
  }

  // *** ===================== SKILLS

  Future<List<Skill>> fetchSkills() async {
    try {
      DatabaseEvent snapshot = await dbReference
          .child(skillsPath)
          // .orderByChild('index')
          // .startAt(0)
          // .endAt(3)
          .once();

      Map values = snapshot.snapshot.value as Map<dynamic, dynamic>;
      List<Skill> skills = [];

      values.forEach((key, value) {
        skills.add(Skill(value, key));
      });

      skills.sort((a, b) => a.index!.compareTo(b.index!));

      return skills;
    } catch (e) {
      debugPrint('Error -> fetchSkills -> $e');
      return [];
    }
  }

  // *** ===================== ATTRIBUTES

  Future<List<Attribute>> fetchAttributes() async {
    try {
      DatabaseEvent source = await dbReference.child(attributesPath).once();
      DataSnapshot snapshot = source.snapshot;

      Map values = snapshot.value as Map<dynamic, dynamic>;
      List<Attribute> attributes = [];
      values.forEach((key, value) {
        var rawData = value;
        rawData["id"] = key;
        attributes.add(Attribute(rawData));
      });

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

    await updateUserChallengeCompleted(userId);
  }

  Future<void> submitPhysicalChallengeResult(
      String userId, PhysicalChallengeResult result) async {
    // String usersResultPath = '$resultsPath/$userId/physical';
    result.index = '${userId}_physical';
    print('PHYSICAL RESULTTT: ' + result.getJson().toString());
    await dbReference.child(resultsPath).push().set(result.getJson());

    await _incrementCount('$countsPath/Results/${result.challengeId}');

    await updateUserChallengeCompleted(userId);
  }

  Stream<DatabaseEvent> streamedChallenges(
      bool golf, String refName, String? refValue) {
    String basePath = golf ? golfChallengesPath : physicalChallengesPath;
    return dbReference
        .child(basePath)
        .orderByChild(refName)
        .equalTo(refValue)
        .onValue;
  }

  Future<List<ChallengeBand>?> getChallengeBands(
      String? weightingBandId) async {
    String bandsPath = '$weightingBandsPath/$weightingBandId';
    DatabaseEvent bandsSnapshot = await dbReference.child(bandsPath).once();

    Map value = bandsSnapshot.snapshot.value as Map<dynamic, dynamic>;

    var rawData = value['bands'] != null ? value['bands'] : [];

    return rawData
        .map<ChallengeBand>((rawBand) => ChallengeBand(rawBand))
        .toList();
  }

  Stream<DatabaseEvent> streamedChallengeResults(
      String userId, String refValue) {
    // String userResultsPath = '$resultsPath/$userId';
    return dbReference
        .child(resultsPath)

        // .orderByChild('dateTimeCreated')
        .orderByChild('index')
        .equalTo(refValue)
        .onValue;
  }

  // *** ===================== STATS

  Stream<DatabaseEvent> datedProgressionStatsStream(
    String? userId,
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
    DatabaseEvent latestStatSnapshot =
        await dbReference.child(userStatsPath).limitToLast(1).once();

    Map? value = latestStatSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    String? dayId = value?.keys.first;

    var rawData = dayId != null ? value![dayId] : null;

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
    DatabaseEvent latestResults = await dbReference
        .child(resultsPath)
        .orderByChild('$skillIdElementId/skillIdElementId_index')
        .equalTo('${skillIdElementId}_${userId}_golf')
        .limitToLast(
            noOfPreviousResults) // limitToFirst => check which is right!!
        .once();

    Map? value = latestResults.snapshot.value as Map<dynamic, dynamic>?;

    var latestResultsKeys = value?.keys ?? [];

    for (var key in latestResultsKeys) {
      previousResults.add(GolfChallengeResult(value![key], skillIdElementId));
    }
    return previousResults;
  }

  Future<List<PhysicalChallengeResult>> getLatestResultsForAttribute(
    String userId,
    String? attributeId,
    int noOfPreviousResults,
  ) async {
    List<PhysicalChallengeResult> previousResults = [];

    // String userResultsPath = '$resultsPath/$userId/physical';
    // get last 20 of each element weighting
    DatabaseEvent latestResults = await dbReference
        .child(resultsPath)
        .orderByChild('$attributeId/attributeId_index')
        .equalTo('${attributeId}_${userId}_physical')
        // .limitToFirst(20)
        .limitToLast(noOfPreviousResults)
        .once();

    Map? value = latestResults.snapshot.value as Map<dynamic, dynamic>?;

    var latestResultsKeys = value?.keys ?? [];

    for (var key in latestResultsKeys) {
      previousResults.add(PhysicalChallengeResult(value![key], attributeId));
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

  Future<String?> uploadImage(XFile pickedImage, String? uuid) async {
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

  Future<bool?> deleteImage(
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
        await countDbRef.runTransaction((Object? val) {
      if (val == null) {
        val = {'count': 1};
        return Transaction.success(val);
      } else {
        Map<String, dynamic> _val = Map<String, dynamic>.from(val as Map);
        _val['count'] = (_val['count'] ?? 0) + 1;
        return Transaction.success(_val);
      }
    });

    return transactionResult.committed;
  }

  // *** ===================== PROMOTIONAL DRAWS

  Future<List<PromotionalDraw>> fetchPromotionalDraws() async {
    try {
      DatabaseEvent snapshot = await dbReference
          .child(promotionalDrawPath)
          .orderByChild('drawStatus')
          .equalTo("open")
          .once();

      Map? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      List<PromotionalDraw> draws = [];

      if (values != null) {
        values.forEach((key, value) {
          draws.add(PromotionalDraw(value, key));
        });
      }
      return draws;
    } catch (e) {
      debugPrint('Error -> fetchPromotionalDraws -> $e');
      return [];
    }
  }

  Future<void> updateUserBalance(String? uuid, double newBalance) async {
    String userPath = '$usersPath/$uuid/balance';
    await dbReference.child(userPath).set(newBalance);
    return Future.value();
  }

  Future<void> updateUserPlan(String? uuid, String plan, bool freeTrail) async {
    String userPath = '$usersPath/$uuid/plan';
    await dbReference.child(userPath).set(plan);

    if (freeTrail) {
      String path = '$usersPath/$uuid/freeTrailExpireDate';
      DateTime now = DateTime.now();
      DateTime date = DateTime(now.year, now.month + 1, now.day);
      await dbReference.child(path).set(date.toString());
    }

    return Future.value();
  }

  Future<PromotionalDraw> fetchAPromotionalDraw(String drawID) async {
    String drawPath = '$promotionalDrawPath/$drawID';
    DatabaseEvent snapshot = await dbReference.child(drawPath).once();
    return PromotionalDraw([snapshot.snapshot.value, drawID]);
  }

  Future<bool> _incrementTicketSoldCount(String? drawID) async {
    String drawPath = '$promotionalDrawPath/$drawID/ticketsSold';
    DatabaseReference countDbRef = dbReference.child(drawPath);

    try {
      TransactionResult transactionResult =
          await countDbRef.runTransaction((Object? val) {
        if (val == null) {
          val = 1;
          return Transaction.success(val);
        } else {
          val = int.parse(val.toString()) + 1;
          return Transaction.success(val);
        }
      });

      return transactionResult.committed;
    } catch (e) {
      print("UNABLE TO INCREASE TICKETS_SOLD: " + e.toString());
      return false;
    }
  }

  Future<String?> purchaseTicket(
      PromotionalTicket ticket, PromotionalDraw draw, String? uuid) async {
    try {
      String ticketPath = '$promotionalDrawPath/${draw.id}/tickets';

      final newTicketKey = dbReference.child(ticketPath).push().key;

      int ticketNumber = 1;
      if (draw.ticketsSold == null || draw.ticketsSold == 0) {
        ticketNumber = 1;
      } else {
        ticketNumber = draw.ticketsSold! + 1;
      }

      final Map<String, Map> updates = {};

      ticket.ticketNumber = ticketNumber.toString();

      updates['$ticketPath/$newTicketKey'] = ticket.getJson();
      updates['$usersPath/$uuid/draws/${draw.id}/tickets/$newTicketKey'] =
          ticket.getJson();

      dbReference.update(updates);

      await this._incrementTicketSoldCount(draw.id);

      return newTicketKey;
    } catch (e) {
      print("PURCHASE TICKET: " + e.toString());
      return "failed";
    }
  }

  Future<List<PromotionalDraw>> fetchUserTickets(String? uuid) async {
    try {
      DatabaseEvent snapshot =
          await dbReference.child("$usersPath/$uuid/draws").once();

      Map? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      List<PromotionalDraw> draws = [];

      if (values != null) {
        values.forEach((key, value) async {
          DatabaseEvent snapshotTwo =
              await dbReference.child("$promotionalDrawPath/$key").once();

          Map originalDrawSnap =
              snapshotTwo.snapshot.value as Map<dynamic, dynamic>;

          originalDrawSnap['tickets'] = value['tickets'];

          draws.add(PromotionalDraw(originalDrawSnap, key));
        });
      }

      return draws;
    } catch (e) {
      print('Error -> fetchUserTickets for user -> ' + e.toString());
      return [];
    }
  }

  Future<List<UserTransaction>> fetchUserTransactions(
      String? uuid, String? startDate) async {
    try {
      DatabaseEvent snapshot = await dbReference
          .child("$usersPath/$uuid/transactions")
          .orderByChild("purchaseDate")
          .startAfter('$startDate-01 00:00:00')
          .endAt('$startDate-31 00:00:00')
          .limitToLast(300)
          .once();

      Map? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      List<UserTransaction> transactions = [];

      if (values != null && values.isNotEmpty) {
        values.forEach((key, value) async {
          transactions.add(UserTransaction(value, key));
        });
      }

      transactions.sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));

      return transactions;
    } catch (e) {
      print('Error -> fetchUserTransactions for user -> ' + e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchUserTodayTransaction(
      String? uuid, bool spent) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      double total = 0;
      final customDateFormat = DateFormat('y-M-dd');

      String toDate = customDateFormat.format(today);
      String fromDate = customDateFormat.format(yesterday);

      Map<String, dynamic> result = {};

      DatabaseEvent snapshot = await dbReference
          .child("$usersPath/$uuid/transactions")
          .orderByChild("purchaseDate")
          .startAfter('$fromDate 23:59:00.000001')
          .endAt('$toDate 23:59:00.000000')
          //.limitToFirst(1)
          .once();

      Map? values = snapshot.snapshot.value as Map<dynamic, dynamic>?;
      List<UserTransaction> transactions = [];

      if (values != null && values.isNotEmpty) {
        values.forEach((key, value) async {
          if (value['type'] != null) {
            if (spent && value['type'] == 'spent') {
              transactions.add(UserTransaction(value, key));
              total += value['price'] != null
                  ? double.parse(value['price'].toString())
                  : 0;
            } else if (!spent && value['type'] != 'spent') {
              transactions.add(UserTransaction(value, key));
              total += value['price'] != null
                  ? double.parse(value['price'].toString())
                  : 0;
            }
          }
        });
      }

      transactions.sort((a, b) => b.purchaseDate!.compareTo(a.purchaseDate!));

      if (transactions.length > 0) {
        result.addAll({'total': total, 'transaction': transactions.first});
      }

      return Future.value(result);
    } catch (e) {
      print('Error -> fetchUserTransactions for user -> ' + e.toString());
      return Future.value({});
    }
  }

  Future<String> createUserTransaction(
      UserTransaction transaction, String? uuid) async {
    try {
      String path = '$usersPath/$uuid/transactions';

      await dbReference.child(path).push().set(transaction.getJson());

      return "success";
    } catch (e) {
      print("CREATE TRANSACTION: " + e.toString());
      return "failed";
    }
  }

  // returns the value to be added to the balance
  Future<double> redeemVoucher(String voucherNumber, String? uuid) async {
    DatabaseEvent result = await dbReference
        .child(voucherPath)
        .orderByChild('voucherNumber')
        .equalTo(voucherNumber)
        .once();

    Map? values = result.snapshot.value as Map<dynamic, dynamic>?;

    double? updatePrice = 0;

    try {
      if (values != null) {
        Map value = {};
        String voucherID = "";
        values.forEach((key, currentValue) {
          value = currentValue;
          voucherID = key;
        });

        String status = value['voucherStatus'] ?? "";
        if (status.isNotEmpty && status == "Active") {
          int allowedEntries =
              int.parse(value['voucherAllowedEntries'].toString());
          Map redeemedUsers = value['redeemedVouchers'] ?? {};

          if (allowedEntries <= redeemedUsers.length) {
            if (voucherID.isNotEmpty) {
              String updatePath = "$voucherPath/$voucherID/voucherStatus";
              await dbReference.child(updatePath).set('Complete');
            }
            throw ("Max redemptions reached!");
          }

          if (redeemedUsers.length > 0) {
            bool allRedemption = true;
            redeemedUsers.forEach((key, value) {
              if (value['userID'] == uuid) {
                allRedemption = false;
              }
            });

            //-1 for vouchers already used by the current user
            if (allRedemption == false) {
              throw ("You already redeemed this voucher!");
            }
          }

          if (value['voucherExpireDate'] != null) {
            try {
              DateTime now = DateTime.now();
              DateTime voucherExpireDate =
                  DateTime.parse(value['voucherExpireDate']);

              if (now.compareTo(voucherExpireDate) > 0) {
                if (voucherID.isNotEmpty) {
                  String updatePath = "$voucherPath/$voucherID/voucherStatus";
                  await dbReference.child(updatePath).set('Expired');
                }

                return Future.value(0);
              }
            } catch (e) {
              throw ("Voucher expired");
            }
          }

          UserTransaction transaction = new UserTransaction.init(
              name: "Voucher redeemed",
              price: double.parse(value['voucherPrice'].toString()),
              purchaseDate: DateTime.now(),
              type: "voucher");

          String status = await this.createUserTransaction(transaction, uuid);
          if (status == 'success') {
            RedeemedVoucher voucher = RedeemedVoucher.init(
                userID: uuid, redeemedDate: DateTime.now());

            String? voucherID = value['id'];
            if (voucherID != null && voucherID.isNotEmpty) {
              String path = "$voucherPath/$voucherID/redeemedVouchers";
              await dbReference.child(path).push().set(voucher.getJson());
              updatePrice = transaction.price;
            }
          }
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }

    return Future.value(updatePrice);
  }

  Future<double> redeemGifts(String title, double price, String? uuid) async {
    double? updatePrice = 0;

    String type = "";
    switch (title) {
      case "Daily Check-In":
        type = "check-in";
        break;
      case "3 Day Check-In Streak":
        type = "3day";
        break;
      case "5 Day Check-In Streak":
        type = "3day";
        break;
      case "7 Day Check-In Streak":
        type = "3day";
        break;
      case "Complete Challenge (1/2)":
        type = "challenge";
        break;
      case "Complete Challenge (2/2)":
        type = "challenge";
        break;
    }

    try {
      UserTransaction transaction = new UserTransaction.init(
          name: title, price: price, purchaseDate: DateTime.now(), type: type);

      String status = await this.createUserTransaction(transaction, uuid);
      if (status == 'success') {
        updatePrice = transaction.price;
        if (type == "check-in" || type == "3day") {
          await this.resetUserStreak(uuid);
        } else {
          await this.resetUserChallengeCompleted(uuid);
        }
      }
    } catch (e) {
      print(e);
    }

    return Future.value(updatePrice);
  }

  Future<void> updateUserStreak(UserProfile user) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);

      if (user.lastClockInTime == null) {
        user.lastClockInTime = today;
      }

      final dateToCheck = user.lastClockInTime!;
      final aDate =
          DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

      if ((aDate == today && user.checkInStreak == 0) ||
          (aDate.compareTo(today) < 0) ||
          (aDate == yesterday && user.checkInStreak! >= 1 ||
              user.checkInStreak == null)) {
        DatabaseReference countDbRef =
            dbReference.child("$usersPath/${user.id}");

        await countDbRef.runTransaction((Object? val) {
          if (val == null) {
            return Transaction.success(val);
          } else {
            Map<String, dynamic> _val = Map<String, dynamic>.from(val as Map);

            if (_val['checkInStreak'] == null) {
              _val['checkInStreak'] = 1;
            } else {
              int checkInStreak = _val['checkInStreak'] as int;
              _val['checkInStreak'] = checkInStreak + 1;
            }

            _val['lastClockInTime'] = DateTime.now().toString();

            return Transaction.success(_val);
          }
        });
      }
    } catch (e) {
      print("USER STREAK UPDATE ERROR: $e");
    }

    return Future.value();
  }

  Future<void> resetUserStreak(String? userID) async {
    try {
      DatabaseReference countDbRef = dbReference.child("$usersPath/$userID");

      await countDbRef.runTransaction((Object? val) {
        if (val == null) {
          return Transaction.success(val);
        } else {
          Map<String, dynamic> _val = Map<String, dynamic>.from(val as Map);

          if (_val['checkInStreak'] != null) {
            _val['checkInStreak'] = 0;
          }

          DateTime now = DateTime.now();
          DateTime tomorrow =
              DateTime(now.year, now.month, now.day + 1, 0, 1, 1);

          _val['lastClockInTime'] = tomorrow.toString();

          return Transaction.success(_val);
        }
      });
    } catch (e) {
      print("RESET USER STREAK UPDATE ERROR: $e");
    }

    return Future.value();
  }

  Future<void> updateUserChallengeCompleted(String userID) async {
    try {
      DatabaseReference countDbRef =
          dbReference.child("$usersPath/$userID/completedChallenges");

      await countDbRef.runTransaction((Object? val) {
        if (val == null) {
          val = 1;
          return Transaction.success(val);
        } else {
          int completedChallenges = val as int;
          val = completedChallenges + 1;
          return Transaction.success(val);
        }
      });
    } catch (e) {
      print("USER CHALLENGE COMPLETED UPDATE ERROR: $e");
    }

    return Future.value();
  }

  Future<void> resetUserChallengeCompleted(String? userID) async {
    try {
      DatabaseReference countDbRef =
          dbReference.child("$usersPath/$userID/completedChallenges");

      await countDbRef.runTransaction((Object? val) {
        if (val == null) {
          return Transaction.success(0);
        } else {
          return Transaction.success(0);
        }
      });

      await updateUserChallengeRedemption(userID);
    } catch (e) {
      print("RESET USER CHALLENGE COMPLETED UPDATE ERROR: $e");
    }

    return Future.value();
  }

  Future<void> updateUserChallengeRedemption(String? userID) async {
    try {
      DatabaseReference countDbRef =
          dbReference.child("$usersPath/$userID/lastChallengeRedemption");

      return countDbRef.set(DateTime.now().toString());
    } catch (e) {
      print("USER CHALLENGE DATE ERROR: $e");
    }

    return Future.value();
  }
}
