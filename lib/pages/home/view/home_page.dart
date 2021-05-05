import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/tab/bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';

import 'package:form_it/pages/players/view/players_page.dart';
import 'package:form_it/pages/teams/view/teams_page.dart';
import 'package:form_it/pages/tournament/view/tournament_page.dart';
import 'package:form_it/pages/settings/view/settings_page.dart';

import 'package:form_it/pages/home/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:repositories/repositories.dart';

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
        body: BlocBuilder<PeopleBloc, PeopleState>(builder: (context, state) {
          List<Player> players = [];
          if (state is PeopleLoaded) {
            players = state.people;
          }
          return Provider<List<Player>>.value(
            value: players,
            child: _pageOptions[AppTab.values.indexOf(activeTab)],
          );
          // _pageOptions[AppTab.values.indexOf(activeTab)];
        }),
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
