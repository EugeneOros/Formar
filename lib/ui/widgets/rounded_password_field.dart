import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/text_field_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> validator;
  final TextEditingController controller;

  const RoundedPasswordField(
      {Key key,
      this.validator,
      this.controller})
      : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyText2,
        controller: widget.controller,
        cursorColor: Colors.black,
        obscureText: _isHidden,
        validator: widget.validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: TextFieldFillColor,
          hintText: AppLocalizations.of(context).password,
          prefixIcon: Icon(Icons.lock_rounded, color: Colors.black),
          suffixIcon: InkWell(
            child: Icon(Icons.visibility, color: Colors.black),
            onTap: _togglePasswordView,
          ),
          border: borderRoundedTransparent,
          focusedBorder: borderRoundedTransparent,
          enabledBorder: borderRoundedTransparent,
        ),
      ),
    );
  }
}
