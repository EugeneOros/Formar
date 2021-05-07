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
          decoration: BoxDecoration(boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.3),
            //   spreadRadius: 5,
            //   blurRadius: 7,
            //   offset: Offset(2, 2),
            // )
          ], borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.white),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 50,
          child: Neumorphic(
            style: NeumorphicStyle(
                depth: -3,
                intensity: 0.8,
                shape: NeumorphicShape.concave,
                // intensity: 1,
                surfaceIntensity: 1,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                // depth: -15,
                lightSource: LightSource.topLeft,
                color: Theme.of(context).primaryColorLight.withOpacity(0.4)),
            child: TabBar(
              indicatorPadding: EdgeInsets.all(4),
              unselectedLabelColor: Theme.of(context).dividerColor,
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
    );
  }
}
