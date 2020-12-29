import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/ui/screens/authenticate/signup/components/background.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/auth.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/have_account_check.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/rounded_password_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
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
                  children: [
                    SvgPicture.asset(
                      "assets/signup.svg",
                      height: size.height * 0.2,
                    ),
                    Text(
                      AppLocalizations.of(context).signUp.toUpperCase(),
                      style: TextStyle(
                        color: PrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
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
                      validator: (val) => val.isEmpty
                          ? AppLocalizations.of(context).errorEmail
                          : null,
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
                      text: AppLocalizations.of(context).signUp,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => isLoading = true);
                          dynamic result = await _authService
                              .signUpWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = AppLocalizations.of(context).errorSignUp;
                              isLoading = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
                      color: PrimaryAssentColor,
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    HaveAccountCheck(
                        login: false,
                        onTap: () {
                          Navigator.pop(context);
                        })
                  ],
                ),
              ),
            ),
          );
  }
}
