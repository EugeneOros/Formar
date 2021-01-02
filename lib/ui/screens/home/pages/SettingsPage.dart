import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';

class SettingsPage extends StatelessWidget{
  // final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: RaisedButton(
        child: Text('Sign Out'),
        onPressed: () async {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          // dynamic result = await _authService.signOut();
        },
      ),
    );
  }

}