import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/auth.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/have_account_check.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/rounded_password_field.dart';
import 'background.dart';

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
                      'LOGIN',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: PrimaryColor),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 12.0),
                    RoundedInputField(
                      hintText: "Email",
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    RoundedPasswordField(
                      validator: (val) => val.length < 6
                          ? 'Password need to have more then 5 chars'
                          : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    RoundedButton(
                        text: "Login",
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
                                error =
                                    'could not sign in with this credentials';
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
