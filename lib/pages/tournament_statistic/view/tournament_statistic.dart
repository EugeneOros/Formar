import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/helpers.dart';
import 'package:form_it/pages/tournament_info/view/tournament_info.dart';
import 'package:form_it/pages/tournament_statistic/widgets/widgets.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:repositories/repositories.dart';

class TournamentStatistic extends StatelessWidget {
  final Tournament? tournament;
  final List<Match> matches;
  final List<Team> teams;
  final GlobalKey<TournamentInfoState> formKeyInfo;

  const TournamentStatistic({Key? key, this.tournament, required this.matches, required this.formKeyInfo, required this.teams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double itemHeight = 35;
    bool hasDraws = formKeyInfo.currentState != null
        ? (formKeyInfo.currentState!.drawPoints != null)
        : (tournament != null ? (tournament!.drawPoints != null) : true);
    List<TeamStat> teamsStats;
    if (formKeyInfo.currentState != null) {
      teamsStats = Tournament.getLeaderList(
        matches: matches,
        teams: teams,
        pointsForWins: formKeyInfo.currentState!.winPoints,
        pointsForDraw: formKeyInfo.currentState!.drawPoints,
        pointsForLoss: formKeyInfo.currentState!.lossPoints,
      );
    } else {
      teamsStats = tournament == null
          ? []
          : Tournament.getLeaderList(
              matches: matches,
              teams: tournament!.teams,
              pointsForWins: this.tournament!.winPoints,
              pointsForDraw: this.tournament!.drawPoints,
              pointsForLoss: this.tournament!.lossPoints,
            );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColorLight,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: EmbossContainer(
          name: AppLocalizations.of(context)!.standings,
          titleChild: Padding(
            padding: const EdgeInsets.only(bottom: 5, right: 10, left: 10),
            child: RoundIconButton(
              iconColor: (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.grey),
              icon: FontAwesomeIcons.info,
              color: Theme.of(context).primaryColorLight,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AppDialog(
                      title: AppLocalizations.of(context)!.info,
                      content: Container(
                        padding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.p + " - " + AppLocalizations.of(context)!.points,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(AppLocalizations.of(context)!.w + " - " + AppLocalizations.of(context)!.wins),
                            if (hasDraws) Text(AppLocalizations.of(context)!.d + " - " + AppLocalizations.of(context)!.draws),
                            Text(AppLocalizations.of(context)!.l + " - " + AppLocalizations.of(context)!.losses),
                            Text(AppLocalizations.of(context)!.mp + " - " + AppLocalizations.of(context)!.matchesPlayed),
                            Text(AppLocalizations.of(context)!.pd + " - " + AppLocalizations.of(context)!.pointsDifference),
                            Text(AppLocalizations.of(context)!.sd + " - " + AppLocalizations.of(context)!.setsDifference),
                            Text(AppLocalizations.of(context)!.ep + " - " + AppLocalizations.of(context)!.extraPoints),
                          ],
                        ),
                      ),
                      actionsHorizontal: [
                        TextButton(
                          child: Text(
                            MaterialLocalizations.of(context).okButtonLabel,
                            style: Theme.of(context).textTheme.button,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          padding: EdgeInsets.only(top: 90, bottom: 60),
          child: Stack(children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: teamsStats.length + 1,
                itemBuilder: (context, index) {
                  return Container(
                      padding: EdgeInsets.all(10),
                      height: 35,
                      decoration: index != 0 ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null);
                }),
            Row(
              children: [
                Expanded(
                  flex: 50,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          AppLocalizations.of(context)!.team,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: teamsStats.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            // decoration: index != -1 ? BoxDecoration(border: Border(top: getBorderDivider(context))) : null,
                            child: Row(
                              children: [
                                LeaderboardNumber(number: index + 1),
                                Flexible(
                                  child: Container(
                                    height: 35,
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      teamsStats[index].team.name,
                                      style: Theme.of(context).textTheme.bodyText2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 50,
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.p),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.w),
                              if (hasDraws) StatisticHeaderElement(value: AppLocalizations.of(context)!.d),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.l),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.mp),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.pd),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.sd),
                              StatisticHeaderElement(height: itemHeight, value: AppLocalizations.of(context)!.ep),
                            ],
                          ),
                          Column(
                            children: teamsStats.map(
                              (e) {
                                return ItemTournamentStatistic(
                                  height: itemHeight,
                                  drawDivider: true,
                                  hasDraws: hasDraws,
                                  teamStat: e,
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class StatisticHeaderElement extends StatelessWidget {
  final String value;
  final double height;

  const StatisticHeaderElement({Key? key, required this.value, this.height = 35}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 50,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          value,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}

class LeaderboardNumber extends StatelessWidget {
  final int number;

  const LeaderboardNumber({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: -2,
        surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.4,
        color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight,
        shadowDarkColorEmboss: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
        shadowLightColorEmboss:
            Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: SizedBox(
        height: 25,
        width: 25,
        child: Center(child: Text(number.toString())),
      ),
    );
  }
}
