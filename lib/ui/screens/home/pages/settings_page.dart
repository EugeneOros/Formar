import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/ui/widgets/item_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  // final AuthService _authService = AuthService();
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIntValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      if (state is SettingsLoaded) {
        _currentIntValue = state.settings.counterTeamMembers;
      } else {
        _currentIntValue = 1;
      }

      return ListView(
        children: [
          ItemSettings(
            icon: Icons.people,
            text: AppLocalizations.of(context).playersInTeam,
            secondaryWidget: state is SettingsLoaded ? NumberPicker.horizontal(
                haptics: true,
                selectedTextStyle: Theme.of(context).textTheme.bodyText1,
                textStyle: Theme.of(context).textTheme.subtitle1,
                initialValue: state.settings.counterTeamMembers,
                minValue: 1,
                maxValue: 100,
                step: 1,
                itemExtent: 35,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                    ),
                    right: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                listViewHeight: 20,
                onChanged: (value) {
                  BlocProvider.of<SettingsBloc>(context).add(
                    UpdateSettings(state.settings.copyWith(counterTeamMember: value)),
                  );
                }) : Container(),
            onTap: () {},
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            height: 2.0,
            color: Theme.of(context).primaryColor,
          ),
          ItemSettings(
            icon: Icons.logout,
            text: AppLocalizations.of(context).signOut,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        AppLocalizations.of(context).areYouSureLogOut,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            AppLocalizations.of(context).ok,
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
                            AppLocalizations.of(context).cancel,
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
            AppLocalizations.of(context).version + " 1.0",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ],
      );
    });
  }
}

// RaisedButton(
//   child: Text('Sign Out'),
//   onPressed: () async {
//     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//   },
// ),
