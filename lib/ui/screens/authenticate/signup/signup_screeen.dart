import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'background.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/have_account_check.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/rounded_password_field.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/register/bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  RegisterBloc _signUpBloc;

  final _formKey = GlobalKey<FormState>();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(RegisterState loginState) =>
      isPopulated && !loginState.isSubmitting;

  @override
  void initState() {
    super.initState();
    _signUpBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(() {
      _signUpBloc.add(RegisterEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _signUpBloc.add(
          RegisterEventPasswordChanged(password: _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener(
        cubit: _signUpBloc,
        listener: (BuildContext context, RegisterState state) {
          if (state.isFailure) {
            print("register failure");
          } else if (state.isSubmitting) {
            print("register submitting");
            Loading();
          } else if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            return registerState.isSubmitting
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
                              AppLocalizations.of(context).signUp.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: PrimaryColor),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Text(
                              registerState.isFailure
                                  ? AppLocalizations.of(context).errorSignUp
                                  : "",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.red, fontSize: 14.0),
                            ),
                            SizedBox(height: 12.0),
                            RoundedInputField(
                              controller: _emailController,
                              hintText: AppLocalizations.of(context).email,
                              validator: (_) => registerState.isEmailValid
                                  ? null
                                  : AppLocalizations.of(context).errorEmail,
                            ),
                            RoundedPasswordField(
                              controller: _passwordController,
                              validator: (_) => registerState.isPasswordValid
                                  ? null
                                  : AppLocalizations.of(context).errorPassword,
                            ),
                            SizedBox(height: size.height * 0.03),
                            RoundedButton(
                              text: AppLocalizations.of(context).signUp,
                              color: PrimaryAssentColor,
                              onPressed: _onLoginEmailAndPassword,
                            ),
                            SizedBox(height: size.height * 0.03),
                            HaveAccountCheck(
                              login: false,
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    if (_formKey.currentState.validate()) {
      _signUpBloc.add(RegisterEventPressed(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
