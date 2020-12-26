import 'package:flutter/material.dart';
import 'package:form_it/services/auth.dart';

class SettingsPage extends StatelessWidget{
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: RaisedButton(
        child: Text('Sign Out'),
        onPressed: () async {
          dynamic result = await _authService.signOut();
        },
      ),
    );
  }

}