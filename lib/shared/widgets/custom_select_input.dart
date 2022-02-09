import 'package:flutter/material.dart';
import 'package:ss_golf/shared/models/challenge_input.dart';
import 'package:get/get.dart';

import 'disable_focus_node.dart';

class CustomSelectBox extends StatelessWidget {
  const CustomSelectBox(this.input, this.scoreState);
  final ChallengeInputSelect input;
  final scoreState;

  @override
  Widget build(BuildContext context) {
    List<SelectOptionScore> selections = input.selectionOptions;
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
              child: Text(input.name,
                  style: TextStyle(color: Colors.grey[300], fontSize: 18)),
            ),
          ),
          TextFormField(
            onTap: () {
              showDialog(
                  context: Get.context,
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
                                  itemCount: selections.length,
                                  itemBuilder: (context, index) {
                                    String val = selections[index].option;
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                      child: Material(
                                        child: InkWell(
                                          key: ObjectKey(val),
                                          onTap: () {
                                            scoreState.setInputSelectResult(
                                                input.index, val);
                                            Get.back();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: double.infinity,
                                            color: Colors.white,
                                            child: Text(
                                              val,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: input.name == val
                                                      ? Colors.blue
                                                      : Colors.black),
                                            ),
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
}
