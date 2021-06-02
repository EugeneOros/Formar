import 'package:form_it/config/dependency.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/dialog_content_add_teams.dart';
import 'package:form_it/pages/add_edit_tournament/widgets/item_tournament_teams.dart';
import 'package:form_it/widgets/app_dialog.dart';
import 'package:form_it/widgets/emboss_container.dart';
import 'package:form_it/widgets/round_icon_button.dart';
import 'package:form_it/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:repositories/repositories.dart';
import 'package:form_it/config/helpers.dart';

typedef void OnAddTeamsCallback(List<Team> newTeams);
typedef void OnMatchEmptyCheckCallback(Function newMatchesSchedule);

class TournamentTeams extends StatefulWidget {
  final List<Team> teams;
  final OnAddTeamsCallback onAddTeamsCallback;
  final OnMatchEmptyCheckCallback onMatchEmptyCheckCallback;

  const TournamentTeams(
      {Key? key, required this.teams, required this.onAddTeamsCallback, required this.onMatchEmptyCheckCallback})
      : super(key: key);

  @override
  _TournamentTeamsState createState() => _TournamentTeamsState();
}

class _TournamentTeamsState extends State<TournamentTeams> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.teams.sort((a, b) => a.name.compareTo(b.name));

    final teamsAll = Provider.of<List<Team>>(context);
    _onAddTeams() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          DialogContentAddTeams _dialogAddPlayers = DialogContentAddTeams(
            teams: teamsAll,
            teamsAdded: widget.teams,
          );
          return AppDialog(
            title: AppLocalizations.of(context)!.choseTeams,
            content: _dialogAddPlayers,
            actionsHorizontal: [
              TextButton(
                child: Text(
                  MaterialLocalizations.of(context).okButtonLabel,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  this.widget.onAddTeamsCallback(_dialogAddPlayers.getTeams());
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
    }

    return Neumorphic(
      style: NeumorphicStyle(
        depth: 0,
        surfaceIntensity: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? 0 : 0.25,
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
                  Theme.of(context).colorScheme.secondary,
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
                  Theme.of(context).colorScheme.secondary.withOpacity(0),
                  // Colors.transparent
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: widget.teams.isEmpty
                ? Container(
                    padding: const EdgeInsets.only(top: 110),
                    alignment: Alignment.center,
                    child: RoundedButton(
                      text: AppLocalizations.of(context)!.addTeams,
                      textColor: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? LightPink : Colors.black,
                      color: Provider.of<AppStateNotifier>(context, listen: false).isDarkMode ? DarkColorAccent : Theme.of(context).colorScheme.secondary,
                      sizeRatio: 0.9,
                      onPressed: () => widget.onMatchEmptyCheckCallback(_onAddTeams),
                    ),
                  )
                : Stack(
                    children: [
                      EmbossContainer(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 110, bottom: 60),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(left: 10, top: 10),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: widget.teams.length,
                              itemBuilder: (context, index) {
                                return ItemTournamentTeams(
                                  text: widget.teams[index].name,
                                  // drawDivider: index == 0 ? false : true,
                                  secondaryWidget: RoundIconButton(
                                    icon: Icons.remove,
                                    onPressed: () => widget.onMatchEmptyCheckCallback(() => setState(() {
                                          widget.teams.removeAt(index);
                                        })),
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
                          child: RoundIconButton(
                              icon: Icons.add,
                              size: 60,
                              color: Theme.of(context).colorScheme.secondary,
                              onPressed: () => widget.onMatchEmptyCheckCallback(_onAddTeams)),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
