import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_matches.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';

class Matches extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> teams = [
      "Team 1",
      "Team2",
      "Team3",
      "Team4",
      "Team 1",
      "Team2",
    ];
    List<String> rounds = [
      "Round 1",
      "Round 2",
      "Round 3",
      "Round 4",
    ];

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 0,
        surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.25,
        color: Theme.of(context).primaryColorLight,
        boxShape: NeumorphicBoxShape.rect(),
        shape: NeumorphicShape.convex,
        lightSource: LightSource.topLeft,
      ),
      child: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
                Theme.of(context).primaryColor.withOpacity(0.3),
                Theme.of(context).primaryColor.withOpacity(0),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: rounds.length,
            itemBuilder: (context, indexRound) {
              return EmbossContainer(
                color: Colors.transparent,
                name: rounds[indexRound],
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: indexRound == 0 ? 90 : 25, bottom: indexRound == rounds.length - 1 ? 60 : 0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return ItemTournamentMatches(
                      color: index == 2
                          ? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight)
                          : (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white),
                      drawDivider: index == 0 ? false : true,
                      team1: teams[index],
                      team2: teams[(index + 5) % teams.length],
                    );
                    // teams.removeAt(index);
                  },
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
