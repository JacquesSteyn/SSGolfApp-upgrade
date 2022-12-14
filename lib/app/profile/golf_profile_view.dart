import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/shared/widgets/custom_text_field.dart';
import 'package:ss_golf/shared/widgets/disable_focus_node.dart';

class GolfProfileView extends ConsumerWidget {
  final List<String> handicapSelectionOptions = List.generate(
      40,
      (index) => (index - 10) >= 0
          ? (index - 10).toString()
          : '+${(index - 10).abs()}');
  final TextEditingController handicapTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileStateProvider);
    handicapTextController.text =
        profileState.handicap != null ? profileState.handicap.toString() : "";

    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        // color: Colors.orange,
        padding: const EdgeInsets.all(15),
        // child: Form(
        //   key: profileState.golfProfileFormKey,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: displayGolfProfileViewFields(profileState),
          ),
        ),
      ),
      // ),
    );
  }

  List<Widget> displayGolfProfileViewFields(ProfileState profileState) {
    return [
      // CLUB AFFILIATION
      CustomTextField(
        label: 'Club Affiliation',
        inputType: TextInputType.text,
        onSaved: profileState.setClubAffiliation,
        initialValue: profileState.clubAffiliation,
        missingFieldColor: true,
        // showBorder: false,
      ),
      SizedBox(height: 20),
      statusSelection(profileState),
      SizedBox(height: 20),

      if (profileState.status == 'Amateur' || profileState.status == 'Beginner')
        Column(
          children: [
            handicapDirectSelection(profileState),
            SizedBox(height: 20),
          ],
        ),

      stanceSelection(profileState),
    ];
  }

  Widget handicapDirectSelection(profileState) {
    int initialIndex = 0;
    if (profileState?.handicap != null) {
      handicapTextController.text = '${profileState?.handicap}';
      initialIndex = handicapSelectionOptions
          .indexWhere((val) => val == profileState?.handicap);
    } else {
      handicapTextController.clear(); // = '';
    }
    return TextFormField(
      onTap: () {
        if (profileState?.status == 'Amateur' ||
            profileState?.status == 'Beginner') {
          showModalBottomSheet(
              context: Get.context!,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: initialIndex > -1 ? initialIndex : 0),
                    itemExtent: 40,
                    onSelectedItemChanged: (int index) {
                      profileState.setHandicap(
                          handicapSelectionOptions[index].toString());
                    },
                    looping: true,
                    children: handicapSelectionOptions
                        .map<Widget>(
                          (option) => Center(
                            child: Text('$option'),
                          ),
                        )
                        .toList(),
                  ),
                );
              });
        }
      },
      readOnly: true,
      focusNode: new AlwaysDisabledFocusNode(),
      controller: handicapTextController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey[700],
        ),
        fillColor: Colors.black,
        filled: true,
        labelText: 'Handicap',
        labelStyle: TextStyle(
          color: profileState?.handicap == null
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

  Widget statusSelection(ProfileState profileState) {
    return DropdownButtonFormField<String>(
      items: [
        'Beginner',
        'Amateur',
        'Club Pro',
        'Local Tour Pro',
        'International Tour Pro'
      ].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      value: profileState.status,
      onChanged: profileState.setStatus,
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black,
        labelText: 'Status',
        labelStyle: TextStyle(
            color: profileState.status == null
                ? Colors.red[300]
                : Colors.grey[300],
            fontSize: 22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget stanceSelection(ProfileState profileState) {
    return DropdownButtonFormField<String>(
      items: ['Right', 'Left'].map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      value: profileState.stance,
      onChanged: profileState.setStance,
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black,
        labelText: 'Stance',
        labelStyle: TextStyle(
            color: profileState.stance == null
                ? Colors.red[300]
                : Colors.grey[300],
            fontSize: 22),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
