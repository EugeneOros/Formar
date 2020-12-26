import 'package:flutter/material.dart';
import 'package:form_it/models/user.dart';
import 'package:form_it/screens/authenticate/authenticate.dart';
import 'package:form_it/screens/authenticate/login/login_screen.dart';
import 'package:form_it/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    //home or auth
    if(user == null){
      return LoginScreen();
    }else{
      return Home();
    }
  }
}
