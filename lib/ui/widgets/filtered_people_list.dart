import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_event.dart';
import 'package:form_it/ui/screens/add_edit_screen.dart';
import 'package:form_it/ui/widgets/person_item.dart';

import 'delete_people_snack_bar.dart';
import 'loading.dart';

class FilteredPeopleList extends StatelessWidget {
  FilteredPeopleList({Key key}) : super(key: key);
  final SlidableController slidableController = SlidableController();

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
              return PersonItem(
                person: person,
                slidableController: slidableController,
                onDelete: () {
                  BlocProvider.of<PeopleBloc>(context)
                      .add(DeletePerson(person));
                  Scaffold.of(context).showSnackBar(
                    DeletePersonSnackBar(
                      todo: person,
                      onUndo: () => BlocProvider.of<PeopleBloc>(context)
                          .add(AddPerson(person)),
                    ),
                  );
                },
                onEdit: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return AddEditScreen(
                          onSave: (nickname, level) {
                            BlocProvider.of<PeopleBloc>(context).add(
                              UpdatePerson(
                                person.copyWith(task: nickname, level: level),
                              ),
                            );
                          },
                          isEditing: true,
                          person: person,
                        );
                      },
                    ),
                  );
                  // final removedTodo = await Navigator.of(context).push(
                  //   MaterialPageRoute(builder: (_) {
                  //     return DetailsScreen(id: todo.id);
                  //   }),
                  // );
                  // if (removedTodo != null) {
                  //   Scaffold.of(context).showSnackBar(
                  //     DeletePersonSnackBar(
                  //       todo: todo,
                  //       onUndo: () => BlocProvider.of<PeopleBloc>(context)
                  //           .add(AddPerson(todo)),
                  //     ),
                  //   );
                  // }
                },
                onSwitchChanged: (_) {
                  BlocProvider.of<PeopleBloc>(context).add(
                    UpdatePerson(person.copyWith(complete: !person.available)),
                  );
                },
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
