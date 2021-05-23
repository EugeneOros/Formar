import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/players/widgets/player_indicator.dart';
import 'package:form_it/widgets/power.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/widgets/fade_end_listview.dart';

class ItemTeam extends StatelessWidget {
  final GestureTapCallback onEdit;
  final Function onDelete;
  final Team team;

  const ItemTeam({Key? key, required this.onEdit, required this.team, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
          constraints: BoxConstraints(minWidth: 50, maxWidth: 400),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          child: Hero(
            tag: "TeamItem" + team.id!,
            child: Material(
              type: MaterialType.transparency,
              child: Neumorphic(
                style: NeumorphicStyle(
                    depth: 7,
                    intensity: 0.9,
                    surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.3,
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    lightSource: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightSource.topRight : LightSource.topRight,
                    shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                    shadowLightColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                    color: Theme.of(context).canvasColor),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                          top: 13,
                          left: 13,
                          child: Power(power: team.power),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () => onDelete(),
                            icon: Icon(
                              Icons.delete,
                              size: 17,
                              color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 35, bottom: 0, right: 20, left: 20),
                          alignment: Alignment.center,
                          child: Text(
                            team.name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 0),
                        child: Stack(
                          children: [
                            ListView.builder(
                              itemCount: team.players.length,
                              itemBuilder: (context, index) {
                                final player = team.players[index];
                                return Padding(
                                  padding: EdgeInsets.only(top: index == 0 ? 15 : 7),
                                  child: Row(children: [
                                    PlayerIndicator(player: player),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        player.nickname,
                                        style: Theme.of(context).textTheme.bodyText2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                            FadeEndLIstView(
                              color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white,
                              height: 15,
                              width: MediaQuery.of(context).size.width,
                            ),
                            FadeEndLIstView(
                              color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white,
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              isTop: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
