import 'package:flutter/material.dart';

class PrimaryIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final bool primary;
  final Icon? icon;

  PrimaryIconButton(
      {this.onPressed, this.text, this.primary = true, this.icon});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: primary ? Color(0xFF0169FF) : Colors.grey[800],
            borderRadius: new BorderRadius.circular(18.0),
            border: Border.all(
              color: primary ? Colors.grey[300]! : Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text!,
                style: TextStyle(
                  color: primary ? Colors.white : Colors.grey[300],
                ),
              ),
              icon!,
            ],
          ),
        ),
      ),
    );
  }
}
