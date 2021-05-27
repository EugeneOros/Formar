import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_matches.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:repositories/repositories.dart';

class TournamentMatches extends StatefulWidget {
  final Tournament? tournament;

  const TournamentMatches({Key? key, this.tournament}) : super(key: key);

  @override
  _TournamentMatchesState createState() => _TournamentMatchesState();
}

class _TournamentMatchesState extends State<TournamentMatches> with AutomaticKeepAliveClientMixin {
  late List<Match> matches;

  @override
  void initState() {
    super.initState();
    if (widget.tournament == null) {
      matches = [];
    } else {
      matches = widget.tournament!.matches;
    }
  }

  List<List<Match>> _getRounds() {
    List<List<Match>> rounds = [];
    bool isAddedMatch = false;
    for (Match m in matches) {
      for (List<Match> matchesInRounds in rounds) {
        if (matchesInRounds[0].round == m.round) {
          matchesInRounds.add(m);
          isAddedMatch = true;
        }
      }
      if (isAddedMatch == false) {
        rounds.add([m]);
      }
      isAddedMatch = false;
    }
    return rounds;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<List<Match>> rounds = _getRounds();
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
                name: AppLocalizations.of(context)!.round(rounds[indexRound][0].round ?? 0),
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: indexRound == 0 ? 90 : 25, bottom: indexRound == rounds.length - 1 ? 60 : 0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rounds[indexRound].length,
                  itemBuilder: (context, index) {
                    return ItemTournamentMatches(
                      color: index == 2
                          ? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight)
                          : (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white),
                      drawDivider: index == 0 ? false : true,
                      match: rounds[indexRound][index],
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

  @override
  bool get wantKeepAlive => true;
}
