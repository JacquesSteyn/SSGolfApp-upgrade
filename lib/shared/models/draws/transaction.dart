class UserTransaction {
  String? id;
  String? name;
  double? price;
  String?
      type; // used for the images (gift, check-in, challenge, 3day, voucher, spent)
  DateTime? purchaseDate;

  UserTransaction([data, id]) {
    try {
      if (data != null) {
        this.id = id;
        this.price = data['price'] != null
            ? double.parse(data['price'].toString() ?? "0")
            : 0;
        this.name = data['name'] ?? "";
        this.type = data['type'];
        this.purchaseDate = data['purchaseDate'] != null
            ? DateTime.parse(data['purchaseDate'])
            : null;
      }
    } catch (e) {
      print("CREATING TRANSACTION ERROR -> $e");
    }
  }

  UserTransaction.init({this.name, this.price, this.purchaseDate, this.type});

  getJson() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'type': this.type,
      'purchaseDate': this.purchaseDate.toString(),
    };
  }
}
