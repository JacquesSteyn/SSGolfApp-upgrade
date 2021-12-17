import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/services/auth_service.dart';
import 'package:ss_golf/services/data_service.dart';
import 'package:ss_golf/shared/models/user.dart';

enum AuthMode { Signup, Login }
const authModeLoginAlternateText = "Don't have an account?\nSign up here";
const authModeSignUpAlternateText = "Already have an account?\nLog in here";

class LandingState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DataService _dataService = DataService();
  // GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> get loginFormKey => _loginFormKey;
  // GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> get signUpFormKey => _signUpFormKey;
  AuthMode _authMode = AuthMode.Login;
  String _authModeAlternateText = authModeLoginAlternateText;
  String _errorMessage;
  String get errorMessage => _errorMessage;
  void setErrorMessage(String val) {
    _errorMessage = val;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  // void resetFormKey(key) {
  //   key = new GlobalKey<FormState>();
  //   notifyListeners();
  // }

  // auth landing form field values
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _username = '';
  String _emailError;
  String _passwordError;
  String _confirmPasswordError;
  String _usernameError;

  Future<bool> signIn() async {
    if (validateSignInForm()) {
      print('SIGN IN: email: ' + _email + '  pwd: ' + _password);
      try {
        setIsLoading(true);
        await _authService.signIn(email, password);
        setIsLoading(false);
        // resetFormKey(_loginFormKey);
        return true;
      } catch (e) {
        print("ERRoR Sign in: " + e.toString());
        if (e.toString().contains('user-not-found')) {
          setErrorMessage('Could not find a user with that email');
        }
        if (e.toString().contains('wrong-password')) {
          setErrorMessage('The password is invalid');
        } else {
          setErrorMessage('Failed to authenticate. Please try again.');
        }
      }
      setIsLoading(false);
      return false;
    } else {
      return false;
    }
  }

  Future<bool> signUp() async {
    if (validateSignUpForm()) {
      try {
        setIsLoading(true);
        String userId = await _authService.signUp(email, password);
        UserProfile newUser = UserProfile(
            {'id': userId, 'email': _email, 'name': _username, 'type': 'client'});
        await _dataService.createUser(newUser);
        setIsLoading(false);
        // resetFormKey(_signUpFormKey);
        return true;
      } catch (e) {
        print("ERROR Sign Up: " + e.toString());
        if (e.toString().contains('user-not-found')) {
          setErrorMessage('Could not find a user with that email');
        }
        if (e.toString().contains('wrong-password')) {
          setErrorMessage('The password is invalid');
        } else {
          setErrorMessage('Failed to authenticate. Please try again.');
        }
      }
      setIsLoading(false);
      return false;
    }
    return false;
  }

  validateSignInForm() {
    bool signInFormValid = true;
    if (email.isEmpty || !email.contains('@')) {
      setEmailError('A valid email address is required');
      signInFormValid = false;
    } else {
      setEmailError(null);
    }
    print('PASSWORDDD: ' + password.toString());
    if (password.isEmpty || password.length < 5) {
      setPasswordError('Password is too short.');
      signInFormValid = false;
    } else {
      setPasswordError(null);
    }

    // print('EMAIL: ' + emailError.toString() + ' PWD: ' + passwordError.toString());

    return signInFormValid;
  }

  validateSignUpForm() {
    bool signUpFormValid = true;
    if (email.isEmpty || !email.contains('@')) {
      setEmailError('A valid email address is required');
      signUpFormValid = false;
    } else {
      setEmailError(null);
    }
    if (password.isEmpty || password.length < 5) {
      setPasswordError('Password is too short.');
      signUpFormValid = false;
    } else {
      setPasswordError(null);
    }

    if (confirmPassword.isEmpty || confirmPassword.length < 5) {
      setConfirmPasswordError('Password is too short.');
      signUpFormValid = false;
    } else {
      setConfirmPasswordError(null);
    }

    if (username.isEmpty || username.length < 3) {
      setUsernameError('Full name is required.');
      signUpFormValid = false;
    } else {
      setUsernameError(null);
    }

    // print('EMAIL: ' + emailError.toString() + ' PWD: ' + passwordError.toString());

    return signUpFormValid;
  }

  // validateForm(GlobalKey<FormState> key) {
  //   if (key.currentState.validate()) {
  //     key.currentState.save();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  String get email => _email;
  setEmail(String value) {
    _email = value;
  }

  String get password => _password;
  setPassword(String value) {
    _password = value;
  }

  String get confirmPassword => _confirmPassword;
  setConfirmPassword(String value) {
    _confirmPassword = value;
  }

  String get username => _username;
  setUsername(String value) {
    _username = value;
  }

  String get emailError => _emailError;
  setEmailError(String value) {
    _emailError = value;
    notifyListeners();
  }

  String get passwordError => _passwordError;
  setPasswordError(String value) {
    _passwordError = value;
    notifyListeners();
  }

  String get confirmPasswordError => _confirmPasswordError;
  setConfirmPasswordError(String value) {
    _confirmPasswordError = value;
    notifyListeners();
  }

  String get usernameError => _usernameError;
  setUsernameError(String value) {
    _usernameError = value;
    notifyListeners();
  }

  softResetFormValues() {
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _usernameError = null;
  }

  AuthMode get authMode => _authMode;
  String get authModeAlternateText => _authModeAlternateText;
  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      _authMode = AuthMode.Signup;
      _authModeAlternateText = authModeSignUpAlternateText;
      softResetFormValues();
    } else {
      _authMode = AuthMode.Login;
      _authModeAlternateText = authModeLoginAlternateText;
      softResetFormValues();
    }
    notifyListeners();
  }
}

final landingStateProvider = ChangeNotifierProvider((ref) => LandingState());
