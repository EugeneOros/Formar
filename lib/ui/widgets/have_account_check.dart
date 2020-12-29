import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';


class HaveAccountCheck extends StatelessWidget {
  final bool login;
  final Function onTap;
  const HaveAccountCheck({
    Key key, this.login = true, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an Account ? " : "Already have an Account ? ",
          style: TextStyle(color: PrimaryColor),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

