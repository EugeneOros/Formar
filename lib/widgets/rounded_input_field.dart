import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final double radius;
  final String? name;

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
    this.radius = 50, this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderRoundedTransparent = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name != null ? Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 10),
            child: Text(
              "Name",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ) : SizedBox(height: 0, width: 0,),
          Neumorphic(
            style: NeumorphicStyle(
              depth: -1.5,
              intensity: 1,
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(radius)),
              lightSource: LightSource.topLeft,
              color: Theme.of(context).primaryColorLight.withOpacity(0.4),
            ),
            child: Container(
              // decoration: roundedShadowDecoration,
              height: height,
              // width: width ?? MediaQuery.of(context).size.width * 0.8,
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
                decoration: InputDecoration(
                        filled: true,
                        fillColor: TextFieldFillColor,
                        hintText: hintText,
                        contentPadding: icon != null ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0) : EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                        // prefixIcon: Icon(icon, color: Colors.black),
                        prefixIcon: icon != null ?  Icon(icon, color: Colors.black) : null,
                        border: borderRoundedTransparent,
                        focusedBorder: borderRoundedTransparent,
                        enabledBorder: borderRoundedTransparent,
                        errorStyle: TextStyle(height: 0),
                        hintStyle: Theme.of(context).textTheme.subtitle1,
                      )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
