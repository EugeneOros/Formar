import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'item_tab_bar.dart';

class TabBarTournament extends StatelessWidget {
  final TabController controller;

  const TabBarTournament({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 10,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(2, 2),
            )
          ], borderRadius: BorderRadius.all(Radius.circular(13)), color: Colors.white),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 50,
          child: TabBar(
            indicatorPadding: EdgeInsets.all(4),
            unselectedLabelColor: Theme.of(context).dividerColor,
            labelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              color: Theme.of(context).accentColor.withOpacity(0.4),
            ),
            labelPadding: EdgeInsets.all(0),
            controller: controller,
            tabs: [
              ItemAppBar(
                icon: FontAwesomeIcons.info,
                text: "Info",
                drawDivider: true,
              ),
              ItemAppBar(
                icon: FontAwesomeIcons.users,
                text: "Teams",
                drawDivider: true,
              ),
              ItemAppBar(
                icon: FontAwesomeIcons.compressAlt,
                text: "Matches",
                drawDivider: true,
              ),
              ItemAppBar(
                icon: FontAwesomeIcons.chartBar,
                text: "Statistics",
                drawDivider: false,
              ), // Tab(icon: FaIcon(FontAwesomeIcons.users)),
              // Tab(icon: FaIcon(FontAwesomeIcons.chartBar)),
            ],
          ),
        ),
      ),
    );
  }
}
