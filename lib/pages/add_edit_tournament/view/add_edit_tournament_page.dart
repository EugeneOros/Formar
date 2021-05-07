import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tab_bar.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/tab_bar.dart';
import 'package:form_it/widgets/fade_end_listview.dart';
import 'package:form_it/widgets/icon_button_app_bar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        toolbarHeight: 50,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
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
        // bottom: PreferredSize(
        //   preferredSize: Size(100,100),
        //   child: Container(
        //     padding: EdgeInsets.all(100),
        //     child: TabBar(
        //       controller: _tabController,
        //       tabs: [
        //         Tab(icon: Icon(Icons.directions_car)),
        //         Tab(icon: Icon(Icons.directions_transit)),
        //         Tab(icon: Icon(Icons.directions_bike)),
        //         Tab(icon: Icon(Icons.directions_bike)),
        //       ],
        //     ),
        //   ),
        // ),
        // bottom: PreferredSize(
        //   preferredSize: Size(50, 50),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        //     child: GNav(
        //         rippleColor: Colors.white,
        //         // tab button ripple color when pressed
        //         hoverColor: Colors.white,
        //         // tab button hover color
        //         haptic: true,
        //         // haptic feedback
        //         tabBorderRadius: 30,
        //         tabActiveBorder: Border.all(color: Colors.transparent, width: 1),
        //         // tab button border
        //         tabBorder: Border.all(color: Colors.transparent, width: 1),
        //         // tab button border
        //         tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0), blurRadius: 8)],
        //         // tab button shadow
        //         curve: Curves.easeInOut,
        //         // tab animation curves
        //         duration: Duration(milliseconds: 800),
        //         // tab animation duration
        //         gap: 8,
        //         // the tab button gap between icon and text
        //         color: color,
        //         // unselected icon color
        //         activeColor: Color(0xffffc2f1),
        //         // selected icon and text color
        //         iconSize: 20,
        //         // tab button icon size
        //         tabBackgroundColor: Colors.white,
        //         // selected tab background color
        //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //         selectedIndex: _selectedIndex,
        //         onTabChange: (index) {
        //           setState(() {
        //             _tabController.animateTo(index);
        //             // DefaultTabController.of(context)!.animateTo(2);
        //             _selectedIndex = index;
        //           });
        //         },
        //         tabs: [
        //           GButton(
        //             icon: Icons.info,
        //             text: 'Info',
        //           ),
        //           GButton(
        //             icon: Icons.people,
        //             text: 'Teams',
        //           ),
        //           GButton(
        //             icon: Icons.event,
        //             text: 'Matches',
        //           ),
        //           GButton(
        //             icon: Icons.stacked_bar_chart,
        //             text: 'Statistic',
        //           )
        //         ]),
        //   ),
        // ),
      ),
      body: Stack(
        children: [
          TabBarView(controller: _tabController, children: [
            Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
                child: Text("hi")),
            Icon(Icons.movie),
            Icon(Icons.games),
            Icon(Icons.movie),
          ]),
          FadeEndLIstView(
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            isTop: true,
          ),
          FadeEndLIstView(
            height: 30,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            isTop: false,
          ),
          TabBarTournament(controller: _tabController,)
        ],
      ),
    );
  }
}

// class TabBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
