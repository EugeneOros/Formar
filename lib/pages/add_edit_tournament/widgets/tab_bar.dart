import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';

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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: Theme.of(context).primaryColorLight,
          ),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 50,
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: 3,
                intensity: 0.8,
                shape: NeumorphicShape.concave,
                // intensity: 1,
                surfaceIntensity: 0,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                // depth: -15,
                lightSource: LightSource.topLeft,
                color: Theme.of(context).primaryColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                // gradient: LinearGradient(
                //   // begin: Alignment.centerLeft,
                //   begin: Alignment.topCenter,
                //   // end: Alignment.centerRight,
                //   end: Alignment.bottomCenter,
                //   colors: [
                //     // Theme.of(context).primaryColor,
                //     Theme.of(context).primaryColor,
                //     Theme.of(context).accentColor,
                //   ],
                // ),
              ),
              child: TabBar(
                indicatorPadding: EdgeInsets.all(4),
                unselectedLabelColor: Colors.black,//Theme.of(context).dividerColor,
                labelColor: Colors.black,
                indicator:
                    // NeumorphicDecoration(
                    //   shape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                    //   isForeground: false,
                    //   renderingByPath: false,
                    //   splitBackgroundForeground: true,
                    //   style: NeumorphicStyle(
                    //       depth: 3,
                    //       intensity: 1,
                    //       shape: NeumorphicShape.concave,
                    //       surfaceIntensity: 3,
                    //       boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                    //       lightSource: LightSource.topLeft,
                    //       shadowLightColor:  Colors.white,
                    //       shadowDarkColor: Colors.grey[100],
                    //       color: Colors.white
                    //   ),
                    // ),
                    BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.white,
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
        ),
      ),
    );
  }
}
