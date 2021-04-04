import 'dart:math';

import 'package:flutter/services.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:form_it/ui/shared/constants.dart';
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
import 'package:form_it/ui/widgets/icon_button_app_bar.dart';
import 'package:form_it/ui/widgets/rounded_input_field.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';
import 'package:repositories/repositories.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'pages/players_page.dart';
import 'pages/teams_page.dart';
import 'pages/tournament_page.dart';
import 'pages/settings_page.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  HomeScreen({Key? key, required this.name}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controllerForSwitcher;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _controllerForSwitcher = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _isFlipped = false;
    _controllerForSwitcher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [PlayersPage(), TeamsPage(), TournamentPage(), SettingsPage()];

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

    final List<List<Widget>> _actionsSet = [
      [
        IconButtonAppBar(
          icon: _isFlipped ? Icons.close : Icons.search,
          onPressed: () {
            setState(() {
              _isFlipped = !_isFlipped;
              if(_isFlipped){
                _controllerForSwitcher.forward(from: 0.0);
              }else{
                BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.all, searchQuery: ""));
                _controllerForSwitcher.reverse();
              }
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
      ],
      [
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
      ],
      [],
      []
    ];

    final width = Tween<double>(
      begin: 30.0,
      end: MediaQuery.of(context).size.width,
    ).animate(
      CurvedAnimation(
        parent: _controllerForSwitcher,
        curve: Interval(
          0.5, 1.0,
          curve: Curves.easeInOutQuart,
        ),
      ),
    );

    Widget _logo() {
      return Container(
        decoration: roundedShadowDecoration,
        child: SvgPicture.asset(
          'assets/logo_rounded_black.svg',
          height: 30,
        ),
      );
    }

    // Widget _circle() {
    //   return AnimatedContainer(
    //     curve: Curves.easeInOutQuart,
    //     duration: Duration(seconds: 1),
    //     width: _isExpandedField ? MediaQuery.of(context).size.width*2/3 : 30,
    //     child: Container(
    //       height: 30,
    //       width: 30,
    //       child: TextFormField(
    //           style: Theme.of(context).textTheme.bodyText2,
    //           cursorColor: Colors.black,
    //           decoration: InputDecoration(
    //             filled: true,
    //             fillColor: TextFieldFillColor,
    //             border: borderRoundedTransparent,
    //             focusedBorder: borderRoundedTransparent,
    //             enabledBorder: borderRoundedTransparent,
    //           )),
    //     ),
    //   );
    // }

    Widget __transitionBuilder(Widget widget, Animation<double> animation) {
      final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: _controllerForSwitcher,
        child: widget,
        builder: (context, widget) {
          final isUnder = (ValueKey(_isFlipped) != widget!.key);
          var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isUnder ? -1.0 : 1.0;
          final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
          return Transform(
            transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
            child: widget,
            alignment: Alignment.center,
          );
        },
      );
    }

    final tabBloc = BlocProvider.of<TabBloc>(context);
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.transparent,
          backgroundColor: activeTab == AppTab.teams ? Theme.of(context).accentColor : Theme.of(context).primaryColor,
          title:
            AnimatedSwitcher(
                duration: Duration(milliseconds: 1000),
                transitionBuilder: __transitionBuilder,
                layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
                switchInCurve: Interval(
                  0.0, 1,
                  curve: Curves.easeInCirc,
                ),
                switchOutCurve: Interval(
                  0.0, 1,
                  curve: Curves.easeInBack.flipped,
                ),
                child: _isFlipped ?  AnimatedBuilder(
                    animation: _controllerForSwitcher,
                    builder: (context, widget) {
                      return RoundedInputField(
                        height: 30,
                        width:  width.value,
                        initialValue: "",
                        hintText: MaterialLocalizations.of(context).searchFieldLabel,
                        autofocus: true,
                        onChange: (value){
                          BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.all, searchQuery: value));
                        },
                        // icon: Icons.search,
                      );
                    }
                ) : _logo(),
              ),
          actions: _actionsSet[AppTab.values.indexOf(activeTab)],
        ),
        body: _pageOptions[AppTab.values.indexOf(activeTab)],
        bottomNavigationBar: TabSelector(
          activeTab: activeTab,
          onTabSelected: (tab) {
            tabBloc.add(UpdateTab(tab));
            BlocProvider.of<FilteredPeopleBloc>(context).add(UpdateFilter(filter: VisibilityFilter.all, searchQuery: ""));
            if(_isFlipped){
              _controllerForSwitcher.reverse();
              setState(() {
                _isFlipped = false;
              });
            }
          },
        ),
      );
    });
  }
}


