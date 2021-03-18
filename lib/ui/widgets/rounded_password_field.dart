import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/text_field_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> validator;
  final TextEditingController controller;
  final bool obscureText;
  final Function onShowHide;

  const RoundedPasswordField(
      {Key key,
      this.validator,
      this.controller,
      this.obscureText = true,
      this.onShowHide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyText2,
        controller: controller,
        cursorColor: Colors.black,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: TextFieldFillColor,
          hintText: AppLocalizations.of(context).password,
          prefixIcon: Icon(Icons.lock_rounded, color: Colors.black),
          suffixIcon: IconButton(
            icon: Icon(Icons.visibility, color: Colors.black),
            onPressed: this.onShowHide,
          ),
          border: borderRoundedTransparent,
          focusedBorder: borderRoundedTransparent,
          enabledBorder: borderRoundedTransparent,
        ),
      ),
    );
  }
}
