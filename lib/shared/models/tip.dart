class TipGroup {
  String title;
  List<Tip> tips;

  TipGroup([data]) {
    if (data != null) {
      this.title = data['title'];
      this.tips = data['tips'].map<Tip>((tipData) => Tip(tipData)).toList();
    }
  }
}

class Tip {
  bool checked;
  String text;

  Tip([data]) {
    if (data != null) {
      this.checked = data['checked'];
      this.text = data['text'];
    }
  }
}
