import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool primary;

  PrimaryButton({this.onPressed, this.text, this.primary = true});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: primary ? Color(0xFF0169FF) : Colors.grey[800],
          borderRadius: new BorderRadius.circular(18.0),
          border: Border.all(
            color: primary ? Colors.grey[300]! : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          text!,
          style: TextStyle(
              color: primary ? Colors.white : Colors.grey[300],
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
