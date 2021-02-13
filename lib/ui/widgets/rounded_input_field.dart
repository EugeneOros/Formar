import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> validator;
  final TextEditingController controller;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: TextFieldFillColor,
          hintText: hintText,
          prefixIcon: Icon(icon, color: Colors.black),
          border: borderRoundedTransparent,
          focusedBorder: borderRoundedTransparent,
          enabledBorder: borderRoundedTransparent,
        ),
      ),
    );
  }
}
