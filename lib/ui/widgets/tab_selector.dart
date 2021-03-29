import 'package:form_it/logic/models/app_tab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:form_it/ui/shared/dependency.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Color _getBackgroundColor(AppTab activeTab) {
      if (activeTab == AppTab.settings) {
        return Colors.transparent;
      } else {
        return Theme.of(context).primaryColor;
      }
    }

    SvgPicture? _getTabIcon(AppTab tab, bool isActive) {
      switch (tab) {
        case AppTab.players:
          return  SvgPicture.asset(isActive ? "assets/players_fill.svg" : "assets/players_empty.svg");
        case AppTab.teams:
          return SvgPicture.asset(isActive ? "assets/team_fill.svg" : "assets/team_empty.svg");
        case AppTab.tournament:
          return SvgPicture.asset(isActive ? "assets/tournament_fill.svg" : "assets/tournament_empty.svg");
        case AppTab.settings:
          return SvgPicture.asset(isActive ? "assets/settings_fill.svg" : "assets/settings_empty.svg");
      }
    }

    String _getPageLabels(AppTab tab) {
      switch (tab) {
        case AppTab.players:
          return AppLocalizations.of(context)!.players;
        case AppTab.teams:
          return AppLocalizations.of(context)!.teams;
        case AppTab.tournament:
          return AppLocalizations.of(context)!.tournament;
        case AppTab.settings:
          return AppLocalizations.of(context)!.settings;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      decoration: BoxDecoration(color: _getBackgroundColor(activeTab)),
      child: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        selectedItemColor: BottomNavigationBarItemColor,
        unselectedItemColor: BottomNavigationBarItemColor,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => onTabSelected(AppTab.values[index]),
        selectedLabelStyle: Theme.of(context).textTheme.subtitle2,
        unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
        currentIndex: AppTab.values.indexOf(activeTab),
        items: AppTab.values.map((tab) {
          return BottomNavigationBarItem(
            icon: Container(
              width: 22,
              height: 22,
              child: _getTabIcon(tab, tab == activeTab)
            ),
            label: _getPageLabels(tab),
          );
        }).toList(),
      ),
    );
  }
}
