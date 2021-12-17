enum LimbDominance { Right, Left, Ambidextrous }

class PhysicalProfile {
  String height, weight, upperLimbDominance, lowerLimbDominance;

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

enum GolfStatus { Beginner, Amateur, ClubPro, LocalTourPro, InternationalTourPro }
enum GolfStance { Right, Left }

class GolfProfile {
  // GolfStatus status;
  // double handicap; // only if amateur or beginner
  // GolfStance stance;
  String status, stance, clubAffiliation, handicap;

  GolfProfile([data]) {
    if (data != null) {
      this.status = data['status'];
      this.handicap = data['handicap'].toString();
      this.stance = data['stance'];
      this.clubAffiliation = data['clubAffiliation'];
    }
  }

  getJson() {
    return {
      'status': this.status,
      'handicap': this.handicap,
      'stance': this.stance,
      'clubAffiliation': this.clubAffiliation,
    };
  }
}

class UserProfile {
  String id, email, type, name, gender, dateOfBirth, imageUrl;
  // country, state, city;
  GolfProfile golfProfile;
  PhysicalProfile physicalProfile;

  UserProfile([data]) {
    if (data != null) {
      this.id = data['id'];
      this.email = data['email'];
      this.type = data['type'];
      this.name = data['name'];
      this.gender = data['gender'];
      this.dateOfBirth = data['dateOfBirth'];
      this.imageUrl = data['imageUrl'];
      // this.country = data['country'];
      // this.state = data['state'];
      // this.city = data['city'];

      this.golfProfile = GolfProfile(data['golfProfile']);
      this.physicalProfile = PhysicalProfile(data['physicalProfile']);
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
      // 'country': this.country,
      // 'state': this.state,
      // 'city': this.city,
      'golfProfile': this.golfProfile.getJson(),
      'physicalProfile': this.physicalProfile.getJson(),
    };
  }

  List<String> userProfileValidation() {
    List<String> missingFields = [];
    if (this.name.isEmpty) {
      missingFields.add('Name');
    }
    // if (this.gender.isEmpty) {
    //   missingFields.add('Gender');

    // }
    //  if (this.dateOfBirth.isEmpty || this.dateOfBirth == null) {
    //   missingFields.add('Gender');

    // }

    return missingFields;
  }
}
