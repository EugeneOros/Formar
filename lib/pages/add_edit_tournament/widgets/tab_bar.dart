import 'package:form_it/config/dependency.dart';
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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          height: 50,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.3,
              shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
              shadowLightColor:
                  Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
              color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).colorScheme.secondary,
              intensity: 0.8,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
            ),
            child: TabBar(
              controller: controller,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(0),
              indicatorPadding: EdgeInsets.all(4),
              unselectedLabelColor: LightBlue,
              labelColor: LightPink,
              labelPadding: EdgeInsets.all(0),
              labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10, fontWeight: FontWeight.w300),
              unselectedLabelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10, fontWeight: FontWeight.w300),
              indicator: NeumorphicDecoration(
                shape: NeumorphicBoxShape.roundRect(BorderRadius.circular(50)),
                isForeground: false,
                renderingByPath: false,
                splitBackgroundForeground: false,
                style: NeumorphicStyle(
                  depth: 1,
                  intensity: 1,
                  surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.2,
                  color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Colors.white,
                  shape: NeumorphicShape.concave,
                  shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey[400],
                  shadowLightColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                      ? DarkColorShadowLight
                      : Theme.of(context).colorScheme.secondary,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                  lightSource: LightSource.topLeft,
                ),
              ),
              tabs: [
                ItemAppBar(
                  icon: FontAwesomeIcons.info,
                  text: AppLocalizations.of(context)!.info,
                ),
                  ItemAppBar(
                    icon: FontAwesomeIcons.users,
                    text: AppLocalizations.of(context)!.teams,
                  ),
                  ItemAppBar(
                    icon: FontAwesomeIcons.compressAlt,
                    text: AppLocalizations.of(context)!.matches,
                  ),
                  ItemAppBar(
                    icon: FontAwesomeIcons.chartBar,
                    text: AppLocalizations.of(context)!.statistic,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
