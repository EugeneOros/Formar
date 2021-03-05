import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/logic/blocs/settings/bloc.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/widgets/item_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter/material.dart';
import 'package:people_repository/people_repository.dart';

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
            text: "Quantity of players in team",
            secondaryWidget: state is SettingsLoaded ? NumberPicker.horizontal(
                haptics: true,
                selectedTextStyle: TextStyle(fontSize: 17),
                textStyle: TextStyle(fontSize: 10, color: SecondaryColor),
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
                      color: SecondaryBlueColor,
                    ),
                    right: BorderSide(
                      width: 1.5,
                      style: BorderStyle.solid,
                      color: SecondaryBlueColor,
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
            color: SecondaryBlueColor,
          ),
          ItemSettings(
            icon: Icons.logout,
            text: "Sign Out",
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Are you sure you want to logout?",
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.w500),
                      ),
                      actions: [
                        FlatButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.black),
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
                            style: TextStyle(color: Colors.black),
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
            "Version 1.0",
            style: TextStyle(fontSize: 12, color: Colors.grey),
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
