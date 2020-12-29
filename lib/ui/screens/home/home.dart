import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/tab/tab.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';

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