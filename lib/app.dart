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
import 'package:form_it/logic/blocs/tournament/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/pages/add_edit_tournament/view/add_edit_tournament_page.dart';

import 'package:form_it/pages/splash/splash_screen.dart';
import 'package:form_it/pages/authenticate/view/login_page.dart';
import 'package:form_it/pages/authenticate/view/signup_page.dart';
import 'package:form_it/pages/home/view/home_page.dart';
import 'package:form_it/pages/add_edit_team/view/add_edit_team_page.dart';
import 'package:form_it/pages/add_edit_player/view/add_edit_player_page.dart';
import 'package:form_it/widgets/app_scroll_behavior.dart';
import 'package:form_it/logic/localizations/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:repositories/repositories.dart';

import 'config/constants.dart';
import 'config/dependency.dart';
import 'logic/models/app_state_notifier.dart';

class FormarApp extends StatefulWidget {
  @override
  _FormarAppState createState() => _FormarAppState();
}

class _FormarAppState extends State<FormarApp> {
  final UserRepository _userRepository = UserRepository();
  final PlayersRepository _peopleRepository = FirebasePlayersRepository();

  @override
  Widget build(BuildContext context) {
    _getTheme({bool isDark = false}) {
      return ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        colorScheme: ColorScheme(
          onError: Colors.red,
          onSecondary: isDark ? DarkColor : Color(0xffffdcf7),
          brightness: isDark ? Brightness.dark : Brightness.light,
          onBackground: isDark ? DarkColorAccent : Colors.white,
          secondaryVariant: isDark ? DarkColor : Color(0xffffdcf7),
          error: Colors.redAccent,
          primaryVariant: isDark ? DarkColor : Color(0xffd1dbf1),
          background: isDark ? DarkColorAccent : Colors.white,
          surface: isDark ? DarkColorAccent : Colors.white,
          primary: isDark ? DarkColor : Color(0xffd1dbf1),
          secondary: isDark ? DarkColor : Color(0xffffdcf7),
          onSurface: isDark ? DarkColor : Color(0xfff4f9fa),
          onPrimary: isDark ? Color(0xff261c2c) : Color(0xff7aa1f5),
        ),
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: isDark ? DarkColor : Color(0xffd1dbf1),
        accentColor: isDark ? DarkColor : Color(0xffffdcf7),
        canvasColor: isDark ? DarkColorAccent : Colors.white,
        primaryColorLight: isDark ? DarkColor : Color(0xfff4f9fa),
        primaryColorDark: isDark ? Color(0xff261c2c) : Color(0xff7aa1f5),
        dividerColor: isDark ? Color(0xff17181c) : Colors.grey[400],
        shadowColor: isDark ? DarkColorShadowDark.withOpacity(0.6) : Colors.grey.withOpacity(0.3),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: isDark ? LightBlue : Colors.black,
        ),
        textTheme: TextTheme(
          headline1: GoogleFonts.tenorSans(fontSize: 21, fontWeight: FontWeight.bold, color: isDark ? LightBlue : Colors.black),
          // headline1: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: isDark ? LightBlue : Colors.black),
          headline2: GoogleFonts.tenorSans(fontSize: 17, fontWeight: FontWeight.w500, color: isDark ? LightBlue : Colors.black),
          // bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: isDark ? LightBlue : Colors.black),
          bodyText1: GoogleFonts.tenorSans(fontSize: 17, fontWeight: FontWeight.w300, color: isDark ? LightBlue : Colors.black),
          // bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          bodyText2: GoogleFonts.tenorSans(fontSize: 14, fontWeight: FontWeight.w200),
          // subtitle1: TextStyle(fontSize: 12, color: isDark ? LightBlue : Colors.grey),
          subtitle1: GoogleFonts.tenorSans(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? LightBlue : Colors.grey),
          // subtitle2: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: isDark ? Colors.white : Colors.black),
          subtitle2: GoogleFonts.tenorSans(fontSize: 11, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black),
          // button: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Color(0xffdda9c4)),
          button: GoogleFonts.tenorSans(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xffdda9c4)),
          // caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.black),
          caption: GoogleFonts.tenorSans(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      );
    }

