import 'package:form_it/config/constants.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/view/tournament_info.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_matches.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/rounded_button.dart';
import 'package:repositories/repositories.dart';

typedef void OnChangeMatchesCallback(List<Match> newMatchesSchedule);

class TournamentMatches extends StatefulWidget {
  final Tournament? tournament;
  final List<Team> teams;
  final List<Match> matches;
  final GlobalKey<TournamentInfoState> formKeyInfo;
  final OnChangeMatchesCallback onChangeMatchesCallback;

  const TournamentMatches({
    Key? key,
    this.tournament,
    required this.teams,
    required this.matches,
    required this.formKeyInfo,
    required this.onChangeMatchesCallback,
  }) : super(key: key);

  @override
  _TournamentMatchesState createState() => _TournamentMatchesState();
}

class _TournamentMatchesState extends State<TournamentMatches> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
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
    if (widget.teams.length < 2) {
      showDialog(
        context: homeKey.currentContext!,
        builder: (BuildContext context) {
          return AppDialog(
            title: AppLocalizations.of(context)!.firstlyAddMoreTeams,
            actionsVertical: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).okButtonLabel,
                    style: Theme.of(context).textTheme.button,
                  ))
            ],
          );
        },
      );
    } else {
      List<Match> matches = [];
      widget.teams.shuffle();
      List<Team?> teamsRoundRobin = []..addAll(widget.teams);
      if (widget.teams.length % 2 != 0) {
        teamsRoundRobin.insert(0, null);
      }
      for (int i = 1; i <= (teamsRoundRobin.length - 1) * encountersNum; i++) {
        for (int j = 0; j < (teamsRoundRobin.length / 2); j++) {
          if (teamsRoundRobin[j] != null && teamsRoundRobin[teamsRoundRobin.length - 1 - j] != null) {
            matches.add(
              Match(
                  firstTeam: teamsRoundRobin[j]!.name, secondTeam: teamsRoundRobin[teamsRoundRobin.length - 1 - j]!.name, sets: [Score()], round: i),
            );
          }
        }
        rotateRoundRobin(teamsRoundRobin);
      }
      // matches.sort((a, b) => a.round!.compareTo(b.round!));
      this.widget.onChangeMatchesCallback(matches);
      // print(matches.map((e) => "Round " + (e.round.toString()) + " " + (e.firstTeam ?? "null") + " vs " + (e.secondTeam ?? "null")));
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.matches.sort((a, b) => a.round!.compareTo(b.round!));

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
                      onOkSetCallback: (Match match){
                        setState(() {
                          rounds[indexRound][index] = match;
                        });
                      },
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
        widget.matches.isNotEmpty
            ? Positioned.fill(
                bottom: 40,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 110),
                      alignment: Alignment.bottomCenter,
                      child: RoundedButton(
                          text: AppLocalizations.of(context)!.deleteSchedule,
                          textColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.white,
                          color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.black,
                          sizeRatio: 0.6,
                          onPressed: () => showDialog<bool>(
                              context: homeKey.currentContext!,
                              builder: (context) {
                                return AppDialog(
                                  title: AppLocalizations.of(context)!.areYouSureDeleteMatches,
                                  actionsHorizontal: [
                                    TextButton(
                                      onPressed: () {
                                        widget.onChangeMatchesCallback([]);
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.yes,
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text(
                                        AppLocalizations.of(context)!.no,
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                  ],
                                );
                              }) // widget.onChangeMatchesCallback([]),
                          ),
                    )),
              )
            : Positioned.fill(
                bottom: 40,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(top: 110),
                      alignment: Alignment.bottomCenter,
                      child: RoundedButton(
                        text: AppLocalizations.of(context)!.createSchedule,
                        textColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
                        color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).accentColor,
                        sizeRatio: 0.6,
                        onPressed: createSchedule,
                      ),
                    )),
              ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
