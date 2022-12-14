import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/draws/promotional_draw.dart';
import 'package:ss_golf/shared/models/user.dart';
import 'package:ss_golf/state/auth.provider.dart';

import '../shared/models/draws/ticket.dart';
import '../shared/models/draws/transaction.dart';

final DataService _dataService = DataService();

class DrawsStateModel {
  bool isLoading;

  // already set
  bool initSet;

  List<PromotionalDraw> draws;
  List<PromotionalDraw> userDraws;
  PromotionalDraw? selectedDraw;

  DrawsStateModel(
      {this.draws = const [],
      this.userDraws = const [],
      this.isLoading = false,
      this.initSet = false});

  PromotionalDraw getFirstDraw() {
    return this.draws.first;
  }
}

class DrawsState extends StateNotifier<DrawsStateModel> {
  final Ref? ref;

  DrawsState([this.ref, List<PromotionalDraw>? draws, bool? isLoading])
      : super(DrawsStateModel(
          isLoading: false,
        ));

  void initDrawsState() async {
    PromotionalDraw? copyOfSelected;
    if (state.selectedDraw != null) {
      copyOfSelected = state.selectedDraw;
    }

    if (!state.initSet) {
      state.isLoading = true;

      UserProfile? user = ref!.read(userStateProvider).user;

      // fetch draws
      List<PromotionalDraw> fetchedDraws =
          await _dataService.fetchPromotionalDraws();

      //fetch the user's draws with user only tickets
      List<PromotionalDraw> fetchedUserDraws =
          await _dataService.fetchUserTickets(user!.id);

      // set state
      state = DrawsStateModel(
          draws: fetchedDraws,
          userDraws: fetchedUserDraws,
          isLoading: false,
          initSet: true);

      state.selectedDraw = copyOfSelected;
    }
  }

  void setSelectedDraw(PromotionalDraw draw) {
    state.selectedDraw = draw;
  }

  PromotionalDraw? getDraw(String drawID) {
    try {
      return state.draws.firstWhere((draw) => draw.id == drawID);
    } catch (e) {
      return null;
    }
  }

  /// Returns the number of tickets successfully bought
  Future<int> purchaseTicket(
      int numOfTickets, PromotionalDraw draw, UserProfile user) async {
    String? uuid = user.id;
    int successfulPurchases = 0;
    PromotionalDraw copyDraw = draw;

    for (var i = 0; i < numOfTickets; i++) {
      PromotionalTicket ticket = PromotionalTicket.init(
          drawID: draw.id,
          userID: uuid,
          userName: user.name,
          purchaseDate: DateTime.now());

      String? newTicketKey =
          await _dataService.purchaseTicket(ticket, draw, uuid);
      if (newTicketKey != 'failed') {
        successfulPurchases++;

        ticket.id = newTicketKey;
        copyDraw.tickets!.add(ticket);
        if (copyDraw.ticketsSold != null) {
          copyDraw.ticketsSold = copyDraw.ticketsSold! + 1;
        }

        UserTransaction transaction = UserTransaction.init(
            name: draw.name,
            price: draw.ticketPrice,
            purchaseDate: DateTime.now(),
            type: "spent");

        await _dataService.createUserTransaction(transaction, uuid);
      }
    }

    final userState = ref!.read(userStateProvider.notifier);
    double balance = userState.state.user!.balance! -
        (draw.ticketPrice! * successfulPurchases);

    await userState.updateBalance(balance);

    state.initSet = false;
    this.initDrawsState();
    this.setSelectedDraw(copyDraw);

    return Future.value(successfulPurchases);
  }

  List<PromotionalDraw> getFilteredDraws(String status) {
    List<PromotionalDraw> copy = state.userDraws;
    return copy.where((element) => element.drawStatus == status).toList();
  }
}

final drawStateProvider = StateNotifierProvider<DrawsState, DrawsStateModel>(
    (ref) => DrawsState(ref));
