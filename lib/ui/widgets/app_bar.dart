import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/app_dialog.dart';
import 'package:form_it/ui/widgets/icon_button_app_bar.dart';
import 'package:repositories/repositories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_logo_search.dart';

class AppTopBar extends StatefulWidget implements PreferredSizeWidget  {
  final AppTab activeTab;
  final _AppTopBarState state = _AppTopBarState();

  AppTopBar({Key? key, required this.activeTab}) : super(key: key);

  @override
  _AppTopBarState createState() => state;

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _AppTopBarState extends State<AppTopBar> {
  LogoSearch logoSearch = LogoSearch();

  @override
  Widget build(BuildContext context) {

    String _getTeamCountString(List<Player> people, int memberCount, bool isBalanced) {
      int availablePeopleCount = people.where((element) => element.available).length;
      double averageTeamCount = (availablePeopleCount / memberCount);
      double averageMemberCount = availablePeopleCount / averageTeamCount.ceil();
      if (isBalanced) {
        if (averageTeamCount.ceil() == 1) {
          averageTeamCount = 2;
          averageMemberCount = availablePeopleCount / averageTeamCount.ceil();
        }
        String rangeString = averageMemberCount.floor().toString() + "-";
        if (availablePeopleCount % averageTeamCount.ceil() == 0) rangeString = "";
        return AppLocalizations.of(context)!.form +
            " " +
            AppLocalizations.of(context)!.teamCount(averageTeamCount.ceil()) +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            rangeString +
            AppLocalizations.of(context)!.playersCount(averageMemberCount.ceil());
      } else {
        return AppLocalizations.of(context)!.form +
            " " +
            AppLocalizations.of(context)!.teamCount(averageTeamCount.floor()) +
            " " +
            AppLocalizations.of(context)!.teamsOf +
            " " +
            AppLocalizations.of(context)!.playersCount(memberCount) +
            " + " +
            AppLocalizations.of(context)!.replacement;
      }
    }

    List<Widget> getActions(AppTab activeTab){
      switch(activeTab){
        case AppTab.players:
          return [
            IconButtonAppBar(
              icon: logoSearch.state.isFlipped ? Icons.close : Icons.search,
              onPressed: () {
                setState(() {
                  logoSearch.state.flip();
                });
              },
            ),
            IconButtonAppBar(
              icon: Icons.toggle_off_outlined,
              onPressed: () {
                BlocProvider.of<PeopleBloc>(context).add(TurnOffPeople());
              },
            ),
            IconButtonAppBar(
              icon: Icons.add,
              onPressed: () {
                Navigator.of(context).pushNamed("/add");
              },
            ),
          ];
        case AppTab.teams:
          return [
            BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
              if (state is PeopleLoaded) {
                return BlocBuilder<SettingsBloc, SettingsState>(builder: (settingsContext, settingsState) {
                  if (settingsState is SettingsLoaded) {
                    int counterTeamMembers = settingsState.settings!.counterTeamMembers!;
                    return IconButton(
                        icon: Icon(Icons.add, color: AppBarItemColor),
                        onPressed: () {
                          if (state.people.where((element) => element.available).length == 1) {
                            Navigator.of(context).pushNamed("/add_team");
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
                                      AppLocalizations.of(context)!.newTeam,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      softWrap: true,
                                    ),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
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
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ButtonStyle(
                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<TeamsBloc>(context).add(FormTeams(true, counterTeamMembers));
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  if (!(state.people.where((element) => element.available).length / counterTeamMembers < 2) &&
                                      !(state.people.where((element) => element.available).length % counterTeamMembers == 0))
                                    TextButton(
                                      child: Text(
                                        _getTeamCountString(state.people, counterTeamMembers, false),
                                        style: Theme.of(context).textTheme.bodyText2,
                                        textAlign: TextAlign.center,
                                      ),
                                      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 10, vertical: 0))),
                                      onPressed: () {
                                        BlocProvider.of<TeamsBloc>(context).add(FormTeams(false, counterTeamMembers));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                ],
                                actionsHorizontal: [
                                  TextButton(
                                    child: Text(
                                      MaterialLocalizations.of(context).cancelButtonLabel.toLowerCase().capitalize(),
                                      style: Theme.of(context).textTheme.button,
                                      textAlign: TextAlign.center,
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
          ];
        case AppTab.tournament:
          return [];
        case AppTab.settings:
          return [];
      }
    }

    return AppBar(
      toolbarHeight: 65,
      shadowColor: Colors.transparent,
      backgroundColor: widget.activeTab == AppTab.teams ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
      title: logoSearch..state.closeSearch(widget.activeTab),
      actions: getActions(widget.activeTab),
    );
  }
}
