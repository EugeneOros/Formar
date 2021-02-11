import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/login/login_bloc.dart';
import 'package:form_it/logic/blocs/register/register_bloc.dart';
import 'package:form_it/ui/screens/add_edit_screen.dart';
import 'package:form_it/ui/screens/authenticate/login/login_screen.dart';
import 'package:form_it/ui/screens/authenticate/signup/signup_screeen.dart';
import 'package:form_it/ui/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:form_it/ui/screens/splash_screen.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:people_repository/people_repository.dart';

import 'logic/blocs/authentication/authentication_event.dart';
import 'logic/blocs/people/bloc.dart';
import 'logic/blocs/tab/tab_bloc.dart';
import 'logic/localizations/constants.dart';

import 'package:user_repository/user_repository.dart';

import 'package:device_preview/device_preview.dart';

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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: _getBlocProviders(context),
        child: MaterialApp(
          title: "Form It",
          color: Colors.white,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: AppPrimaryColor,
            accentColor: AppAccentColor,

            // Define the default font family.
            // fontFamily: 'Georgia',

            // Define the default TextTheme. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            // textTheme: TextTheme(
            //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            // ),
          ),
          // locale: DevicePreview.locale(context), // Add the locale here
          // builder: DevicePreview.appBuilder, // Add the builder here
          localizationsDelegates: LOCALIZATION_DELEGATES,
          supportedLocales:
              SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
          debugShowCheckedModeBanner: false,
          home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (BuildContext context, AuthenticationState state) {
              if (state is AuthenticationStateUnauthenticated) {
                return BlocProvider<LoginBloc>(
                  create: (context) =>
                      LoginBloc(userRepository: _userRepository),
                  child: LoginScreen(),
                );
              } else if (state is AuthenticationStateAuthenticated) {
                return HomeScreen(name: state.user.email ?? "");
              }
              return SplashScreen();
            },
          ),
          routes: <String, WidgetBuilder>{
            "/signUp": (BuildContext context) {
              return BlocProvider<RegisterBloc>(
                  create: (context) =>
                      RegisterBloc(userRepository: _userRepository),
                  child: SignUpScreen());
            },
            "/add": (BuildContext context) {
              return AddEditScreen(
                onSave: (nickname, level) {
                  BlocProvider.of<PeopleBloc>(context).add(
                    AddPerson(Person(nickname, level, note: "none")),
                  );
                },
                isEditing: false,
              );
            },
            "/edit": (BuildContext context) {
              return AddEditScreen(
                onSave: (nickname, level) {
                  BlocProvider.of<PeopleBloc>(context).add(
                    UpdatePerson(Person(nickname, level, note: "none")),
                  );
                },
                isEditing: true,
              );
            },
          },
        ));
  }

  _getBlocProviders(BuildContext context) {
    return [
      BlocProvider<TabBloc>(
        create: (context) => TabBloc(),
      ),
      BlocProvider<PeopleBloc>(
        create: (context) {
          return PeopleBloc(
            peopleRepository: FirebasePeopleRepository(),
          )..add(LoadPeople());
        },
      ),
      BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) {
          final authBloc = AuthenticationBloc(authService: _userRepository);
          authBloc.add(AppStarted());
          return authBloc;
        },
      ),
      BlocProvider<FilteredPeopleBloc>(
        create: (context) => FilteredPeopleBloc(
          peopleBloc: BlocProvider.of<PeopleBloc>(context),
        ),
      ),
    ];
  }
}

// class Wrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (BuildContext context, AuthenticationState state) {
//           if (state is AuthenticationStateInitialized) {
//             return Scaffold(
//               body: Center(child: Text('Splash Screen')),
//             );
//           } else if (state is AuthenticationStateAuthenticated) {
//             return HomeScreen(name: state.user.email);
//           } else {
//             return BlocProvider<LoginBloc>(
//                 create: (context) => LoginBloc(userRepository: userRepository))
//           }
//         });
//   }
// }
