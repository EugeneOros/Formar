import 'package:form_it/config/dependency.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/filtered_people_bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/filtered_people_event.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:form_it/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:repositories/repositories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'app_logo_search.dart';

class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
  final AppTab activeTab;

  AppTopBar({Key? key, required this.activeTab}) : super(key: key);

  @override
  _AppTopBarState createState() => _AppTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
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

    List<Widget> getActions(AppTab activeTab) {
      switch (activeTab) {
        case AppTab.players:
          return [
            IconButtonAppBar(
              icon: logoSearch.state.isFlipped ? Icons.close : Icons.search,
              tooltip: MaterialLocalizations.of(context).searchFieldLabel,
              onPressed: () {
                setState(() {
                  logoSearch.state.flip();
                });
              },
            ),
            BlocBuilder<FilteredPeopleBloc, FilteredPeopleState>(
              builder: (context, state) {
                VisibilityFilter currentFilter = VisibilityFilter.all;
                if (state is FilteredPeopleLoaded) {
                  currentFilter = state.activeFilter;
                }
                return SizedBox(
                  width: 40,
                  height: 40,
                  child: PopupMenuButton<VisibilityFilter>(
                    offset: Offset(0, 55 + (46 * VisibilityFilter.values.indexOf(currentFilter).toDouble())),
                    initialValue: currentFilter,
                    tooltip: AppLocalizations.of(context)!.filter,
                    // child: IconButtonAppBar(onPressed: (){}, icon: Icons.filter_list_rounded),
                    icon: Icon(
                      Icons.filter_list_rounded,
                      color: Colors.black,
                    ),
                    shape: _ShapedWidgetBorder(padding: 10, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    padding: EdgeInsets.all(0),
                    color: Colors.black,
                    onSelected: (VisibilityFilter filter) {
                      switch (filter) {
                        case VisibilityFilter.all:
                          BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.all));
                          break;
                        case VisibilityFilter.inactive:
                          BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.inactive));
                          break;
                        case VisibilityFilter.active:
                          BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.active));
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<VisibilityFilter>>[
                      PopupMenuItem<VisibilityFilter>(
                        value: VisibilityFilter.all,
                        child: Text(AppLocalizations.of(context)!.all, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
                      ),
                      PopupMenuItem<VisibilityFilter>(
                        value: VisibilityFilter.active,
                        child:
                            Text(AppLocalizations.of(context)!.active, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
                      ),
                      PopupMenuItem<VisibilityFilter>(
                        value: VisibilityFilter.inactive,
                        child:
                            Text(AppLocalizations.of(context)!.inactive, style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButtonAppBar(
              icon: Icons.toggle_off_outlined,
              tooltip: AppLocalizations.of(context)!.allPlayersInactive,
              onPressed: () {
                BlocProvider.of<PeopleBloc>(context).add(TurnOffPeople());
              },
            ),
            IconButtonAppBar(
              icon: Icons.add,
              tooltip: AppLocalizations.of(context)!.addPlayer,
              onPressed: () {
                Navigator.of(context).pushNamed("/add");
              },
            ),
          ];
        case AppTab.teams:
          return [
            IconButtonAppBar(
              icon: Icons.delete,
              tooltip: AppLocalizations.of(context)!.removeAllTeams,
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
                  },
                );
              },
            ),
            BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
              if (state is PeopleLoaded) {
                return BlocBuilder<SettingsBloc, SettingsState>(builder: (settingsContext, settingsState) {
                  if (settingsState is SettingsLoaded) {
                    int counterTeamMembers = settingsState.settings!.counterTeamMembers!;
                    return IconButtonAppBar(
                        icon: Icons.add,
                        tooltip: AppLocalizations.of(context)!.addTeam,
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
                                      BlocProvider.of<TeamsBloc>(context).add(FormTeams(true, counterTeamMembers,
                                          defaultReplacementName: AppLocalizations.of(context)!.replacement,
                                          defaultTeamName: AppLocalizations.of(context)!.team));
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
                                        BlocProvider.of<TeamsBloc>(context).add(FormTeams(false, counterTeamMembers,
                                            defaultReplacementName: AppLocalizations.of(context)!.replacement,
                                            defaultTeamName: AppLocalizations.of(context)!.team));
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
          ];
        case AppTab.tournament:
          return [
            IconButtonAppBar(
              icon: Icons.add,
              tooltip: AppLocalizations.of(context)!.addTeam,
              onPressed: () {
                Navigator.of(context).pushNamed("/add_tournament");
              },
            )
          ];
        case AppTab.settings:
          return [];
      }
    }

    return AppBar(
      // primary: false,
      titleSpacing: 0,
      elevation: 0.0,
      toolbarHeight: 60,
      shadowColor: Colors.transparent,
      backgroundColor: widget.activeTab == AppTab.teams ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
      title: logoSearch..state.closeSearch(widget.activeTab),
      actions: getActions(widget.activeTab),
    );
  }
}

class _ShapedWidgetBorder extends RoundedRectangleBorder {
  _ShapedWidgetBorder({
    required this.padding,
    side = BorderSide.none,
    borderRadius = BorderRadius.zero,
  }) : super(side: side, borderRadius: borderRadius);
  final double padding;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    double triangleOffset = 20;
    return Path()
      ..moveTo(rect.width - (triangleOffset - 7), rect.top)
      ..lineTo(rect.width - (triangleOffset + 0), rect.top - 8.0)
      ..lineTo(rect.width - (triangleOffset + 7), rect.top)
      ..addRRect(borderRadius.resolve(textDirection).toRRect(Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height)));
  }
}
