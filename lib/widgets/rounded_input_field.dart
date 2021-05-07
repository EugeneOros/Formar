import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_it/config/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final Function(String? value)? onSaved;
  final Function(String value)? onChange;

  final String? initialValue;
  final bool autofocus;
  final int lengthLimit;
  final double? height;
  final double? width;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon,
    this.validator,
    this.controller,
    this.onSaved,
    this.onChange,
    this.initialValue,
    this.autofocus = false,
    this.lengthLimit = 40,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          depth: -1.5,
          intensity: 1,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
          lightSource: LightSource.topLeft,
          color: Theme.of(context).primaryColorLight.withOpacity(0.4)),
      child: Container(
        // decoration: roundedShadowDecoration,
        height: height,
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(lengthLimit),
          ],
          onSaved: onSaved,
          onChanged: onChange,
          textAlignVertical: TextAlignVertical.center,
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
                  contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  prefixIcon: Icon(icon, color: Colors.black),
                  // prefixIcon: icon != null ?  Icon(icon, color: Colors.black) : null,
                  border: borderRoundedTransparent,
                  focusedBorder: borderRoundedTransparent,
                  enabledBorder: borderRoundedTransparent,
                  errorStyle: TextStyle(height: 0),
                )
              : InputDecoration(
                  filled: true,
                  fillColor: TextFieldFillColor,
                  hintText: hintText,
                  contentPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                  border: borderRoundedTransparent,
                  focusedBorder: borderRoundedTransparent,
                  enabledBorder: borderRoundedTransparent,
                  errorStyle: TextStyle(height: 0),
                ),
        ),
      ),
    );
  }
}
