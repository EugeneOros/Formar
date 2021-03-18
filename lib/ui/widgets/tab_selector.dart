import 'package:flutter/material.dart';
import 'package:form_it/logic/models/app_tab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_it/ui/shared/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
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

    SvgPicture _getTabIcon(AppTab tab, bool isActive) {
      switch (tab) {
        case AppTab.people:
          return  SvgPicture.asset(isActive ? "assets/people_fill.svg" : "assets/people_empty.svg");
          break;
        case AppTab.teams:
          return SvgPicture.asset(isActive ? "assets/team_fill.svg" : "assets/team_empty.svg");
          break;
        case AppTab.tournament:
          return SvgPicture.asset(isActive ? "assets/tournament_fill.svg" : "assets/tournament_empty.svg");
          break;
        case AppTab.settings:
          return SvgPicture.asset(isActive ? "assets/settings_fill.svg" : "assets/settings_empty.svg");
          break;
        default:
          return null;
      }
    }

    String _getPageLabels(AppTab tab) {
      switch (tab) {
        case AppTab.people:
          return AppLocalizations.of(context).people;
        case AppTab.teams:
          return AppLocalizations.of(context).teams;
        case AppTab.tournament:
          return AppLocalizations.of(context).tournament;
        case AppTab.settings:
          return AppLocalizations.of(context).settings;
        default:
          return "";
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
              width: 27,
              height: 27,
              child: _getTabIcon(tab, tab == activeTab)
            ),
            label: _getPageLabels(tab),
          );
        }).toList(),
      ),
    );
  }
}
