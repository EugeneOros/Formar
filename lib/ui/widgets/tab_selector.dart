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

  @override
  Widget build(BuildContext context) {
    var pageLabels = [
      AppLocalizations.of(context).people,
      AppLocalizations.of(context).teams,
      AppLocalizations.of(context).tournament,
      AppLocalizations.of(context).settings,
    ];

    return BottomNavigationBar(
      selectedItemColor: PrimaryAssentColor,
      unselectedItemColor: PrimaryColor,
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
          label: pageLabels[AppTab.values.indexOf(tab)],
        );
      }).toList(),
    );
  }
}
