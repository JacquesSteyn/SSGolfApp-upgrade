import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/user.dart';

enum ProfileMode { User, Physical, Golf }

class ProfileState extends ChangeNotifier {
  // final AuthService _authService = AuthService();
  final DataService _dataService = DataService();
  final ImagePicker imagePicker = new ImagePicker();

  String errorMessage = '';
  UserProfile? _fluxUserProfile;

  bool profileChangesMade = false;
  bool profileChangesSaved = false;
  // *** Initialize
  bool _initSet = false;
  initProfile(UserProfile? userProfile) {
    if (!_initSet && userProfile != null) {
      print('USER PROFILE:::: ' + userProfile.getJson().toString());
      _fluxUserProfile = userProfile;
      _initSet = true;
    }

    return _fluxUserProfile;
  }

  resetProfile() {
    _fluxUserProfile = null;
    _initSet = false;
  }

  // *** loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _changeMade() {
    profileChangesMade = true;
    profileChangesSaved = false;
  }

  // *** User profile
  final _userProfileFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get userProfileFormKey => _userProfileFormKey;
  // user profile form field values

  String? get imageUrl => _fluxUserProfile?.imageUrl;
  setImageUrl(String? value) {
    _fluxUserProfile!.imageUrl = value;
    _changeMade();
    notifyListeners();
  }

  String? get name => _fluxUserProfile?.name;
  setName(String? value) {
    _fluxUserProfile!.name = value;
    _changeMade();
    notifyListeners();
  }

  String? get gender => _fluxUserProfile?.gender;
  setGender(String? value) {
    _fluxUserProfile!.gender = value;
    _changeMade();
    notifyListeners();
  }

  String? get dateOfBirth => _fluxUserProfile?.dateOfBirth;
  setDateOfBirth(String? value) {
    _fluxUserProfile!.dateOfBirth = value;
    _changeMade();

    notifyListeners();
  }

  // *** Physical profile
  final _physicalProfileFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get physicalProfileFormKey => _physicalProfileFormKey;
  String? get height => _fluxUserProfile!.physicalProfile.height;
  setHeight(String value) {
    _fluxUserProfile!.physicalProfile.height = value;
    _changeMade();

    notifyListeners();
  }

  String? get weight => _fluxUserProfile!.physicalProfile.weight;
  setWeight(String value) {
    _fluxUserProfile!.physicalProfile.weight = value;
    _changeMade();

    notifyListeners();
  }

  String? get upperLimbDominance =>
      _fluxUserProfile!.physicalProfile.upperLimbDominance;
  setUpperLimbDominance(String? value) {
    _fluxUserProfile!.physicalProfile.upperLimbDominance = value;
    _changeMade();

    notifyListeners();
  }

  String? get lowerLimbDominance =>
      _fluxUserProfile!.physicalProfile.lowerLimbDominance;
  setLowerLimbDominance(String? value) {
    _fluxUserProfile!.physicalProfile.lowerLimbDominance = value;
    _changeMade();

    notifyListeners();
  }

  // *** Golf profile
  final _golfProfileFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> get golfProfileFormKey => _golfProfileFormKey;
  String? get status => _fluxUserProfile!.golfProfile.status;
  setStatus(String? value) {
    _fluxUserProfile!.golfProfile.status = value;
    if (value != 'Beginner' && value != 'Amateur') {
      setHandicap('N/A');
    } else {
      if (_fluxUserProfile!.golfProfile.handicap == 'N/A') {
        setHandicap('0');
      }
    }
    _changeMade();
    notifyListeners();
  }

  String? get stance => _fluxUserProfile!.golfProfile.stance;
  setStance(String? value) {
    _fluxUserProfile!.golfProfile.stance = value;
    _changeMade();

    notifyListeners();
  }

  String? get clubAffiliation => _fluxUserProfile!.golfProfile.clubAffiliation;
  setClubAffiliation(String? value) {
    _fluxUserProfile!.golfProfile.clubAffiliation = value;
    _changeMade();

    notifyListeners();
  }

  String? get handicap => _fluxUserProfile!.golfProfile.handicap;
  setHandicap(String value) {
    _fluxUserProfile!.golfProfile.handicap = value;
    _changeMade();

    notifyListeners();
  }

  // *** Profile type switch
  ProfileMode _profileMode = ProfileMode.User;
  ProfileMode get profileMode => _profileMode;
  void switchProfileMode(ProfileMode mode) {
    _profileMode = mode;
    notifyListeners();
  }

  Future<bool> updateUserProfile() async {
    print('UPDATE USER PROFILEEEE: ' + _fluxUserProfile!.getJson().toString());

    if (true) {
      // TODO => validation -> validateForm(_userProfileFormKey)) {
      try {
        setIsLoading(true);
        await _dataService.updateUserProfile(_fluxUserProfile!);
        profileChangesSaved = true;
        setIsLoading(false);
        // Delayed callback
        Future.delayed(const Duration(seconds: 3), () {
          print('Delayed callBACKKKK');
          profileChangesMade = false;
          profileChangesSaved = false;
          notifyListeners();
        });
        return true;
      } catch (e) {
        print("ERRoR UPDATEEEE: " + e.toString());
      }
      setIsLoading(false);
      return false;
    }
  }

  Future<void> uploadImage() async {
    // PickedFile? newlyUploadedImage =
    //     await imagePicker.getImage(source: ImageSource.gallery);

    XFile? newlyUploadedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    print('Image selected: ' + newlyUploadedImage!.path.toString());
// TODO -> delete previous
    // if (_fluxUserProfile.imageUrl != null && _fluxUserProfile.imageUrl.isNotEmpty) {
    //   await _dataService.deleteImage(_fluxUserProfile.imageUrl);
    // }

    String? newImageUrl = await _dataService.uploadImage(
        newlyUploadedImage, _fluxUserProfile!.id);

    setImageUrl(newImageUrl);
  }

  validateForm(GlobalKey<FormState> key) {
    // TODO -> validate all
    if (key.currentState!.validate()) {
      key.currentState!.save();
      return true;
    } else {
      return false;
    }
  }
}

final profileStateProvider = ChangeNotifierProvider((ref) => ProfileState());
