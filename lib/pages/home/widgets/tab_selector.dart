import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/palette.dart';
import 'package:form_it/logic/models/app_tab.dart';

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
      if (activeTab == AppTab.settings || activeTab == AppTab.tournament) {
        return Theme.of(context).primaryColorLight;
      } else {
        return Theme.of(context).primaryColor;
      }
    }

    BoxDecoration? _getDecoration(AppTab activeTab) {
      switch (activeTab) {
        case (AppTab.settings):
          return null;
        case AppTab.players:
          return BoxDecoration(
            color: _getBackgroundColor(activeTab),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 5,
                blurRadius: 7,
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).primaryColor,
                Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).accentColor,
              ],
            ),
          );
        case AppTab.teams:
          return BoxDecoration(
            color: _getBackgroundColor(activeTab),
          );
        case AppTab.tournament:
          return BoxDecoration(
            color: _getBackgroundColor(activeTab),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 5,
                blurRadius: 7,
              )
            ],
          );
        case AppTab.settings:
          return BoxDecoration(
            color: _getBackgroundColor(activeTab),
          );
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      decoration: _getDecoration(activeTab),
      child: BottomNavigationBar(
        elevation: 0.0,
        iconSize: 20,
        backgroundColor: Colors.transparent,
        selectedItemColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? BottomNavBarDarkColor : BottomNavBarLightColor,
        unselectedItemColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? BottomNavBarDarkColor : BottomNavBarLightColor,
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
              child: tab.getIcon(tab == activeTab, context),
            ),
            tooltip: '',
            label: tab.getName(context),
          );
        }).toList(),
      ),
    );
  }
}
