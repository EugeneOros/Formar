import 'package:equatable/equatable.dart';
import 'package:form_it/logic/models/visibility_filter.dart';
import 'package:repositories/repositories.dart';

abstract class FilteredPeopleState extends Equatable {
  const FilteredPeopleState();

  @override
  List<Object> get props => [];
}

class FilteredPeopleLoading extends FilteredPeopleState {}

class FilteredPeopleLoaded extends FilteredPeopleState {
  final List<Player> filteredPeople;
  final VisibilityFilter activeFilter;
  final String searchQuery;

  const FilteredPeopleLoaded(this.filteredPeople, this.activeFilter, {this.searchQuery = ""});

  @override
  List<Object> get props => [filteredPeople, activeFilter, searchQuery];

  @override
  String toString() {
    return 'FilteredPeopleLoaded { filteredPeople: $filteredPeople, activeFilter: $activeFilter }';
  }
}
