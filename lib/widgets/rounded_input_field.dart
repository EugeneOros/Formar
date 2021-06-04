import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:flutter/services.dart';

class RoundedInputField extends StatefulWidget {
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
    this.radius = 15,
    this.name,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder borderRoundedTransparent = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.name != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5, left: 10),
                  child: Text(
                    widget.name!,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
          Neumorphic(
            style: getInnerNeumorphicStyle(context: context),
            child: Container(
              // decoration: roundedShadowDecoration,
              height: widget.height,
              // width: width ?? MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(widget.lengthLimit),
                  ],
                  onSaved: widget.onSaved,
                  onChanged: widget.onChange,
                  textAlignVertical: TextAlignVertical.center,
                  autofocus: widget.autofocus,
                  initialValue: widget.initialValue,
                  style: Theme.of(context).textTheme.bodyText2,
                  controller: widget.controller,
                  // cursorColor: Colors.black,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:  Theme.of(context).canvasColor,
                    hintText: widget.hintText,
                    contentPadding: widget.icon != null ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0) : EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                    // prefixIcon: Icon(icon, color: Colors.black),
                    prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.black) : null,
                    border: borderRoundedTransparent,
                    focusedBorder: borderRoundedTransparent,
                    enabledBorder: borderRoundedTransparent,
                    errorStyle: TextStyle(height: 0),
                    hintStyle: Theme.of(context).textTheme.subtitle1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
