import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Function(String? value)? onSaved;
  final String? initialValue;
  final bool autofocus;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon,
    this.validator,
    this.controller,
    this.onSaved,
    this.initialValue,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedShadowDecoration,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        onSaved: onSaved,
        autofocus: autofocus,
        initialValue: initialValue,
        style: Theme.of(context).textTheme.bodyText2,
        controller: controller,
        cursorColor: Colors.black,
        validator: validator,
        decoration: icon != null
            ? InputDecoration(
                filled: true,
                fillColor: TextFieldFillColor,
                hintText: hintText,
                prefixIcon: Icon(icon, color: Colors.black),
                border: borderRoundedTransparent,
                focusedBorder: borderRoundedTransparent,
                enabledBorder: borderRoundedTransparent,
              )
            : InputDecoration(
                filled: true,
                fillColor: TextFieldFillColor,
                hintText: hintText,
                border: borderRoundedTransparent,
                focusedBorder: borderRoundedTransparent,
                enabledBorder: borderRoundedTransparent,
              ),
      ),
    );
  }
}
