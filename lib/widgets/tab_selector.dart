import 'package:flutter/material.dart';
import 'package:form_it/models/app_tab.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  SvgPicture _getActiveTabIcon(AppTab tab) {
    switch (tab) {
      case AppTab.people:
        return SvgPicture.asset("assets/list_fill.svg");
        break;
      case AppTab.teams:
        return SvgPicture.asset("assets/team_fill.svg");
        break;
      case AppTab.tournament:
        return SvgPicture.asset("assets/cup_fill.svg");
        break;
      case AppTab.settings:
        return SvgPicture.asset("assets/settings_fill.svg");
        break;
      default:
        return null;
    }
  }

  SvgPicture _getPassiveTabIcon(AppTab tab) {
    switch (tab) {
      case AppTab.people:
        return SvgPicture.asset("assets/list_empty.svg");
        break;
      case AppTab.teams:
        return SvgPicture.asset("assets/team_empty.svg");
        break;
      case AppTab.tournament:
        return SvgPicture.asset("assets/cup_empty.svg");
        break;
      case AppTab.settings:
        return SvgPicture.asset("assets/settings_empty.svg");
        break;
      default:
        return null;
    }
  }

  Text _getTabLabel(AppTab tab) {
    switch (tab) {
      case AppTab.people:
        return Text("People");
        break;
      case AppTab.teams:
        return Text("Teams");
        break;
      case AppTab.tournament:
        return Text("Tournament");
        break;
      case AppTab.settings:
        return Text("Settings");
        break;
      default:
        return Text("Label");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: tab == activeTab
              ? Container(
                  width: 30,
                  height: 30,
                  child: _getActiveTabIcon(tab),
                )
              : Container(
                  width: 30,
                  height: 30,
                  child: _getPassiveTabIcon(tab),
                ),
          title: _getTabLabel(tab),
        );
      }).toList(),
    );
  }
}
