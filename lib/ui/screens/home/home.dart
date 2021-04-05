import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:form_it/ui/widgets/app_bar.dart';
import 'package:form_it/ui/widgets/tab_selector.dart';

import 'pages/players_page.dart';
import 'pages/teams_page.dart';
import 'pages/tournament_page.dart';
import 'pages/settings_page.dart';

class HomeScreen extends StatelessWidget {
  final String email;

  HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [PlayersPage(), TeamsPage(), TournamentPage(), SettingsPage()];
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppTopBar(activeTab: activeTab),
        body: _pageOptions[AppTab.values.indexOf(activeTab)],
        bottomNavigationBar: TabSelector(
          activeTab: activeTab,
          onTabSelected: (tab) {
            BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
          },
        ),
      );
    });
  }
}




