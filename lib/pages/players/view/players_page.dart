import 'package:form_it/config/dependency.dart';
import 'package:form_it/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/widgets/widgets.dart';
import 'package:repositories/repositories.dart';

import 'package:form_it/pages/players/widgets/widgets.dart';


class PlayersPage extends StatelessWidget {

  List<Team> _teamsThatContains(Player player, List<Team> teams) {
    List<Team> teamsThatContains = [];
    teams.forEach((team) {
      team.players.forEach((teamPlayer) {
        if (teamPlayer.id == player.id) teamsThatContains.add(team);
      });
    });
    return teamsThatContains;
  }

  void _deleteFormPlayers(Player player) {
    BlocProvider.of<PeopleBloc>(homeKey.currentContext!).add(DeletePerson(player));
    ScaffoldMessenger.of(homeKey.currentContext!).showSnackBar(
      AppSnackBar(
        text: AppLocalizations.of(homeKey.currentContext!)!.deleted + " " + player.nickname,
        actionName: AppLocalizations.of(homeKey.currentContext!)!.undo,
        onAction: () {
          BlocProvider.of<PeopleBloc>(homeKey.currentContext!).add(AddPerson(player));
        },
        actionColor: Theme.of(homeKey.currentContext!).accentColor,
      ),
    );
  }

  Future<bool> _onDelete(Player player, List<Team> teams) async {
    List<Team> teamsThatContains = [];
    teams.forEach((team) {
      team.players.forEach((teamPlayer) {
        if (teamPlayer.id == player.id) teamsThatContains.add(team);
      });
    });
    if (teamsThatContains.isNotEmpty) {
      Future<bool?> result = showDialog<bool>(
          context: homeKey.currentContext!,
          builder: (context) {
            return AppDialog(
              title: AppLocalizations.of(context)!.playerDeletedFromTeams,
              actionsHorizontal: [
                TextButton(
                  onPressed: () {
                    Player? toDelete;
                    teamsThatContains.forEach((team) {
                      team.players.forEach((teamPlayer) {
                        if (teamPlayer.id == player.id) {
                          toDelete = teamPlayer;
                        }
                      });
                      team.players.remove(toDelete);
                      BlocProvider.of<TeamsBloc>(context).add(UpdateTeam(team));
                    });
                    _deleteFormPlayers(player);
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    MaterialLocalizations.of(context).okButtonLabel,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    MaterialLocalizations.of(context).backButtonTooltip,
                    style: Theme.of(context).textTheme.button,
                  ),
                )
              ],
            );
          });
      return await result ?? false;
    } else {
      _deleteFormPlayers(player);
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SlidableController _slidableController = SlidableController();

    return BlocBuilder<FilteredPeopleBloc, FilteredPeopleState>(
      builder: (context, state) {
        if (state is FilteredPeopleLoading) {
          return Loading();
        } else if (state is FilteredPeopleLoaded) {
          final players = state.filteredPeople;
          return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, stateTeam) {
            if (stateTeam is TeamsLoaded) {
              return Container(
                alignment: Alignment.center,
                color: Theme.of(context).accentColor,
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  constraints: BoxConstraints(minWidth: 50, maxWidth: 700),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: players.length,
                          itemBuilder: (context, index) {
                            final player = players[index];
                            bool isLastInLetterGroup =
                                (index == 0 || players[index].nickname[0].toUpperCase() != players[index - 1].nickname[0].toUpperCase());
                            return Column(
                              children: [
                                if (isLastInLetterGroup)
                                  LetterDivider(
                                    letter: player.nickname[0].toUpperCase(),
                                    secondaryString: index == 0
                                        ? players.where((player) => player.available == true).length.toString() + "/" + players.length.toString()
                                        : null,
                                  ),
                                PlayerItem(
                                  drawDivider: !isLastInLetterGroup,
                                  slidableController: _slidableController,
                                  player: player,
                                  teams: _teamsThatContains(player, stateTeam.teams),
                                  onDelete: () => _onDelete(player, stateTeam.teams),
                                  onSwitchChanged: (_) {
                                    BlocProvider.of<PeopleBloc>(context).add(
                                      UpdatePerson(player.copyWith(available: !player.available)),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Loading();
          });
        } else {
          return Container();
        }
      },
    );
  }
}
