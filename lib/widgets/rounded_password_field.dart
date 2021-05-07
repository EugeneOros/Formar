import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/palette.dart';
import 'package:form_it/config/constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  const RoundedPasswordField(
      {Key? key,
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
    return Neumorphic(
      style: NeumorphicStyle(
          depth: -1.5,
          intensity: 1,
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
          lightSource: LightSource.topLeft,
          color: Theme.of(context).primaryColorLight.withOpacity(0.4)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          controller: widget.controller,
          cursorColor: Colors.black,
          obscureText: _isHidden,
          validator: widget.validator,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            errorStyle: TextStyle(height: 0),
            contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            filled: true,
            fillColor: TextFieldFillColor,
            hintText: AppLocalizations.of(context)!.password,
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
      ),
    );
  }
}
