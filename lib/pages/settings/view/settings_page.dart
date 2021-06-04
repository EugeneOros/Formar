import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/blocs.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/logic/models/app_state_notifier.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/widgets/widgets.dart';

import 'package:form_it/pages/settings/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin{
  int? _currentPlayerCountValue = 1;

  void handleNumChange(int value) {
    _currentPlayerCountValue = value;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoaded) {
        _currentPlayerCountValue = state.settings!.counterTeamMembers;
        return Center(
          child: Container(
            constraints: BoxConstraints(minWidth: 50, maxWidth: 700),
            child: ListView(
              children: [
                ItemSettings(
                  icon: Icons.people,
                  text: AppLocalizations.of(context)!.playersInTeam,
                  drawDivider: true,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppDialog(
                            title: AppLocalizations.of(context)!.playersInTeam,
                            content: Padding(
                              padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
                              child: NumberPickerHorizontal(
                                handleValueChange: handleNumChange,
                                initValue: _currentPlayerCountValue,
                              ),
                            ),
                            actionsHorizontal: [
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.apply,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (state is SettingsLoaded) {
                                    print(_currentPlayerCountValue);
                                    BlocProvider.of<SettingsBloc>(context).add(
                                      UpdateSettings(state.settings!.copyWith(counterTeamMember: _currentPlayerCountValue)),
                                    );
                                  }
                                },
                              ),
                              TextButton(
                                child: Text(
                                  MaterialLocalizations.of(context).cancelButtonLabel.toLowerCase().capitalize(),
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }).then((value) {
                      _currentPlayerCountValue = state.settings!.counterTeamMembers;
                    });
                  },
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border(bottom: borderSideDivider)
                //   ),
                //   margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                // ),
                ItemSettings(
                  icon: Icons.logout,
                  text: AppLocalizations.of(context)!.signOut,
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AppDialog(
                            title: AppLocalizations.of(context)!.areYouSureLogOut,
                            actionsHorizontal: [
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.yes,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.players));
                                  Navigator.of(context).pop();
                                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                                },
                              ),
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.no,
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                ItemSettings(
                  icon: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                  text: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? AppLocalizations.of(context)!.darkMode : AppLocalizations.of(context)!.lightMode,
                  onTap: () {},
                  secondaryWidget: Transform.scale(
                    scale: 0.8,
                    child: CupertinoSwitch(
                      trackColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.grey[200],
                      activeColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
                      value: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode,
                      onChanged: (boolVal) {
                        Provider.of<AppStateNotifier>(context, listen: false).updateTheme(boolVal);
                        // BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.settings));
                      },
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.version + " 0.1.2",
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      } else {
        return Loading();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
