import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/widgets/dialog.dart';
import 'package:form_it/ui/widgets/rounded_button.dart';
import 'package:form_it/ui/widgets/search_player.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';
import 'package:repositories/repositories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'pages/people_page.dart';
import 'pages/teams_page.dart';
import 'pages/tournament_page.dart';
import 'pages/settings_page.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [
      PeoplePage(),
      TeamsPage(),
      TournamentPage(),
      SettingsPage()
    ];

    String _getTeamCountString(
        List<Player> people, int memberCount, bool isBalanced) {
      int availablePeopleCount =
          people.where((element) => element.available).length;
      double averageTeamCount = (availablePeopleCount / memberCount);
      double averageMemberCount =
          availablePeopleCount / averageTeamCount.ceil();
      if (isBalanced) {
        if (availablePeopleCount % averageTeamCount.ceil() == 0)
          return averageTeamCount.ceil().toString() +
              " " +
              AppLocalizations.of(context)!.teamsOf +
              " " +
              averageMemberCount.round().toString() +
              " " +
              AppLocalizations.of(context)!.peopleTeam;
        return averageTeamCount.ceil().toString() +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            averageMemberCount.floor().toString() +
            "-" +
            averageMemberCount.ceil().toString() +
            " " +
            AppLocalizations.of(context)!.peopleTeam;
      } else {
        return averageTeamCount.floor().toString() +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            memberCount.toString() +
            " " +
            AppLocalizations.of(context)!.peopleTeam +
            " + " +
            AppLocalizations.of(context)!.replacement;
      }
    }

    final List<List<Widget>> _actionsSet = [
      [
        IconButton(
          icon: Icon(Icons.search, color: AppBarItemColor),
          onPressed: () {
            showSearch(context: context, delegate: SearchPlayer());
          },
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
            return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (settingsContext, settingsState) {
              if (settingsState is SettingsLoaded) {
                var counterTeamMembers =
                    settingsState.settings!.counterTeamMembers;
                return IconButton(
                    icon: Icon(
                        Icons.replay_rounded
                        //workspaces_outline //auto_awesome_mosaic  //alt_route //settings_backup_restore_rounded,
                        ,
                        color: AppBarItemColor),
                    onPressed: () {
                      if ((state.people
                                      .where((element) => element.available)
                                      .length /
                                  counterTeamMembers! <
                              2) ||
                          (state.people
                                      .where((element) => element.available)
                                      .length %
                                  counterTeamMembers ==
                              0)) {
                        BlocProvider.of<TeamsBloc>(context)
                            .add(FormTeams(true, counterTeamMembers));
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          double width = textSize(
                                      _getTeamCountString(state.people,
                                          counterTeamMembers, false),
                                      Theme.of(context).textTheme.bodyText2)
                                  .width +
                              40;
                          return AppDialog(
                            title: AppLocalizations.of(context)!.choseOption,
                            content: Column(children: [
                              Container(
                                height: 40,
                                width: width,
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[400]!,
                                      width: 1,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[400]!,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: TextButton(
                                  child: Text(
                                    _getTeamCountString(state.people,
                                        counterTeamMembers, true),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<TeamsBloc>(context).add(
                                        FormTeams(true, counterTeamMembers));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                height: 40,
                                width: width,
                                child: TextButton(
                                  child: Text(
                                    _getTeamCountString(state.people,
                                        counterTeamMembers, false),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onPressed: () {
                                    BlocProvider.of<TeamsBloc>(context).add(
                                        FormTeams(false, counterTeamMembers));
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ]),
                            actions: [
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.cancel,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }); // return settingsState.settings.counterTeamMembers;
              }
              return Padding(
                padding: const EdgeInsets.all(11.0),
                child: SpinKitThreeBounce(
                  color: Colors.black,
                  size: 15.0,
                ),
              );
            });
            // final double avarageTeamMember = state.people.where((element) => element.available).length /(state.people.where((element) => element.available).length / 6).ceil();

          }
          return Spacer();
        }),
      ],
      [],
      []
    ];

    final tabBloc = BlocProvider.of<TabBloc>(context);
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      Size size = MediaQuery.of(context).size;
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          shadowColor: Colors.transparent,
          backgroundColor: activeTab == AppTab.teams
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColor,
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
