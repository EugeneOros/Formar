import 'package:flutter/material.dart';
import 'package:form_it/shared/colors.dart';
import 'package:form_it/shared/constants.dart';
import 'package:form_it/shared/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: PrimaryColor,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: SecondaryColor,
          hintText: hintText,
          prefixIcon: Icon(icon, color: PrimaryColor),
          border: borderRoundedTransparent,
          focusedBorder: borderRoundedTransparent,
          enabledBorder: borderRoundedTransparent,
        ),
      ),
    );
  }
}
