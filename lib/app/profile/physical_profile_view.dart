import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:ss_golf/app/profile/profile_state.dart';
import 'package:ss_golf/shared/widgets/custom_text_field.dart';
import 'package:ss_golf/shared/widgets/disable_focus_node.dart';

const limbDominanceSelectionOptions = ['Right', 'Left', 'Ambidextrous'];

class PhysicalProfileView extends ConsumerWidget {
  final TextEditingController heightTextController =
      new TextEditingController();
  final TextEditingController weightTextController =
      new TextEditingController();

  final heightSelectionOptions =
      List<int>.generate(100, (index) => (100 + index));
  final weightSelectionOptions =
      List<int>.generate(334, (index) => (15 + index));

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final profileState = watch(profileStateProvider);

    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        // color: Colors.orange,
        padding: const EdgeInsets.all(15),
        // child: Form(
        //   key: profileState.physicalProfileFormKey,
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: displayPhysicalProfileViewFields(profileState),
          ),
        ),
        // ),
      ),
    );
  }

  List<Widget> displayPhysicalProfileViewFields(profileState) {
    return [
      heightDirectSelection(profileState),
      SizedBox(height: 20),
      weightDirectSelection(profileState),
      SizedBox(height: 20),
      upperLimbDominanceSelection(profileState),
      SizedBox(height: 20),
      lowerLimbDominanceSelection(profileState),
    ];
  }

  Widget heightDirectSelection(profileState) {
    print('HEIGHTTTT ' + profileState?.height.toString());
    int initialIndex = 0;
    if (profileState?.height != null) {
      heightTextController.text = '${profileState?.height} cm';
      initialIndex = heightSelectionOptions
          .indexWhere((val) => val == int.parse(profileState?.height));
    }
    return TextFormField(
      onTap: () {
        showModalBottomSheet(
            context: Get.context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: initialIndex > -1 ? initialIndex : 0),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    profileState
                        .setHeight(heightSelectionOptions[index].toString());
                  },
                  looping: true,
                  children: heightSelectionOptions
                      .map<Widget>(
                        (option) => Center(
                          child: Text('$option'),
                        ),
                      )
                      .toList(),
                ),
              );
            });
      },
      readOnly: true,
      focusNode: new AlwaysDisabledFocusNode(),
      controller: heightTextController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey[700],
        ),
        fillColor: Colors.black,
        filled: true,
        labelText: 'Height',
        labelStyle: TextStyle(
            color: profileState?.height == null
                ? Colors.red[300]
                : Colors.grey[300],
            fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget weightDirectSelection(profileState) {
    print('WEIGHTTTT ' + profileState?.weight.toString());
    int initialIndex = 0;
    if (profileState?.weight != null) {
      weightTextController.text = '${profileState?.weight} kg';
      initialIndex = weightSelectionOptions
          .indexWhere((val) => val == int.parse(profileState?.weight));
    }
    return TextFormField(
      onTap: () {
        showModalBottomSheet(
            context: Get.context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                      initialItem: initialIndex > -1 ? initialIndex : 0),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    profileState
                        .setWeight(weightSelectionOptions[index].toString());
                  },
                  looping: true,
                  children: weightSelectionOptions
                      .map<Widget>(
                        (option) => Center(
                          child: Text('$option'),
                        ),
                      )
                      .toList(),
                ),
              );
            });
      },
      readOnly: true,
      focusNode: new AlwaysDisabledFocusNode(),
      controller: weightTextController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.grey[700],
        ),
        fillColor: Colors.black,
        filled: true,
        labelText: 'Weight',
        labelStyle: TextStyle(
            color: profileState?.weight == null
                ? Colors.red[300]
                : Colors.grey[300],
            fontSize: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget upperLimbDominanceSelection(profileState) {
    return DropdownButtonFormField<String>(
      items: limbDominanceSelectionOptions
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      value: profileState?.upperLimbDominance,
      onChanged: profileState.setUpperLimbDominance,
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black,
        labelText: 'Upper Limb Dominance',
        labelStyle: TextStyle(
          color: profileState?.upperLimbDominance == null
              ? Colors.red[300]
              : Colors.grey[300],
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget lowerLimbDominanceSelection(profileState) {
    return DropdownButtonFormField<String>(
      items: limbDominanceSelectionOptions
          .map<DropdownMenuItem<String>>((String val) {
        return DropdownMenuItem<String>(
          value: val,
          child: Text(val),
        );
      }).toList(),
      value: profileState?.lowerLimbDominance,
      onChanged: profileState.setLowerLimbDominance,
      style: TextStyle(color: Colors.white),
      dropdownColor: Colors.grey,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.black,
        labelText: 'Lower Limb Dominance',
        labelStyle: TextStyle(
          color: profileState?.lowerLimbDominance == null
              ? Colors.red[300]
              : Colors.grey[300],
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

// DIRECT SELECTION ITEM
class DirectSelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const DirectSelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: isForList
          ? Padding(
              child: _buildItem(context),
              padding: EdgeInsets.all(10.0),
            )
          : Card(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: <Widget>[
                  _buildItem(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: FittedBox(
          child: Text(
        title,
      )),
    );
  }
}
