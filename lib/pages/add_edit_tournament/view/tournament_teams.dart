import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_info.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_teams.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';

class TournamentTeams extends StatelessWidget {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 0,
        color: Theme.of(context).primaryColorLight,
        boxShape: NeumorphicBoxShape.rect(),
        shape: NeumorphicShape.convex,
        lightSource: LightSource.topRight,
      ),
      child: Stack(
        children: [
          Container(
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
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Theme.of(context).primaryColor.withOpacity(0.3),
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).accentColor.withOpacity(0),
                  // Colors.transparent
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Stack(
              children: [
                EmbossContainer(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 90, bottom: 60),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 10, top: 10),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          return ItemTournamentTeams(
                            text: teams[index],
                            drawDivider: index == 0 ? false : true,
                            secondaryWidget: RoundIconButton(
                              icon: Icons.remove,
                              onPressed: () {},
                            ),
                          );
                          // teams.removeAt(index);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  bottom: 30,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).accentColor,
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        // _onAddPlayer();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
