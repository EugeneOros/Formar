import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';

// class AddEditTournamentPage extends StatelessWidget {
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // Define a controller for TabBar and TabBarViews
//       home: DefaultTabController(
//         length: 5,
//         child: Scaffold(
//           // Use ShiftingTabBar instead of appBar
//           appBar: ShiftingTabBar(
//             // Specify a color to background or it will pick it from primaryColor of your app ThemeData
//             color: Colors.grey,
//             // You can change brightness manually to change text color style to dark and light or
//             // it will decide based on your background color
//             // brightness: Brightness.dark,
//             tabs: <ShiftingTab>[
//               // Also you should use ShiftingTab widget instead of Tab widget to get shifting animation
//               ShiftingTab(
//                 icon: const Icon(Icons.home),
//                 text: 'Test 1',
//               ),
//               ShiftingTab(
//                 icon: const Icon(Icons.directions_bike),
//                 text: 'Test 2',
//               ),
//               ShiftingTab(
//                 icon: const Icon(Icons.directions_car),
//                 text: 'Test 3',
//               ),
//               ShiftingTab(
//                 icon: const Icon(Icons.directions_transit),
//                 text: 'Test 4',
//               ),
//               ShiftingTab(
//                 icon: const Icon(Icons.directions_boat),
//                 text: 'Test 5',
//               ),
//             ],
//           ),
//           // Other parts of the app are exacly same as default TabBar widget
//           body: const TabBarView(
//             children: <Widget>[
//               Icon(Icons.home),
//               Icon(Icons.directions_bike),
//               Icon(Icons.directions_car),
//               Icon(Icons.directions_transit),
//               Icon(Icons.directions_boat),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AddEditTournamentPage extends StatefulWidget {
  @override
  _AddEditTournamentPageState createState() => _AddEditTournamentPageState();
}

class _AddEditTournamentPageState extends State<AddEditTournamentPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late TabController _tabController;

  //
  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        // toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Theme.of(context).accentColor,
        leading: IconButtonAppBar(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // if (_formKey.currentState!.validate()) {
              //   _formKey.currentState!.save();
              //   widget.onSave(_name, _players);
              //   Navigator.pop(context);
              // }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Text(
                MaterialLocalizations.of(context).saveButtonLabel.toLowerCase().capitalize(),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size(50, 50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Colors.white,
                // tab button ripple color when pressed
                hoverColor: Colors.white,
                // tab button hover color
                haptic: true,
                // haptic feedback
                tabBorderRadius: 30,
                tabActiveBorder: Border.all(color: Colors.transparent, width: 1),
                // tab button border
                tabBorder: Border.all(color: Colors.transparent, width: 1),
                // tab button border
                tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0), blurRadius: 8)],
                // tab button shadow
                curve: Curves.easeInOut,
                // tab animation curves
                duration: Duration(milliseconds: 800),
                // tab animation duration
                gap: 8,
                // the tab button gap between icon and text
                color: color,
                // unselected icon color
                activeColor: Color(0xffffc2f1),
                // selected icon and text color
                iconSize: 20,
                // tab button icon size
                tabBackgroundColor: Colors.white,
                // selected tab background color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _tabController.animateTo(index);
                    // DefaultTabController.of(context)!.animateTo(2);
                    _selectedIndex = index;
                  });
                },
                tabs: [
                  GButton(
                    icon: Icons.info,
                    text: 'Info',
                  ),
                  GButton(
                    icon: Icons.people,
                    text: 'Teams',
                  ),
                  GButton(
                    icon: Icons.event,
                    text: 'Matches',
                  ),
                  GButton(
                    icon: Icons.stacked_bar_chart,
                    text: 'Statistic',
                  )
                ]),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor,
                ],
              ),
            ),
            child: Text("hi")),
        Icon(Icons.movie),
        Icon(Icons.games),
        Icon(Icons.movie),
      ]),
    );
  }
}

class TabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}