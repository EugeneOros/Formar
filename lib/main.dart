import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/screens/authenticate/login/login_screen.dart';
import 'package:form_it/ui/screens/authenticate/signup/signup_screeen.dart';
import 'package:form_it/ui/screens/home/home.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/auth.dart';
import 'package:form_it/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'logic/blocs/tab/tab_bloc.dart';
import 'logic/localizations/constants.dart';
import 'logic/models/user.dart';

// import 'pages/PeoplePage.dart';
// import 'pages/TeamsPage.dart';
// import 'pages/TournamentPage.dart';
// import 'pages/SettingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FormItApp());
}

class FormItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(

        value: AuthService().user,
        child: MaterialApp(
          localizationsDelegates: LOCALIZATION_DELEGATES,
          supportedLocales: SUPPORTED_LOCALES.map((languageCode) => Locale(languageCode)),
          debugShowCheckedModeBanner: false,
          home: Wrapper(),

          routes: <String, WidgetBuilder>{
            "/login": (BuildContext context) => new LoginScreen(),
            "/signUp": (BuildContext context) => new SignUpScreen(),
            "/home": (BuildContext context) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<TabBloc>(
                    create: (context) => TabBloc(AppTab.people),
                  ),
                ],
                child: HomeScreen(),
              );
            },
          },
        ));
  }
}

// class FormItApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _FormItAppState();
//   }
// }
//
// class _FormItAppState extends State<FormItApp> {
//   int _selectedPageIndex = 0;
//   final _pageOptions = [
//     PeoplePage(),
//     TeamsPage(),
//     TournamentPage(),
//     SettingsPage()
//   ];
//
//   final List<List<Widget>> _actionsSet = [
//     [
//       Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             onTap: () {},
//             child: Icon(Icons.search),
//           )),
//       Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             onTap: () {},
//             child: Icon(Icons.add),
//           ))
//     ],
//     [
//       Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             onTap: () {},
//             child: Icon(Icons.add),
//           ))
//     ],
//     [
//       Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             child: Icon(Icons.edit),
//           ))
//     ],
//     [
//       Padding(
//           padding: EdgeInsets.only(right: 20.0),
//           child: GestureDetector(
//             child: Icon(Icons.home),
//           ))
//     ]
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme:
//           ThemeData(primarySwatch: Colors.deepPurple, accentColor: Colors.pink),
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text("FormIt"),
//             actions: _actionsSet[_selectedPageIndex],
//           ),
//           body: _pageOptions[_selectedPageIndex], //(startingPerson: 'Eugene'),
//           bottomNavigationBar: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             currentIndex: _selectedPageIndex,
//             onTap: (int index) {
//               setState(() {
//                 _selectedPageIndex = index;
//               });
//             },
//             items: [
//               BottomNavigationBarItem(
//                   icon: _selectedPageIndex == 0
//                       ? Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/list_fill.svg"),
//                         )
//                       : Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/list_empty.svg"),
//                         ),
//                   title: Text('People')),
//               BottomNavigationBarItem(
//                   icon: _selectedPageIndex == 1
//                       ? Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/team_fill.svg"),
//                         )
//                       : Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/team_empty.svg"),
//                         ),
//                   title: Text('Teams')),
//               BottomNavigationBarItem(
//                   icon: _selectedPageIndex == 2
//                       ? Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/cup_fill.svg"),
//                         )
//                       : Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/cup_empty.svg"),
//                         ),
//                   title: Text('Tournament')),
//               BottomNavigationBarItem(
//                   icon: _selectedPageIndex == 3
//                       ? Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/settings_fill.svg"),
//                         )
//                       : Container(
//                           width: 30,
//                           height: 30,
//                           child: SvgPicture.asset("assets/settings_empty.svg"),
//                         ),
//                   title: Text('Settings')),
//             ],
//           )),
//     );
//   }
// }
