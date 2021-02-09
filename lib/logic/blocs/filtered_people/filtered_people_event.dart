import 'package:equatable/equatable.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:people_repository/people_repository.dart';


abstract class FilteredPeopleEvent extends Equatable {
  const FilteredPeopleEvent();
}


class UpdateFilter extends FilteredPeopleEvent {
  final VisibilityFilter filter;

  const UpdateFilter(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'UpdateFilter { filter: $filter }';
}


class UpdatePeople extends FilteredPeopleEvent {
  final List<Person> people;

  const UpdatePeople(this.people);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'UpdatePeople { people: $people }';
}