    // _getRoutes() {
    //   return <String, WidgetBuilder>{
    //     "/": (BuildContext context) {
    //       return BlocBuilder<AuthenticationBloc, AuthenticationState>(
    //         builder: (BuildContext context, AuthenticationState state) {
    //           if (state is AuthenticationStateUnauthenticated) {
    //             return BlocProvider<LoginBloc>(
    //               create: (context) => LoginBloc(userRepository: _userRepository),
    //               child: LoginScreen(),
    //             );
    //           } else if (state is AuthenticationStateAuthenticated) {
    //             BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.players));
    //             return HomeScreen(email: state.user!.email ?? "");
    //           }
    //           return SplashScreen();
    //         },
    //       );
    //     },
    //     "/signUp": (BuildContext context) {
    //       return BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(userRepository: _userRepository), child: SignUpScreen());
    //     },
    //     "/add": (BuildContext context) {
    //       return AddEditPlayerScreen(
    //         onSave: (nickname, level, sex) {
    //           BlocProvider.of<PeopleBloc>(context).add(AddPerson(Player(nickname: nickname!, level: level!, sex: sex!)));
    //         },
    //         isEditing: false,
    //       );
    //     },
    //     "/edit": (BuildContext context) {
    //       return AddEditPlayerScreen(
    //         onSave: (nickname, level, sex) {
    //           BlocProvider.of<PeopleBloc>(context).add(UpdatePerson(Player(nickname: nickname!, level: level!, sex: sex!)));
    //         },
    //         isEditing: true,
    //       );
    //     },
    //     "/add_team": (BuildContext context) {
    //       return BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
    //         List<Player> players = [];
    //         if (state is PeopleLoaded) {
    //           players = state.people;
    //         }
    //         return Provider<List<Player>>.value(
    //           value: players,
    //           child: AddEditTeamScreen(
    //             onSave: (name, players) {
    //               BlocProvider.of<TeamsBloc>(context).add(
    //                 AddTeam(
    //                   Team(name: name!, players: players),
    //                 ),
    //               );
    //             },
    //             isEditing: false,
    //           ),
    //         );
    //       });
    //     },
    //     "/add_tournament": (BuildContext context) {
    //       return AddEditTournamentPage(
    //         onSave: (String? name, List<Team>? teams, int winPoints, int drawPoints, int lossPoints, int encountersNum) {
    //           BlocProvider.of<TournamentsBloc>(context).add(
    //             AddTournament(
    //               Tournament(
    //                 name: name!,
    //                 teams: teams,
    //                 winPoints: winPoints,
    //                 drawPoints: drawPoints,
    //                 lossPoints: lossPoints,
    //                 encountersNum: encountersNum,
    //               ),
    //             ),
    //           );
    //         },
    //         isEditing: false,
    //       );
    //     },
    //   };
    // }

