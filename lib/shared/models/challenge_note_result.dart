class ChallengeNoteResult {
  String title, selectedOption;
  int index;

  ChallengeNoteResult([data]) {
    if (data != null) {
      this.title = data['title'];
      this.selectedOption = data['selectedOption']; // ?? 'none';
      this.index = data['index'];
    }
  }

  getJson() {
    if (this.selectedOption == null) {
      return {
        'title': "",
        'selectedOption': "",
      };
    } else {
      return {
        'title': this.title,
        'selectedOption': this.selectedOption,
      };
    }
  }
}
