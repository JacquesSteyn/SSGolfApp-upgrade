import 'package:flutter/material.dart';

class CustomChallengeInput extends StatelessWidget {
  CustomChallengeInput(
      {this.label,
      this.inputType,
      this.validate = false,
      this.validatorMethod,
      this.onSaved});
  final String label;

  final String inputType;
  final Function(String) onSaved;
  final Function(String) validatorMethod;
  final bool validate;

  @override
  Widget build(BuildContext context) {
    switch (inputType) {
      case 'score':
        return scoreInput();
      case 'select':
        return null;
      default:
        return null;
    }
  }

  Widget scoreInput() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        fillColor: Colors.black,
        filled: true,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[300]),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.white)),
      ),
      onSaved: onSaved,
      validator: validatorMethod != null
          ? validatorMethod
          : (value) {
              if (value.isEmpty) {
                return '$label is required.';
              }
              return null;
            },
    );
  }
}
