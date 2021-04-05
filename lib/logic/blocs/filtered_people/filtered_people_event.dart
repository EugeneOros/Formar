import 'package:equatable/equatable.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:repositories/repositories.dart';


abstract class FilteredPeopleEvent extends Equatable {
  const FilteredPeopleEvent();
}


class UpdateFilter extends FilteredPeopleEvent {
  final VisibilityFilter? filter;
  final String? searchQuery;

  const UpdateFilter({this.filter, this.searchQuery});

  @override
  List<Object> get props => [filter!, searchQuery!];

  @override
  String toString() => 'UpdateFilter { filter: $filter, $searchQuery }';
}


class UpdatePeople extends FilteredPeopleEvent {
  final List<Player> people;

  const UpdatePeople(this.people);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'UpdatePeople { people: $people }';
}
