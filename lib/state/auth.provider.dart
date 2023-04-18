import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ss_golf/services/auth_service.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/user.dart';

final DataService _dataService = DataService();
final AuthService _authService = AuthService();

final _purchasesConfiguration =
    PurchasesConfiguration("appl_yACkaxHoViRCpyivgjOqfOwScVi");

final authStateChangesProvider =
    StreamProvider<User?>((ref) => _authService.streamUserValue());

class UserStateModel {
  UserProfile? user;
  bool isAuthed;
  bool isLoading;

  UserStateModel({this.user, this.isAuthed = false, this.isLoading = false});
}

class UserState extends StateNotifier<UserStateModel> {
  UserState() : super(UserStateModel());

  Future<void> initUser(User user) async {
    state.isLoading = true;
    UserProfile currentUser = await _dataService.fetchUser(user.uid);
    if (currentUser.id == null) {
      state.isLoading = false;
      _authService.signOut();
      return Future.value();
    } else {
      state.user = currentUser;
      state.isAuthed = true;
      state.isLoading = false;

      if (currentUser.email != null) {
        try {
          Purchases.logIn(currentUser.email!);
          CustomerInfo customerInfo = await Purchases.getCustomerInfo();

          if (customerInfo.activeSubscriptions.length > 0) {
            // Make sure that the plan in the db is the same as on RevenueCat
            print("Has active subscriptions");
            if (currentUser.plan != "pro") {
              await _dataService.updateUserPlan(currentUser.id, "pro", false);
              state.user!.plan = "pro";
            }
          } else {
            if (currentUser.freeTrailExpireDate != null) {
              DateTime now = DateTime.now();
              if (now.compareTo(currentUser.freeTrailExpireDate!) > 0) {
                if (currentUser.plan != "free") {
                  await _dataService.updateUserPlan(
                      currentUser.id, "free", false);
                  state.user!.plan = "free";
                }
              }
            } else {
              if (currentUser.plan != "free") {
                await _dataService.updateUserPlan(
                    currentUser.id, "free", false);
                state.user!.plan = "free";
              }
            }
          }
        } catch (e) {
          state.user!.plan = "free";
        }
      }

      await _dataService.updateUserStreak(currentUser);

      return Future.value();
    }
  }

  Future<String?> deleteAccount(String password) async {
    if (state.user != null) {
      final userID = await _authService.signIn(state.user!.email!, password);
      if (userID.isNotEmpty) {
        await _authService.deleteUser();
        print("Account Deleted");
        return Future.value();
      } else {
        print("Unable to delete");
        return Future.value('Could not be verified.');
      }
    }
    return null;
  }

  void logout() async {
    if (state.user != null && state.user!.email != null) {
      Purchases.logIn(state.user!.email!);
    }
    state.isAuthed = false;
    await _authService.signOut();
    state.user = null;
  }

  void resetPasswordByEmail() {
    _authService.resetPasswordEmail();
  }

  Future<void> updateBalance(double newBalance) async {
    await _dataService.updateUserBalance(state.user!.id, newBalance);

    //Force rebuild
    UserStateModel copy = state;
    copy.user!.balance = newBalance;
    state = UserStateModel();
    state = copy;
    //

    return Future.value();
  }

  Future<double> redeemVoucher(
      String voucherNumber, double userOldBalance, String? uuid) async {
    try {
      double voucherPrice =
          await _dataService.redeemVoucher(voucherNumber, uuid);
      //print(voucherPrice);
      double newBalance = userOldBalance + voucherPrice;
      await this.updateBalance(newBalance);
      if (voucherPrice > 0) {
        return Future.value(voucherPrice);
      }
      return Future.value(0);
    } catch (e) {
      throw e;
    }
  }

  Future<double> redeemGift(
      String title, double price, double userOldBalance, String? uuid,
      {int completedChallenges = 0}) async {
    double giftPrice = await _dataService.redeemGifts(title, price, uuid,
        completedChallenges: completedChallenges);
    double newBalance = userOldBalance + giftPrice;
    await this.updateBalance(newBalance);
    if (giftPrice > 0) {
      return Future.value(giftPrice);
    }
    return Future.value(0);
  }

  Future<void> updateRedeemValues(String userID) async {
    UserProfile currentUser = await _dataService.fetchUser(userID);
    if (currentUser.id == null) {
      return Future.value();
    } else {
      //Force rebuild
      UserStateModel copy = state;
      copy.user = currentUser;
      state = UserStateModel();
      state = copy;
      //

      return Future.value();
    }
  }

  Future<bool> updateUserPlan(String plan, bool freeTrail) async {
    if (state.user != null && state.user!.id != null) {
      await _dataService.updateUserPlan(state.user!.id, plan, freeTrail);

      //Force rebuild
      UserStateModel copy = state;
      copy.user!.plan = plan;
      state = UserStateModel();
      state = copy;
      //

      return Future.value(true);
    }
    return Future.value(false);
  }
}

final userStateProvider =
    StateNotifierProvider<UserState, UserStateModel>((ref) => UserState());
