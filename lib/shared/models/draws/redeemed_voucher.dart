class RedeemedVoucher {
  String? userID;
  DateTime? redeemedDate;

  RedeemedVoucher([input, key]) {
    try {
      userID = input['userID'] ?? "";
      redeemedDate = input['redeemedDate'] != null
          ? DateTime.parse(input['redeemedDate'])
          : null;
    } catch (e) {
      print('REDEEMED VOUCHER ERROR: $e');
    }
  }

  RedeemedVoucher.init({this.userID, this.redeemedDate});

  getJson() {
    return {
      'userID': userID,
      'redeemedDate': redeemedDate.toString(),
    };
  }
}
