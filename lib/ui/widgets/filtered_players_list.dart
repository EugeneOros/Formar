import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_event.dart';
import 'package:form_it/ui/screens/add_edit_player_screen.dart';
import 'package:form_it/ui/shared/dependency.dart';
import 'package:form_it/ui/widgets/item_player.dart';

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
          final people = state.filteredPeople;
          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              return Column(
                children: [
                  (index == 0 || people[index].nickname[0].toUpperCase() != people[index - 1].nickname[0].toUpperCase()) ?
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(person.nickname[0].toUpperCase(), style: Theme.of(context).textTheme.subtitle1,),
                  ) : Container() ,
                  PlayerItem(
                    player: person,
                    onDelete: () {
                      BlocProvider.of<PeopleBloc>(context)
                          .add(DeletePerson(person));
                      ScaffoldMessenger.of(context).showSnackBar(
                        AppSnackBar(
                          text: AppLocalizations.of(context)!.deleted + " " + person.nickname,
                          actionName: AppLocalizations.of(context)!.undo,
                          onAction: () => BlocProvider.of<PeopleBloc>(context)
                              .add(AddPerson(person)),
                          actionColor: Theme.of(context).accentColor,
                        ),
                      );
                    },
                    onEdit: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return AddEditPlayerScreen(
                              onSave: (nickname, level, sex) {
                                BlocProvider.of<PeopleBloc>(context).add(
                                  UpdatePerson(
                                    person.copyWith(nickname: nickname, level: level, sex: sex),
                                  ),
                                );
                              },
                              isEditing: true,
                              person: person,
                            );
                          },
                        ),
                      );
                    },
                    onSwitchChanged: (_) {
                      BlocProvider.of<PeopleBloc>(context).add(
                        UpdatePerson(person.copyWith(available: !person.available)),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