    List<BlocProvider<Object?>> _getBlocProviders() {
      final TeamRepository _teamRepository = FirebaseTeamRepository(peopleRepository: _peopleRepository);
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
              // teamsRepository: FirebaseTeamRepository(peopleRepository: _peopleRepository),
              teamsRepository: _teamRepository,
            )..add(LoadTeams());
          },
        ),
        BlocProvider<TournamentsBloc>(
          create: (context) {
            return TournamentsBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              tournamentsRepository: FirebaseTournamentRepository(teamRepository: _teamRepository),
            )..add(LoadTournaments());
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

    return Consumer<AppStateNotifier>(builder: (context, appState, child) {
      return MultiBlocProvider(
        providers: _getBlocProviders(),
        child: MaterialApp(
          title: "Formar",
          color: appState.isDarkMode ? DarkColor : Colors.white,
          localizationsDelegates: LOCALIZATION_DELEGATES,
          // localeListResolutionCallback: LOCALIZATION_RESOLUTION,
          supportedLocales: SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
          debugShowCheckedModeBanner: false,
          theme: _getTheme(),
          darkTheme: _getTheme(isDark: true),
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: AppScrollBehavior(),
              child: child!,
            );
          },
          initialRoute: '/',
          // routes: _getRoutes(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return getPageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (BuildContext context, AuthenticationState state) {
                            if (state is AuthenticationStateUnauthenticated) {
                              return BlocProvider<LoginBloc>(
                                create: (context) => LoginBloc(userRepository: _userRepository),
                                child: LoginScreen(),
                              );
                            } else if (state is AuthenticationStateAuthenticated) {
                              // BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.players));
                              return Provider<UserRepository>.value(value: _userRepository, child: HomeScreen(email: state.user!.email ?? ""));
                            }
                            return SplashScreen();
                          },
                        ));
              case '/edit':
                return getPageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => AddEditPlayerPage(
                          onSave: (nickname, level, sex) {
                            BlocProvider.of<PeopleBloc>(context).add(UpdatePerson(Player(nickname: nickname!, level: level!, sex: sex!)));
                          },
                          isEditing: true,
                        ));
              case '/add_team':
                return getPageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
                          List<Player> players = [];
                          if (state is PeopleLoaded) {
                            players = state.people;
                          }
                          return Provider<List<Player>>.value(
                            value: players,
                            child: AddEditTeamScreen(
                              onSave: (name, players) {
                                BlocProvider.of<TeamsBloc>(context).add(
                                  AddTeam(
                                    Team(name: name!, players: players),
                                  ),
                                );
                              },
                              isEditing: false,
                            ),
                          );
                        }));
              case '/add_tournament':
                return getPageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => BlocBuilder<TeamsBloc, TeamsState>(builder: (context, state) {
                          List<Team> teams = [];
                          if (state is TeamsLoaded) {
                            teams = state.teams;
                          }
                          return Provider<List<Team>>.value(
                            value: teams,
                            child: AddEditTournamentPage(
                              onSave: (
                                  {String? name,
                                  List<Team>? teams,
                                  List<Match>? matches,
                                  required int winPoints,
                                  required int drawPoints,
                                  required int lossPoints,
                                  required int encountersNum}) {
                                // List<Match> matches = [Match(firstTeam: "JK", secondTeam: "HJ")];
                                BlocProvider.of<TournamentsBloc>(context).add(
                                  AddTournament(
                                    Tournament(
                                      ownerId: _userRepository.getUser()!.uid,
                                      name: name!,
                                      teams: teams,
                                      winPoints: winPoints,
                                      drawPoints: drawPoints,
                                      lossPoints: lossPoints,
                                      encountersNum: encountersNum,
                                      // matches: matches,
                                    ),
                                  ),
                                );
                              },
                              isEditing: false,
                            ),
                          );
                        }));
              case '/add':
                return getPageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => AddEditPlayerPage(
                    onSave: (nickname, level, sex) {
                      BlocProvider.of<PeopleBloc>(context).add(AddPerson(Player(nickname: nickname!, level: level!, sex: sex!)));
                    },
                    isEditing: false,
                  ),
                );
              case '/signUp':
                return getPageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc(userRepository: _userRepository), child: SignUpScreen()));
              default:
                throw Exception('Invalid route: ${settings.name}');
            }
          },
        ),
      );
    });
  }
}

// class MyCustomRoute<T> extends MaterialPageRoute<T> {
//   MyCustomRoute({ required WidgetBuilder builder, required RouteSettings settings })
//       : super(builder: builder, settings: settings);
//
//   @override
//   Widget buildTransitions(BuildContext context,
//       Animation<double> animation,
//       Animation<double> secondaryAnimation,
//       Widget child) {
//     if (settings.isInitialRoute)
//       return child;
//     // Fades between routes. (If you don't want any animation,
//     // just return child.)
//     return new FadeTransition(opacity: animation, child: child);
//   }
// }
