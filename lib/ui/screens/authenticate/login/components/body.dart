import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/logic/services/auth.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/have_account_check.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/rounded_password_field.dart';
import 'background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Loading()
        : Background(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/login.svg',
                      height: size.height * 0.2,
                    ),
                    Text(
                      AppLocalizations.of(context).login.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: PrimaryColor),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 12.0),
                    RoundedInputField(
                      hintText: AppLocalizations.of(context).email,
                      validator: (val) => val.isEmpty ? AppLocalizations.of(context).errorEmail : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    RoundedPasswordField(
                      validator: (val) => val.length < 6
                          ? AppLocalizations.of(context).errorPassword
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    RoundedButton(
                        text: AppLocalizations.of(context).login,
                        color: PrimaryAssentColor,
                        onPressed: () async {
                          print(email);
                          print(password);

                          if (_formKey.currentState.validate()) {
                            setState(() => isLoading = true);
                            dynamic result = await _authService
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                error = AppLocalizations.of(context).errorLogin;
                                isLoading = false;
                              });
                            }
                          }
                        }),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    HaveAccountCheck(
                      onTap: () {
                        Navigator.of(context).pushNamed("/signUp");
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
