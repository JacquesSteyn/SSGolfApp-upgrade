import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool primary;

  PrimaryButton({this.onPressed, this.text, this.primary = true});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: primary
          ? Get.theme.backgroundColor.withOpacity(0.7)
          : Colors.grey[800],
      onPressed: onPressed,
      child: FittedBox(
          child: Text(
        text,
        style: TextStyle(
          color: primary ? Colors.white : Colors.grey[300],
        ),
      )),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(
          color: primary ? Colors.grey[300] : Colors.grey,
          width: 1,
        ),
      ),
    );
  }
}
