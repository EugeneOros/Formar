import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_event.dart';
import 'package:form_it/logic/blocs/login/login_bloc.dart';
import 'package:form_it/logic/blocs/login/login_event.dart';
import 'package:form_it/logic/blocs/login/login_state.dart';
import 'background.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/logic/services/user_repository.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/have_account_check.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/rounded_password_field.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginScreen({Key key, UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      _loginBloc.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc
          .add(LoginEventPasswordChanged(password: _passwordController.text));
    });
  }

  final _formKey = GlobalKey<FormState>();

  // String email = '';
  // String password = '';
  // String error = '';
  // bool isLoading = false;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      isPopulated && !loginState.isSubmitting;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState) {
          if (loginState.isFailure) {
            print("login fail");
          } else if (loginState.isSubmitting) {
            print("login submitting");
          } else if (loginState.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
          return Background(
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
                    SizedBox(height: size.height * 0.03),
                    // Text(
                    //   error,
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(color: Colors.red, fontSize: 14.0),
                    // ),
                    SizedBox(height: 12.0),
                    RoundedInputField(
                      controller: _emailController,
                      hintText: AppLocalizations.of(context).email,
                      validator: (_) => loginState.isEmailValid
                          ? null
                          : AppLocalizations.of(context).errorEmail,
                    ),
                    RoundedPasswordField(
                      controller: _passwordController,
                      validator: (_) => loginState.isPasswordValid
                          ? null
                          : AppLocalizations.of(context).errorPassword,
                    ),
                    SizedBox(height: size.height * 0.03),
                    RoundedButton(
                      text: AppLocalizations.of(context).login,
                      color: PrimaryAssentColor,
                      onPressed: _onLoginEmailAndPassword,
                    ),
                    SizedBox(height: size.height * 0.03),
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
        },
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    if (_formKey.currentState.validate()) {
      _loginBloc.add(LoginEventWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Body(),
//     );
//   }
// }
