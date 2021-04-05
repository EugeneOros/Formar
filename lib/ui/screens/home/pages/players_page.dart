import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_event.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/ui/screens/add_edit_player_screen.dart';
import 'package:form_it/ui/shared/constants.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:form_it/ui/widgets/app_dialog.dart';
import 'package:form_it/ui/widgets/app_snack_bar.dart';
import 'package:form_it/ui/widgets/item_player.dart';
import 'package:form_it/ui/widgets/letter_divider.dart';
import 'package:form_it/ui/widgets/loading.dart';
import 'package:repositories/repositories.dart';

class PlayersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SlidableController _slidableController = SlidableController();
    void _deleteFormPlayers(Player player) {
      BlocProvider.of<PeopleBloc>(context).add(DeletePerson(player));
      ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        AppSnackBar(
          text: AppLocalizations.of(scaffoldKey.currentContext!)!.deleted + " " + player.nickname,
          actionName: AppLocalizations.of(scaffoldKey.currentContext!)!.undo,
          onAction: () {
            BlocProvider.of<PeopleBloc>(scaffoldKey.currentContext!).add(AddPerson(player));
          },
          actionColor: Theme.of(scaffoldKey.currentContext!).accentColor,
        ),
      );
    }

    List<Team> _teamsThatContains(Player player, List<Team> teams) {
      List<Team> teamsThatContains = [];
      teams.forEach((team) {
        team.players.forEach((teamPlayer) {
          if (teamPlayer.id == player.id) teamsThatContains.add(team);
        });
      });
      return teamsThatContains;
    }

    Future<bool> _onDelete(player, teams) async {
      List<Team> teamsThatContains = [];
      teams.forEach((team) {
        team.players.forEach((teamPlayer) {
          if (teamPlayer.id == player.id) teamsThatContains.add(team);
        });
      });
      if (teamsThatContains.isNotEmpty) {
        Future<bool?> result = showDialog<bool>(
            context: context,
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

    return BlocBuilder<FilteredPeopleBloc, FilteredPeopleState>(
      builder: (context, state) {
        if (state is FilteredPeopleLoading) {
          return Loading();
        } else if (state is FilteredPeopleLoaded) {
          final players = state.filteredPeople;
          return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, stateTeam) {
            if (stateTeam is TeamsLoaded) {
              return Column(
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
                              onDelete: () => _onDelete(player, stateTeam.teams),
                              onEdit: () async {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddEditPlayerScreen(
                                        onSave: (nickname, level, sex) {
                                          BlocProvider.of<PeopleBloc>(context).add(
                                            UpdatePerson(
                                              player.copyWith(nickname: nickname, level: level, sex: sex),
                                            ),
                                          );
                                        },
                                        isEditing: true,
                                        person: player,
                                      );
                                    },
                                  ),
                                );
                              },
                              onShowTeams: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      List<Team> teams = _teamsThatContains(player, stateTeam.teams);
                                      return AppDialog(
                                        title: teams.length >= 1 ? AppLocalizations.of(context)!.teamsNames : AppLocalizations.of(context)!.noTeam,
                                        content: teams.length >= 1
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border(top: borderSideDivider),
                                                ),
                                                width: MediaQuery.of(context).size.width / 1.7,
                                                height: MediaQuery.of(context).size.height / 6,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children: teams.map((e) {
                                                    return Container(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.zero,
                                                      height: 37,
                                                      child: Container(
                                                        padding: EdgeInsets.all(10),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          e.name,
                                                          style: Theme.of(context).textTheme.bodyText2,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              )
                                            : Container(),
                                        actionsVertical: [
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(
                                                MaterialLocalizations.of(context).okButtonLabel,
                                                style: Theme.of(context).textTheme.button,
                                              ))
                                        ],
                                      );
                                    });
                              },
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
