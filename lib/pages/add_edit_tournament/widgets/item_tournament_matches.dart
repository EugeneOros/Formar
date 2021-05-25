import 'package:flutter/material.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';

class ItemTournamentMatches extends StatelessWidget {
  final String team1;
  final String team2;
  final bool drawDivider;
  final Color? color;

  const ItemTournamentMatches({Key? key, required this.team1, required this.team2, this.drawDivider = false, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(border: drawDivider ?  Border(top: getBorderDivider(context)) : null, color: color ?? Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              team1,
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Spacer(),
          NeumorphicButton(
            onPressed: () {},
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.4,
              color: Theme.of(context).primaryColorLight,
              shape: NeumorphicShape.concave,
              shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
              shadowLightColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
            child: Text(
              "1 : 0",// "unknown",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Spacer(),
          Expanded(
            child: Text(
              team2,
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
          // if (secondaryWidget != null) secondaryWidget!,
        ],
      ),
    );
  }
}