import 'package:form_it/config/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/pages/authenticate/widgets/have_account_check.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:form_it/logic/blocs/register/bloc.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late RegisterBloc _signUpBloc;

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
    Size size = MediaQuery.maybeOf(context)!.size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState) {
            return registerState.isSubmitting
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
                                'assets/signup.svg',
                                height: size.height * 0.17,
                              ),
                              SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.signUp.toUpperCase(),
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              SizedBox(height: size.height * 0.03),
                              Text(
                                registerState.isFailure
                                    ? AppLocalizations.of(context)!.errorSignUp
                                    : "",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14.0),
                              ),
                              SizedBox(height: 12.0),
                              RoundedInputField(
                                controller: _emailController,
                                hintText: AppLocalizations.of(context)!.email,
                                validator: (_) => registerState.isEmailValid
                                    ? null
                                    : AppLocalizations.of(context)!.errorEmail,
                              ),
                              SizedBox(height: 20.0),
                              RoundedPasswordField(
                                controller: _passwordController,
                                validator: (_) => registerState.isPasswordValid
                                    ? null
                                    : AppLocalizations.of(context)!.errorPassword,
                              ),
                              SizedBox(height: size.height * 0.03),
                              RoundedButton(
                                sizeRatio: 0.9,
                                text: AppLocalizations.of(context)!.signUp,
                                onPressed: _onLoginEmailAndPassword,
                              ),
                              SizedBox(height: size.height * 0.03),
                              HaveAccountCheck(
                                isLogin: false,
                                onTap: () {
                                  Navigator.pop(context);
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
      _signUpBloc.add(RegisterEventPressed(
          email: _emailController.text, password: _passwordController.text));
    }
  }
}
