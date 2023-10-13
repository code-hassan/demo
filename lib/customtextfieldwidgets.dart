import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final int validationType;
  final TextEditingController controller;
  final String hintText;

  CustomTextField({
    this.validationType = 1,
    required this.controller,
    this.hintText = "Enter text",
  });

  @override
  Widget build(BuildContext context) {
    late TextInputType inputType;
    late String labelText;

    if (validationType == 1) {
      inputType = TextInputType.text;
      labelText = "Name";
    } else if (validationType == 2) {
      inputType = TextInputType.number;
      labelText = "Number (max 11)";
    } else if (validationType == 3) {
      inputType = TextInputType.emailAddress;
      labelText = "Email";
    }

    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
      ),
      inputFormatters:(validationType == 1) ? [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ]:
      (validationType == 2) ? [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ]
          : (validationType == 3) ? [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9.@]')),
      ]:null,
    );
  }
}