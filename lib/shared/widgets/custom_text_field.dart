import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    this.label,
    this.inputType,
    this.initialValue,
    this.validate = false,
    this.validatorMethod,
    this.onSaved,
    this.suffixText,
    this.showBorder = true,
    this.largeFont = true,
    this.missingFieldColor = false,
    this.filledDark = true,
  });
  final String label;
  final String initialValue;
  final TextInputType inputType;
  final Function(String) onSaved;
  final Function(String) validatorMethod;
  final bool validate;
  final String suffixText;
  final bool missingFieldColor;
  final bool showBorder;
  final bool largeFont;
  final bool filledDark;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: _emailController,
      // autocorrect: false,
      // textInputAction: TextInputAction.next,
      initialValue: initialValue,
      keyboardType: inputType,
      // onEditingComplete: _onEmailEditingComplete,
      style: TextStyle(color: filledDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        suffixText: suffixText,
        suffixStyle: TextStyle(color: filledDark ? Colors.black : Colors.white),
        fillColor: filledDark ? Colors.black : Colors.white,
        filled: true,
        labelText: label,
        labelStyle: TextStyle(
          color: !filledDark
              ? Colors.grey
              : (missingFieldColor && initialValue == null)
                  ? Colors.red[300]
                  : Colors.grey[300],
          fontSize: largeFont ? 20 : 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: showBorder ? Colors.grey : Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide:
              BorderSide(color: showBorder ? Colors.grey[700] : Colors.transparent),
        ),
      ),
      onSaved: onSaved,
      onChanged: onSaved,
      validator: validatorMethod != null
          ? validatorMethod
          : (value) {
              if (value.isEmpty && validate) {
                return '$label is required.';
              }
              return null;
            },
    );
  }
}
