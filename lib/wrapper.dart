import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/models/user.dart';
import 'package:form_it/screens/authenticate/authenticate.dart';
import 'package:form_it/screens/authenticate/login/login_screen.dart';
import 'package:form_it/screens/home/home.dart';
import 'package:provider/provider.dart';

import 'blocs/tab/tab_bloc.dart';
import 'models/app_tab.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    //home or auth
    if(user == null){
      return LoginScreen();
    }else{
      return BlocProvider<TabBloc>(
        create: (context) => TabBloc(AppTab.people),
        child: HomeScreen(),
      );
    }
  }
}
