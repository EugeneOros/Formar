import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_state.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:meta/meta.dart';
import 'package:people_repository/people_repository.dart';

import 'filtered_people_event.dart';
import 'filtered_people_state.dart';

class FilteredPeopleBloc extends Bloc<FilteredPeopleEvent , FilteredPeopleState> {
  final PeopleBloc _peopleBloc;
  StreamSubscription _peopleSubscription;

  FilteredPeopleBloc({@required PeopleBloc peopleBloc})
      : assert(peopleBloc != null),
        _peopleBloc = peopleBloc,
        super(peopleBloc.state is PeopleLoaded
            ? FilteredPeopleLoaded(
                (peopleBloc.state as PeopleLoaded).people,
                VisibilityFilter.all,
              )
            : FilteredPeopleLoading()) {
    _peopleSubscription = peopleBloc.listen((state) {
      if (state is PeopleLoaded) {
        add(UpdatePeople((peopleBloc.state as PeopleLoaded).people));
      }
    });
  }

  @override
  Stream<FilteredPeopleState> mapEventToState(FilteredPeopleEvent event) async* {
    if (event is UpdateFilter) {
      yield* _mapUpdateFilterToState(event);
    } else if (event is UpdatePeople) {
      yield* _mapPeopleUpdatedToState(event);
    }
  }

  Stream<FilteredPeopleState> _mapUpdateFilterToState(
    UpdateFilter event,
  ) async* {
    final currentState = _peopleBloc.state;
    if (currentState is PeopleLoaded) {
      yield FilteredPeopleLoaded(
        _mapPeopleToFilteredPeople(currentState.people, event.filter),
        event.filter,
      );
    }
  }

  Stream<FilteredPeopleState> _mapPeopleUpdatedToState(
    UpdatePeople event,
  ) async* {
    final visibilityFilter = state is FilteredPeopleLoaded
        ? (state as FilteredPeopleLoaded).activeFilter
        : VisibilityFilter.all;
    yield FilteredPeopleLoaded(
      _mapPeopleToFilteredPeople(
        (_peopleBloc.state as PeopleLoaded).people,
        visibilityFilter,
      ),
      visibilityFilter,
    );
  }

  List<Person> _mapPeopleToFilteredPeople(
      List<Person> people, VisibilityFilter filter) {
    return people.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    _peopleSubscription?.cancel();
    return super.close();
  }
}
