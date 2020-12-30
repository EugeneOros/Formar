import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/tab/tab_event.dart';
import 'package:form_it/logic/models/app_tab.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.people);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }

}