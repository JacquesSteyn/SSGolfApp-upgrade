import 'package:ss_golf/shared/models/draws/ticket.dart';

class PromotionalDraw {
  String? id;
  String? name;
  String? drawType; //free - pro (def: pro)
  DateTime? drawDate;
  int? ticketsSold;
  late int maxPerUserEntries;
  late int totalTicketsIssued;
  double? ticketPrice;
  late double retailPrice;
  String? aboutOffer;
  List<String>? rules;
  late String sponsorWhoWeAre;
  late String sponsorName;
  late String sponsorMission;
  late String sponsorOrigin;
  late String sponsorFindUs;
  String? sponsorLink;
  String? image1Url;
  String? image2Url;
  String? image3Url;
  String? webImageUrl;
  String? drawWinnerID;
  String? winningTicketID;
  String? drawStatus; //closed - open (def: open)
  List<PromotionalTicket>? tickets;

  PromotionalDraw([data, id]) {
    if (data != null) {
      try {
        this.id = id;
        this.name = data['name'] ?? "Unknown";
        this.drawType = data['drawType'] ?? "pro";
        this.drawDate =
            data['drawDate'] != null ? DateTime.parse(data['drawDate']) : null;
        this.ticketsSold = data['ticketsSold'] != null
            ? int.parse(data['ticketsSold'].toString())
            : 0;
        this.maxPerUserEntries = data['maxPerUserEntries'] != null
            ? int.parse(data['maxPerUserEntries'].toString())
            : 0;
        this.totalTicketsIssued = data['totalTicketsIssued'] != null
            ? int.parse(data['totalTicketsIssued'].toString())
            : 0;
        this.ticketPrice = data['ticketPrice'] != null
            ? double.parse(data['ticketPrice'].toString())
            : 0;
        this.retailPrice = data['retailPrice'] != null
            ? double.parse(data['retailPrice'].toString())
            : 0;
        this.aboutOffer = data['aboutOffer'];
        this.rules = data['rules'] != null
            ? data['rules'].map<String>((text) => text.toString()).toList()
            : [];
        this.sponsorName = data['sponsorName'] ?? "Unknown";
        this.sponsorWhoWeAre = data['sponsorWhoWeAre'] ?? "Unknown";
        this.sponsorMission = data['sponsorMission'] ?? "Unknown";
        this.sponsorOrigin = data['sponsorOrigin'] ?? "Unknown";
        this.sponsorFindUs = data['sponsorFindUs'] ?? "Unknown";
        this.sponsorLink = data['sponsorLink'];
        this.image1Url = data['image1Url'] ?? "";
        this.image2Url = data['image2Url'] ?? "";
        this.image3Url = data['image3Url'] ?? "";
        this.webImageUrl = data['webImageUrl'] ?? "";
        this.drawWinnerID = data['drawWinnerID'] ?? "";
        this.winningTicketID = data['winningTicketID'] ?? "";
        this.drawStatus = data['drawStatus'] ?? "closed";

        if (data['tickets'] != null) {
          Map values = data['tickets'];
          List<PromotionalTicket> tempTickets = [];

          values.forEach((key, value) {
            PromotionalTicket ticket = PromotionalTicket(value, key);
            tempTickets.add(ticket);
          });
          this.tickets = tempTickets;
        } else {
          this.tickets = [];
        }
      } catch (e) {
        print("CREATING DRAW INSTANCE: " + e.toString());
      }
    }
  }

  int getTicketsLeft() {
    return this.totalTicketsIssued - this.ticketsSold!;
  }

  Future<TicketWinner?> getTicketWinner() {
    if (drawStatus == "closed") {
      if (tickets!.isNotEmpty &&
          winningTicketID!.isNotEmpty &&
          drawWinnerID!.isNotEmpty) {
        try {
          PromotionalTicket ticket =
              tickets!.firstWhere((ticket) => ticket.id == winningTicketID);
          TicketWinner ticketWinner = new TicketWinner(
              ticketID: winningTicketID,
              userID: drawWinnerID,
              userName: ticket.userName,
              drawID: id);
          return Future.value(ticketWinner);
        } catch (e) {
          return Future.value(null);
        }
      }
    }
    return Future.value(null);
  }

  bool hasWinningTicket() {
    if (this.tickets!.isNotEmpty) {
      try {
        this.tickets!.firstWhere((ticket) => this.winningTicketID == ticket.id);
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  PromotionalTicket? getMostRecentTicket() {
    try {
      this.tickets!.sort((a, b) => a.purchaseDate!.compareTo(b.purchaseDate!));
      return this.tickets!.last;
    } catch (e) {
      return null;
    }
  }
}

class TicketWinner {
  String? ticketID, userID, userName, drawID;

  TicketWinner({this.ticketID, this.userID, this.userName, this.drawID});
}
