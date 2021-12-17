import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/services/utilities_service.dart';
import 'package:ss_golf/shared/widgets/custom_text_field.dart';
import 'package:ss_golf/shared/widgets/disable_focus_node.dart';

class UserProfileView extends ConsumerWidget {
  final TextEditingController dateOfBirthTextController =
      new TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profileState = watch(profileStateProvider);

    return SingleChildScrollView(
      child: Container(
        // color: Colors.orange,
        padding: const EdgeInsets.all(15),
        // child: Form(
        //   key: profileState.userProfileFormKey,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: displayUserProfileViewFields(profileState),
          ),
        ),
        // ),
      ),
    );
  }

  List<Widget> displayUserProfileViewFields(profileState) {
    return [
      // FIRST NAME
      CustomTextField(
        label: 'Name',
        inputType: TextInputType.text,
        onSaved: profileState.setName,
        initialValue: profileState?.name,
        validate: true,
        // showBorder: false,
        validatorMethod: (value) {
          if (value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
        missingFieldColor: true,
      ),
      SizedBox(height: 20),
      genderSelection(profileState),
      SizedBox(height: 20),
      dateOfBirthPicker(profileState),
    ];
  }

  Widget dateOfBirthPicker(profileState) {
    print('DATE OF BIRTHHH: ' + profileState?.dateOfBirth.toString());
    if (profileState?.dateOfBirth != null) {
      dateOfBirthTextController.text = profileState?.dateOfBirth;
    }
    return TextFormField(
      onTap: () {
        DatePicker.showDatePicker(
          Get.context,
          minTime: DateTime(1920),
          maxTime: DateTime(2020),
          currentTime: profileState?.dateOfBirth != null
              ? DateTime.parse(profileState?.dateOfBirth)
              : DateTime.now(),
          onConfirm: (date) {
            profileState.setDateOfBirth(Utilities.formatDate(date));
          },
        );
      },
      focusNode: new AlwaysDisabledFocusNode(),
      controller: dateOfBirthTextController,
      // initialValue: profileState?.dateOfBirth,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey[700],
        ),
        fillColor: Colors.black,
        filled: true,
        labelText: 'Date of Birth',
        labelStyle: TextStyle(
          color: profileState?.dateOfBirth == null
              ? Colors.red[300]
              : Colors.grey[300],
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget genderSelection(profileState) {
    return DropdownButtonFormField<String>(
      items: ['male', 'female', 'other']
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      value: profileState?.gender,
      onChanged: profileState.setGender,
      style: TextStyle(color: Colors.white, fontSize: 18),
      dropdownColor: Colors.grey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black,
        labelText: 'Gender',
        labelStyle: TextStyle(
          color:
              profileState?.gender == null ? Colors.red[300] : Colors.grey[300],
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
