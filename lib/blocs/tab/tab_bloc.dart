import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:form_it/blocs/tab/tab_event.dart';
import 'package:form_it/models/app_tab.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc(AppTab initialState) : super(initialState);

  @override
  AppTab get initialState => AppTab.people;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }

}