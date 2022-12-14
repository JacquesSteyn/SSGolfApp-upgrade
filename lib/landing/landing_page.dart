import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ss_golf/landing/landing_state.dart';
import 'package:ss_golf/main.dart';
import 'package:ss_golf/services/auth_service.dart';
import 'package:ss_golf/shared/widgets/custom_text_field.dart';
import 'package:ss_golf/shared/widgets/logo.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/widgets/primary_button.dart';
import 'package:ss_golf/state/bottom_navbar_index.provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingPage extends ConsumerWidget {
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _showErrorDialog(LandingState landingState) {
    Get.defaultDialog(
      title: '', // 'Authentication failed!',
      content: Text(landingState.errorMessage ?? ""),
      actions: [
        TextButton(
          child: Text('Try again'),
          onPressed: () {
            Get.back();
            landingState.setErrorMessage("");
          },
        ),
      ],
    );
  }

  void _showResetPasswordDialog(landingState) {
    Get.defaultDialog(
      title: '', // 'Authentication failed!',
      content: Column(
        children: [
          Text(
            'Enter your email, click send, then check your inbox.\n\n',
            textAlign: TextAlign.center,
          ),
          _emailField(landingState, false),
        ],
      ),
      actions: [
        TextButton(
          child: Text('Send'),
          onPressed: () {
            Get.back();
            _authService.resetPasswordEmailWithoutAuth(landingState.email);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final landingState = ref.watch(landingStateProvider);
    final navbarIndex = ref.watch(indexStateProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child:
            // ListView(
            SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: Get.size.height * 0.2,
                child: Center(
                  child: Logo(
                    dimension: Get.size.width * 0.55,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                height: (Get.size.height * 0.8),
                child: Center(
                  child: _content(landingState, navbarIndex),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(LandingState landingState, navIndexState) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.secondary.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: landingState.authMode == AuthMode.Login
          ? _loginFields(landingState)
          : _signUpFields(landingState, navIndexState),
    );
  }

  Widget _loginFields(LandingState landingState) {
    return Form(
      // key: landingState.loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Log In',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(height: 10),
          _emailField(landingState, true),
          SizedBox(height: 10),
          _passwordField(landingState),
          SizedBox(height: 15),
          _logInButton(landingState),
          SizedBox(height: 15),
          _forgotPassword(landingState),
          SizedBox(height: 20),
          _switchAuthMode(landingState),
        ],
      ),
    );
  }

  Widget _signUpFields(LandingState landingState, navIndexState) {
    return Form(
      // key: landingState.signUpFormKey,
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          SizedBox(height: 20),
          _usernameField(landingState),
          SizedBox(height: 15),
          _emailField(landingState, true),
          SizedBox(height: 15),
          _passwordField(landingState),
          SizedBox(height: 15),
          _confirmPasswordField(landingState),
          SizedBox(height: 15),
          _signUpButton(landingState, navIndexState),
          SizedBox(height: 15),
          _termsAndConditions(),
          SizedBox(height: 15),
          _switchAuthMode(landingState),
        ],
      ),
    );
  }

  Widget _usernameField(LandingState landingState) {
    return Column(
      children: [
        CustomTextField(
          label: 'Full name',
          inputType: TextInputType.text,
          onSaved: landingState.setUsername,
          validate: false,
          largeFont: false,
        ),
        if (landingState.usernameError != null)
          Text(landingState.usernameError ?? "",
              style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _emailField(LandingState landingState, bool filled) {
    return Column(
      children: [
        CustomTextField(
          label: 'Email',
          inputType: TextInputType.emailAddress,
          onSaved: landingState.setEmail,
          validate: false,
          largeFont: false,
          filledDark: filled,
        ),
        if (landingState.emailError != null)
          Text(landingState.emailError ?? "",
              style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _passwordField(LandingState landingState) {
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          // onEditingComplete: _onPasswordEditingComplete,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            fillColor: Colors.black,
            filled: true,
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.grey[300], fontSize: 18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
          ),
          onChanged: landingState.setPassword,
          // onSaved: landingState.setPassword,
          // validator: (value) {
          //   if (value.isEmpty || value.length < 5) {
          //     return 'Password is too short.';
          //   }
          //   return null;
          // },
        ),
        if (landingState.passwordError != null)
          Text(landingState.passwordError ?? "",
              style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _confirmPasswordField(LandingState landingState) {
    String? showErrorForConfirmPasswordField;
    if (landingState.confirmPasswordError != null) {
      showErrorForConfirmPasswordField = landingState.confirmPasswordError;
    } else if (landingState.confirmPasswordError != null &&
        landingState.confirmPassword != _passwordController.value.text) {
      showErrorForConfirmPasswordField = 'Passwords do not match';
    }
    return Column(
      children: [
        TextFormField(
          obscureText: true,
          autocorrect: false,
          textInputAction: TextInputAction.done,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            fillColor: Colors.black,
            filled: true,
            labelText: 'Confirm password',
            labelStyle: TextStyle(color: Colors.grey[300], fontSize: 18),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
          ),
          onChanged: landingState.setConfirmPassword,
          // validator: (value) {
          //   if (value.isEmpty || value.length < 5) {
          //     return 'Password not valid';
          //   } else if (value != _passwordController.value.text) {
          //     return 'Passwords do not match!';
          //   }
          //   return null;
          // },
        ),
        if (showErrorForConfirmPasswordField != null)
          Text(showErrorForConfirmPasswordField,
              style: TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _logInButton(LandingState landingState) {
    return landingState.isLoading
        ? Center(child: CircularProgressIndicator())
        : PrimaryButton(
            onPressed: () async {
              if (!await landingState.signIn() &&
                  landingState.errorMessage != null) {
                _showErrorDialog(landingState);
              } else {
                Get.offAll(AuthWidget());
              }
            },
            text: 'Log In',
          );
  }

  Widget _signUpButton(LandingState landingState, IndexState navIndexState) {
    return landingState.isLoading
        ? CircularProgressIndicator()
        : PrimaryButton(
            onPressed: () async {
              if (!await landingState.signUp() &&
                  landingState.errorMessage != null) {
                _showErrorDialog(landingState);
              } else {
                navIndexState.setIndex(2);
                Get.offAll(AuthWidget());
              }
            },
            text: 'Sign Up',
          );
  }

  Widget _forgotPassword(LandingState landingState) {
    return SizedBox(
      width: 200,
      child: TextButton(
        // color: Colors.white,
        // colorBrightness: Brightness.light,
        child: Text(
          'Forgot password?',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          _showResetPasswordDialog(landingState);
        }, // landingState.forgotPassword,
      ),
    );
  }

  Widget _termsAndConditions() {
    return SizedBox(
      width: 200,
      child: TextButton(
        // color: Colors.white,
        // colorBrightness: Brightness.light,
        child: Text(
          'By signing up you agree to the T&Cs',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blue),
        ),
        onPressed: () {
          launch('https://www.smartstats.co.za/terms/');
        }, // landingState.forgotPassword,
      ),
    );
  }

  Widget _switchAuthMode(LandingState landingState) {
    List<String> texts = landingState.authModeAlternateText.split('\n');
    return SizedBox(
      width: 200,
      child: TextButton(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: texts[0],
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: '\n${texts[1]}',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Text(
        //   landingState.authModeAlternateText,
        //   textAlign: TextAlign.center,
        //   style: TextStyle(color: Colors.white),
        // ),
        onPressed: landingState.switchAuthMode,
      ),
    );
  }
}
