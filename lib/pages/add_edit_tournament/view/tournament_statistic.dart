import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_statistic.dart';
import 'package:form_it/widgets/emboss_container.dart';

class TournamentStatistic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> teams = [
      "Team 1",
      "Team2",
      "Team3",
      "Team4",
      "Team 1",
      "Team2",
      "Team3",
      "Team4",
      "Team 1",
      "Team2",
      "Team3",
      "Team4",
      "Team 1",
      "Team2",
      "Team3",
      "Team4"
    ];
    return Neumorphic(
        style: NeumorphicStyle(
          depth: 0,
          surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.25,
          color: Theme.of(context).primaryColorLight,
          boxShape: NeumorphicBoxShape.rect(),
          shape: NeumorphicShape.convex,
          lightSource: LightSource.topRight,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: EmbossContainer(
              name: "Standings",
              padding: EdgeInsets.only(top: 90, bottom: 60),
              child: Row(
                children: [
                  Expanded(
                    flex: 50,
                    child: Container(
                      alignment: Alignment.topLeft,
                      // width: 100,
                      // padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 35,
                                // width: 35,
                                padding: EdgeInsets.only(left: 10),
                                child: Center(
                                    child: Text(
                                  "Name",
                                  style: Theme.of(context).textTheme.subtitle2,
                                )),
                              )
                            ],
                          ),
                          ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: teams.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    decoration: index != -1 ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null,
                                    // c
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Neumorphic(
                                          style: NeumorphicStyle(
                                            depth: -2,
                                            surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.4,
                                            color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode
                                                ? DarkColor
                                                : Theme.of(context).primaryColorLight,
                                            shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
                                            shadowLightColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
                                            shape: NeumorphicShape.flat,
                                            boxShape: NeumorphicBoxShape.circle(),
                                          ),
                                          // padding: EdgeInsets.all(8),
                                          child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Center(child: Text(index.toString())),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          // width: 35,
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            teams[index],
                                            style: Theme.of(context).textTheme.bodyText2,
                                          ),
                                        ),
                                      ],
                                    ));
                              }),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 50,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StatisticHeaderElement(
                                value: 'P',
                              ),
                              StatisticHeaderElement(
                                value: 'W',
                              ),
                              StatisticHeaderElement(
                                value: 'D',
                              ),
                              StatisticHeaderElement(
                                value: 'L',
                              ),
                              StatisticHeaderElement(
                                value: 'MP',
                              ),
                              StatisticHeaderElement(
                                value: 'PD',
                              ),
                              StatisticHeaderElement(
                                value: 'SD',
                              ),
                              StatisticHeaderElement(
                                value: 'E',
                              ),
                              StatisticHeaderElement(
                                value: 'P',
                              ),
                              StatisticHeaderElement(
                                value: 'P',
                              ),
                              StatisticHeaderElement(
                                value: 'P',
                              ),
                            ],
                          ),
                          Column(
                            children: teams.map((e) {
                              return ItemTournamentStatistic(
                                text: 'jjd',
                                drawDivider: true,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class StatisticHeaderElement extends StatelessWidget {
  final String value;

  const StatisticHeaderElement({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: 40,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Text(
        value,
        style: Theme.of(context).textTheme.subtitle2,
      )),
    );
  }
}
