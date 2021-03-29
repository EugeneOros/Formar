import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/ui/widgets/app_dialog.dart';
import 'package:form_it/ui/widgets/item_settings.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:form_it/ui/widgets/number_picker.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? _currentPlayerCountValue = 1;

  void handleNumChange(int value) {
    _currentPlayerCountValue = value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoaded) {
        _currentPlayerCountValue = state.settings!.counterTeamMembers;
        return ListView(
          children: [
            ItemSettings(
              icon: Icons.people,
              text: AppLocalizations.of(context)!.playersInTeam,
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
                          FlatButton(
                            child: Text(
                              AppLocalizations.of(context)!.apply,
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (state is SettingsLoaded) {
                                print(_currentPlayerCountValue);
                                BlocProvider.of<SettingsBloc>(context).add(
                                  UpdateSettings(state.settings!.copyWith(
                                      counterTeamMember:
                                          _currentPlayerCountValue)),
                                );
                              }
                            },
                          ),
                          FlatButton(
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
                    }).then((value) {
                  _currentPlayerCountValue = state.settings!.counterTeamMembers;
                });
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 2.0,
              color: Theme.of(context).primaryColor,
            ),
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
                          FlatButton(
                            child: Text(
                              AppLocalizations.of(context)!.yes,
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(LoggedOut());
                            },
                          ),
                          FlatButton(
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
            Text(
              AppLocalizations.of(context)!.version + " 1.0",
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        return Loading();
      }
    });
  }
}
