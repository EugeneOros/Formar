import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_event.dart';
import 'package:form_it/logic/blocs/teams/bloc.dart';
import 'package:form_it/ui/screens/add_edit_player_screen.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:form_it/ui/widgets/item_player.dart';

import 'app_dialog.dart';
import 'app_snack_bar.dart';
import 'loading.dart';

class FilteredPeopleList extends StatelessWidget {
  FilteredPeopleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredPeopleBloc, FilteredPeopleState>(
      builder: (context, state) {
        if (state is FilteredPeopleLoading) {
          return Loading();
        } else if (state is FilteredPeopleLoaded) {
          final players = state.filteredPeople;
          return BlocBuilder<TeamsBloc, TeamsState>(builder: (context, stateTeam) {
            if (stateTeam is TeamsLoaded) {
              return ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Column(
                    children: [
                      (index == 0 || players[index].nickname[0].toUpperCase() != players[index - 1].nickname[0].toUpperCase())
                          ? Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          player.nickname[0].toUpperCase(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1,
                        ),
                      )
                          : Container(),
                      PlayerItem(
                        player: player,
                        onDelete: () {
                          bool containsPlayer = false;
                          stateTeam.teams.forEach((team) {
                            team.players.forEach((teamPlayer) {
                              if(teamPlayer.id == player.id)
                                containsPlayer = true;
                            });
                          });
                          if (containsPlayer) {
                            showDialog(context: context, builder: (context) {
                              return AppDialog(title: 'Firstly delete this person from team',);
                            });
                          } else {
                            BlocProvider.of<PeopleBloc>(context).add(DeletePerson(player));
                            ScaffoldMessenger.of(context).showSnackBar(
                              AppSnackBar(
                                text: AppLocalizations.of(context)!.deleted + " " + player.nickname,
                                actionName: AppLocalizations.of(context)!.undo,
                                onAction: () => BlocProvider.of<PeopleBloc>(context).add(AddPerson(player)),
                                actionColor: Theme
                                    .of(context)
                                    .accentColor,
                              ),
                            );
                          }
                        },
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
                        onSwitchChanged: (_) {
                          BlocProvider.of<PeopleBloc>(context).add(
                            UpdatePerson(player.copyWith(available: !player.available)),
                          );
                        },
                      ),
                    ],
                  );
                },
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
