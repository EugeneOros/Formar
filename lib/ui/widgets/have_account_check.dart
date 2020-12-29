import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
          login ? AppLocalizations.of(context).dontHaveAccount : AppLocalizations.of(context).alreadyHaveAccount,
          style: TextStyle(color: PrimaryColor),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            login ? AppLocalizations.of(context).signUp : AppLocalizations.of(context).signIn,
            style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

