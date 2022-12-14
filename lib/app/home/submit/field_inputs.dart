import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ss_golf/shared/models/challenge_input.dart';
import 'package:ss_golf/shared/widgets/custom_select_input.dart';
import 'package:ss_golf/shared/widgets/custom_select_score_input.dart';
import 'package:ss_golf/shared/widgets/disable_focus_node.dart';

class FieldInputs extends StatefulWidget {
  final scoreState;
  FieldInputs({this.scoreState});

  @override
  _FieldInputsState createState() => _FieldInputsState();
}

class _FieldInputsState extends State<FieldInputs> {
  // @override
  // void dispose() {
  //   // _readOnlyController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 20.0,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.scoreState.userInputs.map<Widget>((input) {
        switch (input.type) {
          case 'score':
            return scoreInput(input, widget.scoreState);
          case 'inverted-score':
            return scoreInput(input, widget.scoreState);
          case 'select-score':
            //return dropdownSelectScoreInput(input, widget.scoreState);
            return CustomSelectScoreBox(input, widget.scoreState);
          case 'select':
            return CustomSelectBox(input, widget.scoreState);
          default:
            return Container(color: Colors.blue);
        }
      }).toList(),
      // ),
    );
  }

  Widget scoreInput(ChallengeInputScore input, scoreState) {
    final TextEditingController _readOnlyController = TextEditingController();

    int inputScoreResult = scoreState.getInputScoreResult(input.index);
    _readOnlyController.text =
        inputScoreResult > -1 ? inputScoreResult.toString() : "";
    List<int> selectionOptions =
        List.generate(input.maxScore! + 1, (index) => index);
    int initialIndex = 0;
    if (inputScoreResult != 0) {
      initialIndex =
          selectionOptions.indexWhere((val) => val == inputScoreResult);
    }

    if (input.maxScore! > 20) {
      return Container(
        width: Get.size.width * 0.40,
        height: 100,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(input.name!,
                    style: TextStyle(color: Colors.grey[300], fontSize: 18)),
              ),
            ),
            TextFormField(
              onTap: () {
                showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            vertical: Get.size.height * 0.35, horizontal: 80),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 20),
                          child: Material(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Enter value between \n 0 and ${input.maxScore}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Get.theme.colorScheme.secondary,
                                        fontSize: 16),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: _readOnlyController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        LimitRangeTextInputFormatter(
                                            0, input.maxScore!)
                                      ],
                                      onChanged: (val) =>
                                          scoreState.setInputScoreResult(
                                              input.index, int.parse(val)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text("Done"),
                                  )
                                ]),
                          ),
                        ),
                      );
                    });
              },
              focusNode: new AlwaysDisabledFocusNode(),
              controller: _readOnlyController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_drop_up,
                      color: Colors.grey[700],
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
                fillColor: Colors.black,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ],
        ),
      );
    } else
      return Container(
        width: Get.size.width * 0.40,
        height: 100,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(bottom: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(input.name!,
                    style: TextStyle(color: Colors.grey[300], fontSize: 18)),
              ),
            ),
            TextFormField(
              onTap: () {
                showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                            vertical: Get.size.height * 0.3, horizontal: 80),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(children: [
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                    initialItem:
                                        initialIndex > -1 ? initialIndex : 0),
                                itemExtent: 40,
                                onSelectedItemChanged: (int value) {
                                  scoreState.setInputScoreResult(
                                      input.index, value);
                                },
                                looping: true,
                                children: selectionOptions
                                    .map<Widget>(
                                      (option) => Center(
                                        child: Text('$option'),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            Divider(
                              color: Get.theme.colorScheme.secondary,
                              height: 3,
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text("Done"),
                            )
                          ]),
                        ),
                      );
                    });
              },
              readOnly: true,
              focusNode: new AlwaysDisabledFocusNode(),
              controller: _readOnlyController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_drop_up,
                      color: Colors.grey[700],
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
                fillColor: Colors.black,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget dropdownSelectScoreInput(ChallengeInputSelectScore input, scoreState) {
    List<SelectOptionScore>? selections = input.selectionOptions;
    return Container(
      width: Get.size.width * 0.40,
      height: 100,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(input.name!,
                  style: TextStyle(color: Colors.grey[300], fontSize: 18)),
            ),
          ),
          TextFormField(
            onTap: () {
              showDialog(
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LimitedBox(
                            maxHeight: Get.size.height * 0.7,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: selections!.length,
                                  itemBuilder: (context, index) {
                                    String val = selections[index].option!;
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 10),
                                      child: Material(
                                        child: InkWell(
                                          key: ObjectKey(val),
                                          onTap: () {
                                            scoreState.setInputSelectResult(
                                                input.index, val);
                                            Get.back();
                                          },
                                          child: Text(
                                            val,
                                            style: TextStyle(
                                                color: input.name == val
                                                    ? Colors.blue
                                                    : Colors.black),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            },
            readOnly: true,
            focusNode: new AlwaysDisabledFocusNode(),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[700],
                  ),
                ],
              ),
              fillColor: Colors.black,
              filled: true,
              labelText: scoreState.getInputSelectResult(input.index),
              labelStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget dropdownSelectScoreInput(ChallengeInputSelectScore input, scoreState) {
  //   List<SelectOptionScore> selections = input.selectionOptions;
  //   return Container(
  //     width: Get.size.width * 0.45,
  //     // height: 60,
  //     child: DropdownButtonFormField<String>(
  //       iconSize: 30,
  //       isExpanded: true,
  //       dropdownColor: Colors.grey,
  //       value: scoreState.getInputSelectScoreResult(input.index)?.option,
  //       style: TextStyle(color: Colors.white),
  //       items: selections
  //           .map(
  //             (item) => DropdownMenuItem(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(2),
  //                 child: Text(
  //                   '${item.option} (${item.score})',
  //                   // style: TextStyle(color: Colors.black),
  //                 ),
  //               ),
  //               value: item.option,
  //             ),
  //           )
  //           .toList(),
  //       onChanged: (String val) {
  //         int selectedOptionIndex =
  //             selections.indexWhere((opt) => opt.option == val);
  //         scoreState.setInputSelectScoreResult(
  //             input.index, selections[selectedOptionIndex]);
  //       },
  //       decoration: InputDecoration(
  //         isDense: true,
  //         filled: true,
  //         labelText: input.name,
  //         labelStyle: TextStyle(color: Colors.grey[300], fontSize: 22),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //           borderSide: BorderSide(color: Colors.grey),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget dropdownSelectInput(ChallengeInputSelect input, scoreState) {
  //   List<SelectOptionScore> selections = input.selectionOptions;
  //   return Container(
  //     width: Get.size.width * 0.45,
  //     height: 60,
  //     child: DropdownButtonFormField<String>(
  //       iconSize: 30,
  //       dropdownColor: Colors.grey,
  //       value: scoreState.getInputSelectResult(input.index),
  //       style: TextStyle(color: Colors.white),
  //       items: selections
  //           .map(
  //             (item) => DropdownMenuItem(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(2),
  //                 child: Text(
  //                   item.option,
  //                   // style: TextStyle(color: Colors.black),
  //                 ),
  //               ),
  //               value: item.option,
  //             ),
  //           )
  //           .toList(),
  //       onChanged: (String val) {
  //         scoreState.setInputSelectResult(input.index, val.toString());
  //       },
  //       decoration: InputDecoration(
  //         isDense: true,
  //         filled: true,
  //         labelText: input.name,
  //         labelStyle: TextStyle(color: Colors.grey[300], fontSize: 22),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(18.0),
  //           borderSide: BorderSide(color: Colors.grey),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

class LimitRangeTextInputFormatter extends TextInputFormatter {
  LimitRangeTextInputFormatter(this.min, this.max) : assert(min < max);

  final int min;
  final int max;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text);
    if (value < min) {
      return TextEditingValue(text: min.toString());
    } else if (value > max) {
      return TextEditingValue(text: max.toString());
    }
    return newValue;
  }
}
