import 'package:flutter/material.dart';
import 'file:///C:/Users/yevhe/AndroidStudioProjects/form_it/lib/logic/services/auth.dart';

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