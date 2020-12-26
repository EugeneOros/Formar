import 'package:flutter/material.dart';
import 'package:form_it/shared/text_field_container.dart';
import 'colors.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> validator;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
            hintText: 'Password',
            icon: Icon(Icons.lock, color: PrimaryColor),
            suffixIcon: Icon(Icons.visibility, color: PrimaryColor),
            border: InputBorder.none),
      ),
    );
  }
}
