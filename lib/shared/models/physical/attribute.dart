class Attribute {
  String? name, id;
  double? weight;

  Attribute([data]) {
    // print('ATTRIBURE INIT DATA;  ' + data.toString());
    this.name = data['name'];
    this.id = data['id'].toString();
    this.weight = data['weight'];
  }
}
