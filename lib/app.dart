import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/login/bloc.dart';
import 'package:form_it/logic/blocs/register/bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';

import 'package:form_it/pages/splash/splash_screen.dart';
import 'package:form_it/pages/authenticate/view/login_page.dart';
import 'package:form_it/pages/authenticate/view/signup_page.dart';
import 'package:form_it/pages/home/view/home_page.dart';
import 'package:form_it/pages/add_edit_team/view/add_edit_team_page.dart';
import 'package:form_it/pages/add_edit_player/view/add_edit_player_page.dart';
import 'package:form_it/widgets/app_scroll_behavior.dart';
import 'package:form_it/logic/localizations/constants.dart';

import 'package:repositories/repositories.dart';


class FormItApp extends StatefulWidget {
  @override
  _FormItAppState createState() => _FormItAppState();
}

class _FormItAppState extends State<FormItApp> {
  final UserRepository _userRepository = UserRepository();
  final PlayersRepository _peopleRepository = FirebasePlayersRepository();

  @override
  Widget build(BuildContext context) {
    _getTheme() {
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xffd1dbf1),
        accentColor: Color(0xffffdcf7),
        primaryColorLight: Color(0xffe2ecf2),
        dividerColor: Colors.grey[400],
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          subtitle1: TextStyle(fontSize: 12, color: Colors.grey),
          subtitle2: TextStyle(fontSize: 11, color: Colors.black),
          button: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color(0xffdda9c4)),
          caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
        ),
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
                //todo
                BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.players));
                return HomeScreen(email: state.user!.email ?? "");
              }
              return SplashScreen();
            },
          );
        },
        "/signUp": (BuildContext context) {
          return BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(userRepository: _userRepository), child: SignUpScreen());
        },
        "/add": (BuildContext context) {
          return AddEditPlayerScreen(
            onSave: (nickname, level, sex) {
              BlocProvider.of<PeopleBloc>(context).add(AddPerson(Player(nickname: nickname!, level: level!, sex: sex!)));
            },
            isEditing: false,
          );
        },
        "/edit": (BuildContext context) {
          return AddEditPlayerScreen(
            onSave: (nickname, level, sex) {
              BlocProvider.of<PeopleBloc>(context).add(UpdatePerson(Player(nickname: nickname!, level: level!, sex: sex!)));
            },
            isEditing: true,
          );
        },
        "/add_team": (BuildContext context) {
          return BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
            List<Player> players = [];
            if (state is PeopleLoaded) {
              players = state.people;
            }
            return AddEditTeamScreen(
              players: players,
              onSave: (name, players) {
                BlocProvider.of<TeamsBloc>(context).add(
                  AddTeam(
                    Team(name: name!, players: players),
                  ),
                );
              },
              isEditing: false,
            );
          });
        },
      };
    }

    List<BlocProvider<Object?>> _getBlocProviders() {
      return [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) {
            final authBloc = AuthenticationBloc(authService: _userRepository);
            authBloc.add(AppStarted());
            return authBloc;
          },
        ),
        BlocProvider<PeopleBloc>(
          lazy: false,
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
              teamsRepository: FirebaseTeamRepository(peopleRepository: _peopleRepository),
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
      // providers: [
      //   BlocProvider<AuthenticationBloc>(
      //     create: (BuildContext context) {
      //       final authBloc = AuthenticationBloc(authService: _userRepository);
      //       authBloc.add(AppStarted());
      //       return authBloc;
      //     },
      //   ),
      //   BlocProvider<PeopleBloc>(
      //     lazy: false,
      //     create: (context) {
      //       return PeopleBloc(
      //         authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      //         peopleRepository: _peopleRepository,
      //       )..add(LoadPeople());
      //     },
      //   ),
      //   BlocProvider<FilteredPeopleBloc>(
      //     create: (context) => FilteredPeopleBloc(
      //       peopleBloc: BlocProvider.of<PeopleBloc>(context),
      //     ),
      //   ),
      //   BlocProvider<TeamsBloc>(
      //     create: (context) {
      //       return TeamsBloc(
      //         authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      //         teamsRepository: FirebaseTeamRepository(peopleRepository: _peopleRepository),
      //       )..add(LoadTeams());
      //     },
      //   ),
      //   BlocProvider<SettingsBloc>(
      //     create: (context) {
      //       return SettingsBloc(
      //         authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      //         settingsRepository: FirebaseSettingsRepository(),
      //       )..add(LoadSettings());
      //     },
      //   ),
      //   BlocProvider<TabBloc>(
      //     create: (context) => TabBloc(),
      //   ),
      // ],
      child: MaterialApp(
        title: "Formar",
        color: Colors.white,
        localizationsDelegates: LOCALIZATION_DELEGATES,
        // localeListResolutionCallback: LOCALIZATION_RESOLUTION,
        supportedLocales: SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
        debugShowCheckedModeBanner: false,
        theme: _getTheme(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: AppScrollBehavior(),
            child: child!,
          );
        },
        initialRoute: '/',
        routes: _getRoutes(),
      ),
    );
  }
}
