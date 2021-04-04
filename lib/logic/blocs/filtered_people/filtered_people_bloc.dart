import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/people/people_bloc.dart';
import 'package:form_it/logic/blocs/people/people_state.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:repositories/repositories.dart';

import 'filtered_people_event.dart';
import 'filtered_people_state.dart';

class FilteredPeopleBloc extends Bloc<FilteredPeopleEvent, FilteredPeopleState> {
  final PeopleBloc _peopleBloc;
  StreamSubscription? _peopleSubscription;

  FilteredPeopleBloc({required PeopleBloc peopleBloc})
      : _peopleBloc = peopleBloc,
        super(peopleBloc.state is PeopleLoaded
            ? FilteredPeopleLoaded(
                (peopleBloc.state as PeopleLoaded).people,
                VisibilityFilter.all,
              )
            : FilteredPeopleLoading()) {
    _peopleSubscription = _peopleBloc.stream.listen((state) {
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
    final PeopleState currentState = _peopleBloc.state;
    if (currentState is PeopleLoaded) {
      yield FilteredPeopleLoaded(
        _mapPeopleToFilteredPeople(currentState.people, event.filter, event.searchQuery),
        event.filter,
        searchQuery: event.searchQuery,
      );
    }
  }

  Stream<FilteredPeopleState> _mapPeopleUpdatedToState(UpdatePeople event) async* {
    final visibilityFilter = state is FilteredPeopleLoaded ? (state as FilteredPeopleLoaded).activeFilter : VisibilityFilter.all;
    final searchQuery = state is FilteredPeopleLoaded ? (state as FilteredPeopleLoaded).searchQuery : "";
    yield FilteredPeopleLoaded(
      _mapPeopleToFilteredPeople(
        (_peopleBloc.state as PeopleLoaded).people,
        visibilityFilter,
        searchQuery,
      ),
      visibilityFilter,
    );
  }

  List<Player> _mapPeopleToFilteredPeople(List<Player> people, VisibilityFilter filter, String searchQuery) {
    return people.where((player) {
      if (filter == VisibilityFilter.all && searchQuery == "") {
        return true;
      } else if (filter == VisibilityFilter.all && searchQuery != ""){
        return player.nickname.toLowerCase().contains(searchQuery.toLowerCase());
      } else if (filter == VisibilityFilter.active && searchQuery == "") {
        return !player.available;
      }else if (filter == VisibilityFilter.active && searchQuery != "") {
        return !player.available && player.nickname.toLowerCase().contains(searchQuery.toLowerCase());
      } else if (searchQuery != ""){
        return player.available && player.nickname.toLowerCase().contains(searchQuery.toLowerCase());
      }else{
        return player.available;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    _peopleSubscription?.cancel();
    return super.close();
  }
}
