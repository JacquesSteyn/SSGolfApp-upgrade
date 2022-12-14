class PromotionalTicket {
  String? id;
  String? ticketNumber;
  String? drawID;
  String? userID;
  String? userName;
  DateTime? purchaseDate;

  PromotionalTicket([data, id]) {
    try {
      if (data != null) {
        this.id = id;
        this.ticketNumber =
            data['ticketNumber'] != null ? data['ticketNumber'] : "Unknown";
        this.drawID = data['drawID'];
        this.userID = data['userID'];
        this.userName = data['userName'];
        this.purchaseDate = data['purchaseDate'] != null
            ? DateTime.parse(data['purchaseDate'])
            : null;
      }
    } catch (e) {
      print("CREATING TICKET ERROR -> $e");
    }
  }

  PromotionalTicket.empty();

  PromotionalTicket.init(
      {this.drawID, this.userID, this.userName, this.purchaseDate});

  getJson() {
    return {
      'id': this.id,
      'drawID': this.drawID,
      'userID': this.userID,
      'userName': this.userName,
      'purchaseDate': this.purchaseDate.toString(),
      'ticketNumber': this.ticketNumber
    };
  }
}
