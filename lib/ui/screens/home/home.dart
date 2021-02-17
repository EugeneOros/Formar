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
import 'package:people_repository/people_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

    String _getTeamCountString(
        List<Person> people, int memberCount, bool isBalanced) {
      int availablePeopleCount =
          people.where((element) => element.available).length;
      double averageTeamCount = (availablePeopleCount / memberCount);
      double averageMemberCount =
          availablePeopleCount / averageTeamCount.ceil();
      if (isBalanced) {
        if (availablePeopleCount % averageTeamCount.ceil() == 0)
          return averageTeamCount.ceil().toString() +
              " " + AppLocalizations.of(context).teamsOf + " " +
              averageMemberCount.round().toString() +
              " " + AppLocalizations.of(context).peopleTeam;
        return averageTeamCount.ceil().toString() +
            " " + AppLocalizations.of(context).teamsOf + " " +
            averageMemberCount.floor().toString() +
            "-" +
            averageMemberCount.ceil().toString() +
            " " + AppLocalizations.of(context).peopleTeam;
      } else {
        return averageTeamCount.floor().toString() +
            " " + AppLocalizations.of(context).teamsOf + " " +
            memberCount.toString() +
            " " + AppLocalizations.of(context).peopleTeam + " + " + AppLocalizations.of(context).replacement;
      }
    }

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
            // final double avarageTeamMember = state.people.where((element) => element.available).length /(state.people.where((element) => element.available).length / 6).ceil();
            return IconButton(
              icon: Icon(Icons.replay_rounded//workspaces_outline //auto_awesome_mosaic  //alt_route //settings_backup_restore_rounded,
              ,
                  color: AppBarItemColor),
              onPressed: () {
                if (state.people.where((element) => element.available).length /
                        6 <
                    2) {
                  BlocProvider.of<TeamsBloc>(context).add(FormTeams(true));
                  return;
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context).choseOption, style: TextStyle(fontSize: 23, ),textAlign: TextAlign.center,),
                      content: Container(
                        height: 200,
                        child: Column(children: [
                          RoundedButton(
                            text: _getTeamCountString(state.people, 6, true),
                            onPressed: () {
                              BlocProvider.of<TeamsBloc>(context)
                                  .add(FormTeams(true));
                              Navigator.of(context).pop();
                            },
                            sizeRatio: null,
                            textColor: Colors.black,
                            color: SecondaryColor,
                            marginVertical: 10.0,
                          ),
                          RoundedButton(
                            text: _getTeamCountString(state.people, 6, false),
                            onPressed: () {
                              BlocProvider.of<TeamsBloc>(context)
                                  .add(FormTeams(false));
                              Navigator.of(context).pop();
                            },
                            sizeRatio: null,
                            textColor: Colors.black,
                            color: SecondaryColor,
                            marginVertical: 10.0,
                          ),
                        ]),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: Colors.black),),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }
          return Padding();
        }),
      ],
      [],
      []
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
