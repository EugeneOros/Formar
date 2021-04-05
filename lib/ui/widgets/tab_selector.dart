import 'package:form_it/logic/models/app_tab.dart';
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
              child: tab.getIcon(tab == activeTab)
            ),
            label: tab.getName(context),
          );
        }).toList(),
      ),
    );
  }
}