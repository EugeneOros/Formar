import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:form_it/ui/screens/add_screen.dart';
import 'package:form_it/logic/services/auth.dart';
import 'package:form_it/ui/screens/authenticate/login/login_screen.dart';
import 'package:form_it/ui/screens/authenticate/signup/signup_screeen.dart';
import 'package:form_it/ui/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'logic/blocs/tab/tab_bloc.dart';
import 'logic/localizations/constants.dart';
import 'logic/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FormItApp());
}

class FormItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authService = AuthService();
    return StreamProvider<User>.value(
        value: _authService.user,
        child: MaterialApp(
          localizationsDelegates: LOCALIZATION_DELEGATES,
          supportedLocales:
              SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
          debugShowCheckedModeBanner: false,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<TabBloc>(
                create: (context) => TabBloc(),
              ),
              BlocProvider(
                create: (context) =>
                    AuthenticationBloc(authService: _authService),
              ),
            ],
            child: HomeScreen(),
          ),
          routes: <String, WidgetBuilder>{
            "/login": (BuildContext context) => new LoginScreen(),
            "/signUp": (BuildContext context) => new SignUpScreen(),
            "/home": (BuildContext context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<TabBloc>(
                    create: (context) => TabBloc(),
                  ),
                ],
                child: HomeScreen(),
              );
            },
            "/add": (BuildContext context) => new AddScreen(),
          },
        ));
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthInitialState) {
        return Scaffold();
      } else if (state is AuthenticatedState) {
        return HomeScreen();
      } else if (state is UnauthenticatedState) {
        return LoginScreen();
      }
      return null;
    });
  }
}
