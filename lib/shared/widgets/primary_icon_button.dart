import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool primary;
  final Icon icon;

  PrimaryIconButton(
      {this.onPressed, this.text, this.primary = true, this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: RaisedButton(
        color: primary
            ? Get.theme.backgroundColor.withOpacity(0.7)
            : Colors.grey[800],
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: primary ? Colors.white : Colors.grey[300],
                ),
              ),
              icon,
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(
            color: primary ? Colors.grey[300] : Colors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }
}
