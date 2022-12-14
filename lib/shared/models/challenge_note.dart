class ChallengeNote {
  String? title;
  List<String>? options;
  int? index;

  ChallengeNote([data, index]) {
    if (data != null) {
      this.title = data['title'];
      this.options = data['options'] != null
          ? data['options'].map<String>((text) => text.toString()).toList()
          : [];
      this.index = index;
    }
  }

  getJson() {
    return {
      'title': this.title,
      'options': this.options,
    };
  }
}
