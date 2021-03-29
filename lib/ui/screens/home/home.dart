import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/app_dialog.dart';
import 'package:form_it/ui/widgets/search_player.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';
import 'package:repositories/repositories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'pages/people_page.dart';
import 'pages/teams_page.dart';
import 'pages/tournament_page.dart';
import 'pages/settings_page.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [PeoplePage(), TeamsPage(), TournamentPage(), SettingsPage()];

    String _getTeamCountString(List<Player> people, int memberCount, bool isBalanced) {
      int availablePeopleCount = people.where((element) => element.available).length;
      double averageTeamCount = (availablePeopleCount / memberCount);
      double averageMemberCount = availablePeopleCount / averageTeamCount.ceil();
      if (isBalanced) {
        if (availablePeopleCount % averageTeamCount.ceil() == 0)
          return averageTeamCount.ceil().toString() +
              " " +
              AppLocalizations.of(context)!.teamsOf +
              " " +
              averageMemberCount.round().toString() +
              " " +
              AppLocalizations.of(context)!.playersTeam;
        return averageTeamCount.ceil().toString() +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            averageMemberCount.floor().toString() +
            "-" +
            averageMemberCount.ceil().toString() +
            " " +
            AppLocalizations.of(context)!.playersTeam;
      } else {
        return averageTeamCount.floor().toString() +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            memberCount.toString() +
            " " +
            AppLocalizations.of(context)!.playersTeam +
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
            return BlocBuilder<SettingsBloc, SettingsState>(builder: (settingsContext, settingsState) {
              if (settingsState is SettingsLoaded) {
                var counterTeamMembers = settingsState.settings!.counterTeamMembers;
                return IconButton(
                    icon: Icon(Icons.add, color: AppBarItemColor),
                    onPressed: () {
                      if ((state.people.where((element) => element.available).length / counterTeamMembers! < 2) ||
                          (state.people.where((element) => element.available).length % counterTeamMembers == 0)) {
                        BlocProvider.of<TeamsBloc>(context).add(FormTeams(true, counterTeamMembers));
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppDialog(
                            title: AppLocalizations.of(context)!.choseOption,
                            actionsVertical: [
                              TextButton(
                                child: Text(
                                  "Нова команда",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed("/add_team");
                                },
                              ),
                              TextButton(
                                child: Text(
                                  _getTeamCountString(state.people, counterTeamMembers, true),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onPressed: () {
                                  BlocProvider.of<TeamsBloc>(context).add(FormTeams(true, counterTeamMembers));
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  _getTeamCountString(state.people, counterTeamMembers, false),
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onPressed: () {
                                  BlocProvider.of<TeamsBloc>(context).add(FormTeams(false, counterTeamMembers));
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                            actionsHorizontal: [
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
          }
          return Spacer();
        }),
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.trash,
            size: 17,
          ), //Icon(Icons.clear, color: AppBarItemColor),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AppDialog(
                    title: AppLocalizations.of(context)!.sureDeleteTeams,
                    actionsHorizontal: [
                      TextButton(
                        onPressed: () {
                          BlocProvider.of<TeamsBloc>(context).add(DeleteAll());
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.yes,
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.no,
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                    ],
                  );
                });
            // BlocProvider.of<TeamsBloc>(context).add(DeleteAll());
            // Navigator.of(context).pushNamed("/add_team");
          },
        ),
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
          backgroundColor: activeTab == AppTab.teams ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
          title: SvgPicture.asset(
            'assets/logo_rounded_black.svg',
            height: 45,
          ),
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
