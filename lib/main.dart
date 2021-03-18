import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/login/login_bloc.dart';
import 'package:form_it/logic/blocs/register/register_bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/tab/tab_bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';

import 'package:form_it/ui/screens/add_edit_screen.dart';
import 'package:form_it/ui/screens/authenticate/login/login_screen.dart';
import 'package:form_it/ui/screens/authenticate/signup/signup_screeen.dart';
import 'package:form_it/ui/screens/home/home.dart';
import 'package:form_it/ui/screens/splash_screen.dart';

import 'package:form_it/ui/widgets/app_scroll_behavior.dart';
import 'package:form_it/logic/localizations/constants.dart';

import 'package:people_repository/people_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FormItApp());
}

class FormItApp extends StatefulWidget {
  @override
  _FormItAppState createState() => _FormItAppState();
}

class _FormItAppState extends State<FormItApp> {
  final UserRepository _userRepository = UserRepository();
  final PeopleRepository _peopleRepository = FirebasePeopleRepository();

  @override
  Widget build(BuildContext context) {

    _getTheme(){
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffd1dbf1),
        accentColor: Color(0xffffdcf7),
        primaryColorLight: Color(0xffe2ecf2),
        textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            headline2: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black),
            bodyText1: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black),
            bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            subtitle1: TextStyle(fontSize: 12, color: Colors.grey),
            subtitle2: TextStyle(fontSize: 12, color: Colors.black),
            button: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: Color(0xffdda9c4))),
      );
    }

    _getRoutes() {
      return <String, WidgetBuilder>{
        "/": (BuildContext context) {
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
              if (state is AuthenticationStateUnauthenticated) {
                return BlocProvider<LoginBloc>(
                  create: (context) => LoginBloc(userRepository: _userRepository),
                  child: LoginScreen(),
                );
              } else if (state is AuthenticationStateAuthenticated) {
                return HomeScreen(name: state.user.email ?? "");
              }
              return SplashScreen();
            },
          );
        },
        "/signUp": (BuildContext context) {
          return BlocProvider<RegisterBloc>(
              create: (context) => RegisterBloc(userRepository: _userRepository),
              child: SignUpScreen());
        },
        "/add": (BuildContext context) {
          return AddEditScreen(
            onSave: (nickname, level) {
              BlocProvider.of<PeopleBloc>(context)
                  .add(AddPerson(Person(nickname, level)));
            },
            isEditing: false,
          );
        },
        "/edit": (BuildContext context) {
          return AddEditScreen(
            onSave: (nickname, level) {
              BlocProvider.of<PeopleBloc>(context)
                  .add(UpdatePerson(Person(nickname, level)));
            },
            isEditing: true,
          );
        },
      };
    }

    _getBlocProviders() {
      return [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) {
            final authBloc = AuthenticationBloc(authService: _userRepository);
            authBloc.add(AppStarted());
            return authBloc;
          },
        ),
        BlocProvider<PeopleBloc>(
          create: (context) {
            return PeopleBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              peopleRepository: _peopleRepository,
            )..add(LoadPeople());
          },
        ),
        BlocProvider<FilteredPeopleBloc>(
          create: (context) => FilteredPeopleBloc(
            peopleBloc: BlocProvider.of<PeopleBloc>(context),
          ),
        ),
        BlocProvider<TeamsBloc>(
          create: (context) {
            return TeamsBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              teamsRepository:
              FirebaseTeamRepository(peopleRepository: _peopleRepository),
            )..add(LoadTeams());
          },
        ),
        BlocProvider<SettingsBloc>(
          create: (context) {
            return SettingsBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              settingsRepository: FirebaseSettingsRepository(),
            )..add(LoadSettings());
          },
        ),
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
      ];
    }

    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: MaterialApp(
        title: "Form It",
        color: Colors.white,
        localizationsDelegates: LOCALIZATION_DELEGATES,
        supportedLocales:
            SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
        debugShowCheckedModeBanner: false,
        theme: _getTheme(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: child,
          );
        },
        initialRoute: '/',
        routes: _getRoutes(),
      ),
    );


  }
}
