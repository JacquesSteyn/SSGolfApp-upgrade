class SkillElement {
  String name, id;
  int weight;

  SkillElement([data]) {
    this.name = data['name'];
    this.id = data['id'].toString();
    this.weight = data['weight'];
  }

  getJson() {
    return {
      'id': this.id,
      'name': this.name,
      'weight': this.weight,
    };
  }
}
