import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/filtered_people/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_event.dart';
import 'package:form_it/ui/widgets/person_item.dart';

import 'delete_people_snack_bar.dart';
import 'loading.dart';

class FilteredPeopleList extends StatelessWidget {
  FilteredPeopleList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredPeopleBloc, FilteredPeopleState>(
      builder: (context, state) {
        if (state is FilteredPeopleLoading) {
          return Loading();
        } else if (state is FilteredPeopleLoaded) {
          final todos = state.filteredPeople;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return PersonItem(
                todo: todo,
                onDismissed: (direction) {
                  BlocProvider.of<PeopleBloc>(context).add(DeletePerson(todo));
                  Scaffold.of(context).showSnackBar(DeletePersonSnackBar(
                    todo: todo,
                    onUndo: () =>
                        BlocProvider.of<PeopleBloc>(context).add(AddPerson(todo)),
                  ));
                },
                onTap: () async {
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
                onCheckboxChanged: (_) {
                  BlocProvider.of<PeopleBloc>(context).add(
                    UpdatePerson(todo.copyWith(complete: !todo.complete)),
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