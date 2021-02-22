import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/bloc.dart';
import 'package:form_it/ui/widgets/item_settings.dart';

class SettingsPage extends StatelessWidget {
  // final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ItemSettings(
          icon: Icons.logout,
          text: "Sign Out",
          onTap: () => BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
        ),
        Text("Version 1.0", style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center,)
        // GestureDetector(
        //   onTap: () =>
        //       BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut()),
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        //     child: Row(
        //       children: [
        //         Icon(
        //           Icons.logout,
        //         ),
        //         SizedBox(width: 10),
        //         Text("Sign Out"),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// RaisedButton(
//   child: Text('Sign Out'),
//   onPressed: () async {
//     BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
//   },
// ),
