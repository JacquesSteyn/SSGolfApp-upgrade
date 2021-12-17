import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ss_golf/services/auth_service.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/user.dart';

final DataService _dataService = DataService();
final AuthService _authService = AuthService();

final authStateChangesProvider =
    StreamProvider<User>((ref) => _authService.streamUserValue());

class UserStateModel {
  UserProfile user;
  bool isAuthed;

  UserStateModel({
    this.user,
    this.isAuthed = false,
  });
}

class UserState extends StateNotifier<UserStateModel> {
  UserState() : super(UserStateModel());

  void initUser(User user) async {
    UserProfile currentUser = await _dataService.fetchUser(user.uid);
    if (currentUser == null || currentUser.id == null) {
      _authService.signOut();
    } else {
      state.user = currentUser;
      state.isAuthed = true;
    }
  }

  void logout() {
    state.isAuthed = false;
    state.user = null;
    _authService.signOut();
  }

  void resetPasswordByEmail() {
    _authService.resetPasswordEmail();
  }
}

final userStateProvider =
    StateNotifierProvider<UserState>((ref) => UserState());
