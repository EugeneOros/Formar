import 'package:form_it/config/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/pages/authenticate/widgets/have_account_check.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/login/login_bloc.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  LoginBloc? _loginBloc;

  final _formKey = GlobalKey<FormState>();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) =>
      isPopulated && !loginState.isSubmitting;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(() {
      _loginBloc!.add(LoginEventEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc!
          .add(LoginEventPasswordChanged(password: _passwordController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      body: BlocListener(
        bloc: _loginBloc,
        listener: (BuildContext context, LoginState state) {
          if (state.isFailure) {
            print("login failure");
          } else if (state.isSubmitting) {
            print("login submitting");
          } else if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, loginState) {
            return loginState.isSubmitting
                ? Loading()
                : Container(
              alignment: Alignment.center,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Container(
                constraints: BoxConstraints(minWidth: 50, maxWidth: 500),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/login.svg',
                          height: size.height * 0.17,
                        ),
                        SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.login.toUpperCase(),
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          loginState.isFailure
                              ? AppLocalizations.of(context)!.errorLogin
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        RoundedInputField(
                          icon: Icons.person,
                          controller: _emailController,
                          hintText: AppLocalizations.of(context)!.email,
                          validator: (_) => loginState.isEmailValid
                              ? null
                              : AppLocalizations.of(context)!.errorEmail,
                        ),
                        SizedBox(height: 20.0),
                        RoundedPasswordField(
                          controller: _passwordController,
                          validator: (_) => loginState.isPasswordValid
                              ? null
                              : AppLocalizations.of(context)!.errorPassword,
                        ),
                        SizedBox(height: size.height * 0.03),
                        RoundedButton(
                          sizeRatio: 0.9,
                          text: AppLocalizations.of(context)!.login,
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
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    if (_formKey.currentState!.validate()) {
      _loginBloc!.add(LoginEventWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
