import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';

import 'pages/people_page.dart';
import 'pages/teams_page.dart';
import 'pages/tournament_page.dart';
import 'pages/settings_page.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [
      PeoplePage(),
      TeamsPage(),
      TournamentPage(),
      SettingsPage()
    ];

    final List<List<Widget>> _actionsSet = [
      [
        IconButton(
          icon: Icon(Icons.search, color: AppBarItemColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.toggle_off_outlined, color: AppBarItemColor),
          onPressed: () {
            BlocProvider.of<PeopleBloc>(context).add(
              TurnOffPeople(),
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.add, color: AppBarItemColor),
          onPressed: () {
            Navigator.of(context).pushNamed("/add");
          },
        ),
      ],
      [
        BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
          if (state is PeopleLoaded) {
            final double avarageTeamMember = state.people.length /(state.people.length / 6).ceil();
            return IconButton(
              icon: Icon(Icons.settings_backup_restore_rounded,
                  color: AppBarItemColor),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Chose format"),
                      content: Row(children: [
                        RoundedButton(
                          text: avarageTeamMember.floor().toString() +
                              "-" +
                              avarageTeamMember.ceil().toString(),
                          onPressed: () {},
                          sizeRatio: 0.3,
                        ),
                      ]),
                    );
                  },
                );
              },
            );
          }
          return Padding();
        }),
        // IconButton(
        //   icon: Icon(Icons.settings_backup_restore_rounded,
        //       color: AppBarItemColor),
        //   onPressed: () {
        //     BlocListener<PeopleBloc, PeopleState>(
        //       listener: (context, state) {
        //         // if (state is PeopleLoaded) {
        //         showDialog(
        //           context: context,
        //           builder: (BuildContext context) {
        //             return AlertDialog(
        //               title: Text("Chose format"),
        //               content: Row(children: [
        //                 RoundedButton(
        //                     text: "3-4", onPressed: () {}, sizeRatio: 0.3),
        //               ]),
        //             );
        //           },
        //         );
        //       },
        //     );
        //     // showDialog(
        //     //     context: context,
        //     //     builder: (BuildContext context) {
        //     //       return AlertDialog(
        //     //         title: Text("Chose format"),
        //     //         content: Row(
        //     //           children: [
        //     //             RoundedButton(
        //     //               text: "3-4",
        //     //               onPressed: () {},
        //     //               sizeRatio: 0.3,
        //     //             ),
        //     //           ],
        //     //         ),
        //     //         actions: <Widget>[
        //     //           FlatButton(
        //     //             child: Text('Cancel'),
        //     //             onPressed: () {
        //     //               Navigator.of(context).pop();
        //     //             },
        //     //           )
        //     //         ],
        //     //       );
        //     //     });
        //   },
        // ),
      ],
      [
        // Padding(
        //     padding: EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       child: Icon(Icons.edit, color: AppBarItemColor),
        //     ))
      ],
      [
        // Padding(
        //     padding: EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       child: Icon(Icons.home, color: AppBarItemColor),
        //     )),
      ]
    ];
    final tabBloc = BlocProvider.of<TabBloc>(context);
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          shadowColor: Colors.transparent,
          backgroundColor: SecondaryAssentColor,
          title: SvgPicture.asset(
            'assets/logo_rounded_black.svg',
            height: 45,
          ),
          //Text("Form It", style: TextStyle(color: AppBarItemColor)),
          actions: _actionsSet[AppTab.values.indexOf(activeTab)],
        ),
        body: _pageOptions[AppTab.values.indexOf(activeTab)],
        bottomNavigationBar: TabSelector(
          activeTab: activeTab,
          onTabSelected: (tab) => tabBloc.add(UpdateTab(tab)),
        ),
      );
    });
  }
}
