class ChallengeFeedback {
  String? userId, challengeId, ratingNotes;
  double? rating;

  ChallengeFeedback([data]) {
    if (data != null) {
      this.userId = data['userId'];
      this.challengeId = data['challengeId'];
      this.ratingNotes = data['ratingNotes'];
      this.rating = data['rating'];
    }
  }

  getJson() {
    return {
      'userId': this.userId,
      'challengeId': this.challengeId,
      'ratingNotes': this.ratingNotes,
      'rating': this.rating,
    };
  }
}
