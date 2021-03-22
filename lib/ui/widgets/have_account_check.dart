import 'package:flutter/material.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/dependency.dart';


class HaveAccountCheck extends StatelessWidget {
  final bool isLogin;
  final Function? onTap;
  const HaveAccountCheck({
    Key? key, this.isLogin = true, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isLogin ? AppLocalizations.of(context)!.dontHaveAccount : AppLocalizations.of(context)!.alreadyHaveAccount,
          style: TextStyle(color: PrimaryColor),
        ),
        GestureDetector(
          onTap: onTap as void Function()?,
          child: Text(
            isLogin ? AppLocalizations.of(context)!.signUp : AppLocalizations.of(context)!.signIn,
            style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

