import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:repositories/repositories.dart';

import 'dialog_content_sets.dart';
typedef void OnOkSetCallback(Match match);
class ItemTournamentMatches extends StatefulWidget {
  // final String team1;
  // final String team2;
  final OnOkSetCallback onOkSetCallback;
  final bool drawDivider;
  final Color? color;
  final Match match;

  const ItemTournamentMatches({Key? key, this.drawDivider = false, this.color, required this.match, required this.onOkSetCallback}) : super(key: key);

  @override
  _ItemTournamentMatchesState createState() => _ItemTournamentMatchesState();
}

class _ItemTournamentMatchesState extends State<ItemTournamentMatches> {
  String getScoreStr() {
    int firstTeamScore = 0;
    int secondTeamScore = 0;
    for (Score set in widget.match.sets) {
      if (set.firstTeamPoints == null || set.secondTeamPoints == null) {
        return "? : ?";
      } else if (set.firstTeamPoints! > set.secondTeamPoints!) {
        firstTeamScore++;
      } else if (set.firstTeamPoints! < set.secondTeamPoints!) {
        secondTeamScore++;
      } else {
        firstTeamScore++;
        secondTeamScore++;
      }
    }
    return firstTeamScore.toString() + " : " + secondTeamScore.toString();
  }

  bool isSetsHaveScore() {
    for (Score set in widget.match.sets) {
      if (set.firstTeamPoints == null || set.secondTeamPoints == null) {
        return false;
      }
    }
    return true;
  }

  void onSetPressed() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        border: widget.drawDivider ? Border(top: getBorderDivider(context)) : null,
        color: isSetsHaveScore()
            ? (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColor : Theme.of(context).primaryColorLight)
            : (Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              widget.match.firstTeam != null ? widget.match.firstTeam!.name : "Unknown",
              style: Theme.of(context).textTheme.bodyText2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Spacer(),
          NeumorphicButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  DialogContentSets dialogContentSets = DialogContentSets(
                    match: widget.match,
                  );
                  return AppDialog(
                    // title: AppLocalizations.of(context)!.chosePlayers,
                    content: dialogContentSets,
                    actionsHorizontal: [
                      TextButton(
                        child: Text(
                          MaterialLocalizations.of(context).okButtonLabel,
                          style: Theme.of(context).textTheme.button,
                        ),
                        onPressed: () {
                          widget.onOkSetCallback(widget.match);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          MaterialLocalizations.of(context).cancelButtonLabel.toLowerCase().capitalize(),
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
              // setState(() {
              //   widget.match.sets.add(Score(firstTeamPoints: 1, secondTeamPoints: 2));
              // });
            },
            style: NeumorphicStyle(
              depth: 1,
              surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.4,
              color: Theme.of(context).primaryColorLight,
              shape: NeumorphicShape.concave,
              shadowDarkColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowDark : Colors.grey.withOpacity(0.7),
              shadowLightColor:
                  Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorShadowLight : Colors.white.withOpacity(0.7),
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
            child: Text(
              getScoreStr(), // "unknown",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Spacer(),
          Expanded(
            child: Text(
              widget.match.secondTeam != null ? widget.match.secondTeam!.name : "Unknown",
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
