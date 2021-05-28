import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/view/tournament_info.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_matches.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:form_it/widgets/rounded_button.dart';
import 'package:repositories/repositories.dart';

typedef void OnAddMatchesCallback(List<Match> newMatchesSchedule);

class TournamentMatches extends StatefulWidget {
  final Tournament? tournament;
  final List<Team> teams;
  final List<Match> matches;
  final GlobalKey<TournamentInfoState> formKeyInfo;
  final OnAddMatchesCallback onAddMatchesCallback;

  const TournamentMatches({
    Key? key,
    this.tournament,
    required this.teams,
    required this.matches,
    required this.formKeyInfo,
    required this.onAddMatchesCallback,
  }) : super(key: key);

  @override
  _TournamentMatchesState createState() => _TournamentMatchesState();
}

class _TournamentMatchesState extends State<TournamentMatches> with AutomaticKeepAliveClientMixin {
  // late List<Match> matches;

  @override
  void initState() {
    super.initState();
    // if (widget.tournament == null) {
    //   matches = [];
    // } else {
    //   matches = widget.tournament!.matches;
    // }
  }

  List<List<Match>> _getRounds() {
    List<List<Match>> rounds = [];
    bool isAddedMatch = false;
    for (Match m in widget.matches) {
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

  void rotateRoundRobin(List<Team?> teams) {
    Team? last = teams.removeAt(teams.length - 1);
    teams.insert(1, last);
  }

  void createSchedule() {
    int encountersNum = 1;
    if (widget.formKeyInfo.currentState != null) {
      encountersNum = widget.formKeyInfo.currentState!.encountersNum;
    } else if (widget.tournament != null) {
      encountersNum = widget.tournament!.encountersNum;
    }
    // print(encountersNum);
    if (widget.teams.length < 2) {
      //todo
      print("can not, less then tow teams");
    } else {
      List<Match> matches = [];
      widget.teams.shuffle();
      List<Team?> teamsRoundRobin = []..addAll(widget.teams);
      if (widget.teams.length % 2 != 0) {
        teamsRoundRobin.insert(0, null);
      }
      for (int i = 1; i < teamsRoundRobin.length; i++) {
        // print(teamsRoundRobin.map((e) => e != null ? e.name : null));
        for (int j = 0; j < (teamsRoundRobin.length / 2); j++) {
          if (teamsRoundRobin[j] != null && teamsRoundRobin[teamsRoundRobin.length - 1 - j] != null) {
            matches.add(Match(
                firstTeam: teamsRoundRobin[j]!.name,
                secondTeam: teamsRoundRobin[teamsRoundRobin.length - 1 - j]!.name,
                round: i));
          }
        }
        rotateRoundRobin(teamsRoundRobin);
      }

      this.widget.onAddMatchesCallback(matches);
      // print(matches.map((e) => "Round " + (e.round.toString()) + " " + (e.firstTeam ?? "null") + " vs " + (e.secondTeam ?? "null")));
    }
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
          child: widget.matches.isEmpty
              ? Container(
                  padding: const EdgeInsets.only(top: 110),
                  alignment: Alignment.center,
                  child: RoundedButton(
                    text: AppLocalizations.of(context)!.createSchedule,
                    textColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
                    color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).accentColor,
                    sizeRatio: 0.9,
                    onPressed: createSchedule,
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: rounds.length,
                  itemBuilder: (context, indexRound) {
                    return EmbossContainer(
                      color: Colors.transparent,
                      name: AppLocalizations.of(context)!.round(rounds[indexRound][0].round ?? 0),
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: indexRound == 0 ? 90 : 25, bottom: indexRound == rounds.length - 1 ? 60 : 0),
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
        if (widget.matches.isNotEmpty)
          Positioned.fill(
            bottom: 40,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 110),
                  alignment: Alignment.bottomCenter,
                  child: RoundedButton(
                    text: AppLocalizations.of(context)!.deleteSchedule,
                    textColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : LightPink,
                    color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : DarkColorAccent,
                    sizeRatio: 0.9,
                    onPressed: () => widget.onAddMatchesCallback([]),
                  ),
                )),
          ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
