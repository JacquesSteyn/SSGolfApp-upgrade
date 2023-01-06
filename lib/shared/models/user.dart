enum LimbDominance { Right, Left, Ambidextrous }

class PhysicalProfile {
  String? height, weight, upperLimbDominance, lowerLimbDominance;

  PhysicalProfile([data]) {
    if (data != null) {
      this.height = data['height'];
      this.weight = data['weight'];
      this.upperLimbDominance = data['upperLimbDominance'];
      this.lowerLimbDominance = data['lowerLimbDominance'];
    }
  }

  getJson() {
    return {
      'height': this.height,
      'weight': this.weight,
      'upperLimbDominance': this.upperLimbDominance,
      'lowerLimbDominance': this.lowerLimbDominance,
    };
  }
}

enum GolfStatus {
  Beginner,
  Amateur,
  ClubPro,
  LocalTourPro,
  InternationalTourPro
}

enum GolfStance { Right, Left }

class GolfProfile {
  // GolfStatus status;
  // double handicap; // only if amateur or beginner
  // GolfStance stance;
  String? status, stance, clubAffiliation, handicap;

  GolfProfile([data]) {
    if (data != null) {
      this.status = data['status'];
      this.handicap = (data['handicap'].toString());
      this.stance = data['stance'];
      this.clubAffiliation = data['clubAffiliation'];
    }
  }

  getJson() {
    return {
      'status': this.status,
      'handicap': this.handicap ?? 0,
      'stance': this.stance,
      'clubAffiliation': this.clubAffiliation,
    };
  }
}

class UserProfile {
  String? id, email, type, name, gender, dateOfBirth, imageUrl, plan;
  double? balance;
  late GolfProfile golfProfile;
  late PhysicalProfile physicalProfile;

  int? checkInStreak;
  int? redeemStreak;
  int? redeemDay3Streak;
  int? redeemDay5Streak;
  int? redeemDay7Streak;
  late int completedChallenges;
  DateTime? lastClockInTime; //Only the first clock in for the day

  DateTime?
      lastChallengeRedemption; //Only allow one challenge a day to be redeemed

  DateTime?
      lastChallengeRedemptionTwo; //Only allow one challenge a day to be redeemed

  DateTime? freeTrailExpireDate;

  UserProfile([data]) {
    try {
      if (data != null) {
        this.id = data['id'];
        this.email = data['email'];
        this.type = data['type'];
        this.name = data['name'];
        this.gender = data['gender'];
        this.dateOfBirth = data['dateOfBirth'];
        this.imageUrl = data['imageUrl'];
        this.plan = data['plan'] ?? "free";

        this.balance = data['balance'] != null
            ? double.parse(data['balance'].toString())
            : 0;

        this.checkInStreak =
            data['checkInStreak'] != null ? data['checkInStreak'] : 0;

        this.redeemStreak =
            data['redeemStreak'] != null ? data['redeemStreak'] : 0;

        this.redeemDay3Streak =
            data['redeemDay3Streak'] != null ? data['redeemDay3Streak'] : 0;

        this.redeemDay5Streak =
            data['redeemDay5Streak'] != null ? data['redeemDay5Streak'] : 0;

        this.redeemDay7Streak =
            data['redeemDay7Streak'] != null ? data['redeemDay7Streak'] : 0;

        this.completedChallenges = data['completedChallenges'] != null
            ? data['completedChallenges']
            : 0;

        this.lastClockInTime = data['lastClockInTime'] != null
            ? DateTime.parse(data['lastClockInTime'])
            : null;

        this.lastChallengeRedemption = data['lastChallengeRedemption'] != null
            ? DateTime.parse(data['lastChallengeRedemption'])
            : null;

        this.lastChallengeRedemptionTwo =
            data['lastChallengeRedemptionTwo'] != null
                ? DateTime.parse(data['lastChallengeRedemptionTwo'])
                : null;

        this.freeTrailExpireDate = data['freeTrailExpireDate'] != null
            ? DateTime.parse(data['freeTrailExpireDate'])
            : null;

        this.golfProfile = GolfProfile(data['golfProfile']);
        this.physicalProfile = PhysicalProfile(data['physicalProfile']);
      }
    } catch (e) {
      print("ERROR INIT USER: $e");
    }
  }

  getJson() {
    return {
      'id': this.id,
      'email': this.email,
      'type': this.type,
      'name': this.name,
      'gender': this.gender,
      'dateOfBirth': this.dateOfBirth,
      'imageUrl': this.imageUrl,
      'balance': this.balance,
      'golfProfile': this.golfProfile.getJson(),
      'physicalProfile': this.physicalProfile.getJson(),
      'plan': this.plan
    };
  }

  List<String> userProfileValidation() {
    List<String> missingFields = [];
    if (this.name!.isEmpty) {
      missingFields.add('Name');
    }

    return missingFields;
  }
}
