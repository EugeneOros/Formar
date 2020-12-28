import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import './people_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/blocs/tab/tab_bloc.dart';
import 'package:form_it/blocs/tab/tab_event.dart';
import 'package:form_it/models/app_tab.dart';
import 'package:form_it/shared/colors.dart';
import 'package:form_it/widgets/tab_selector.dart';

import 'pages/PeoplePage.dart';
import 'pages/TeamsPage.dart';
import 'pages/TournamentPage.dart';
import 'pages/SettingsPage.dart';

class HomeScreen extends StatelessWidget {
  final _pageOptions = [
    PeoplePage(),
    TeamsPage(),
    TournamentPage(),
    SettingsPage()
  ];

  final List<List<Widget>> _actionsSet = [
    [
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.search),
          )),
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.add),
          ))
    ],
    [
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () {},
            child: Icon(Icons.add),
          ))
    ],
    [
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(Icons.edit),
          ))
    ],
    [
      Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            child: Icon(Icons.home),
          ))
    ]
  ];

  @override
  Widget build(BuildContext context) {
    // final tabBloc = TabBloc(AppTab.people);
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return  BlocBuilder<TabBloc, AppTab>(
        builder: (context, activeTab){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: PrimaryColor,
              title: Text("Form It"),
              actions: _actionsSet[AppTab.values.indexOf(activeTab)],
            ),
            body: _pageOptions[AppTab.values.indexOf(activeTab)],
            bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
            ),
          );
        }
    );
  }
}

// class Home extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _HomeState();
//   }
// }
//
//
// class _HomeState extends State<Home> {
//   int _selectedPageIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     final tabBloc = BlocProvider.of<TabBloc>(context);
//     return  BlocBuilder<TabBloc, AppTab>(
//         builder: (context, activeTab){
//           return Scaffold(
//             appBar: AppBar(
//               backgroundColor: PrimaryColor,
//               title: Text("Form It"),
//               actions: _actionsSet[AppTab.values.indexOf(activeTab)],
//             ),
//             body: _pageOptions[AppTab.values.indexOf(activeTab)],
//             bottomNavigationBar: TabSelector(
//               activeTab: activeTab,
//               onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
//             ),
//           );
//         }
//     );
//   }
// }

// return MaterialApp(
// debugShowCheckedModeBanner: false,
// theme:
// ThemeData(primarySwatch: Colors.deepPurple, accentColor: Colors.pink),
// home: Scaffold(
// appBar: AppBar(
// backgroundColor: PrimaryColor,
// title: Text("FormIt"),
// actions: _actionsSet[_selectedPageIndex],
// ),
// body: _pageOptions[_selectedPageIndex], //(startingPerson: 'Eugene'),
// bottomNavigationBar: TabSelector(acticeTab: ) ),
// );

// BottomNavigationBar(
// type: BottomNavigationBarType.fixed,
// currentIndex: _selectedPageIndex,
// onTap: (int index) {
// setState(() {
// _selectedPageIndex = index;
// });
// },
// items: [
// BottomNavigationBarItem(
// icon: _selectedPageIndex == 0
// ? Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/list_fill.svg"),
// )
// : Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/list_empty.svg"),
// ),
// title: Text('People')),
// BottomNavigationBarItem(
// icon: _selectedPageIndex == 1
// ? Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/team_fill.svg"),
// )
// : Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/team_empty.svg"),
// ),
// title: Text('Teams')),
// BottomNavigationBarItem(
// icon: _selectedPageIndex == 2
// ? Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/cup_fill.svg"),
// )
// : Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/cup_empty.svg"),
// ),
// title: Text('Tournament')),
// BottomNavigationBarItem(
// icon: _selectedPageIndex == 3
// ? Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/settings_fill.svg"),
// )
// : Container(
// width: 30,
// height: 30,
// child: SvgPicture.asset("assets/settings_empty.svg"),
// ),
// title: Text('Settings')),
// ],
// )