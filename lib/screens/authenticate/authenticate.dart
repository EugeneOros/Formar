import 'package:flutter/material.dart';
import 'package:form_it/screens/authenticate/sign_in.dart';
import 'package:form_it/screens/authenticate/sign_up.dart';
import 'package:form_it/screens/authenticate/signup/signup_screeen.dart';
import 'package:form_it/services/auth.dart';

import 'login/login_screen.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }
  @override
  Widget build(BuildContext context) {
   if(showSignIn){
     return LoginScreen();
   }else{
     return SignUpScreen(); //toggleView: toggleView
   }
  }
}
