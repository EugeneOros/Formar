import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/tab/tab_bloc.dart';
import 'package:form_it/logic/models/app_tab.dart';

import 'package:form_it/pages/players/view/players_page.dart';
import 'package:form_it/pages/teams/view/teams_page.dart';
import 'package:form_it/pages/tournament/view/tournament_page.dart';
import 'package:form_it/pages/settings/view/settings_page.dart';

import 'package:form_it/pages/home/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final String email;

  HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageOptions = [PlayersPage(), TeamsPage(), TournamentPage(), SettingsPage()];
    return BlocBuilder<TabBloc, AppTab>(builder: (context, activeTab) {
      return Scaffold(
        backgroundColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
        key: homeKey,
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
