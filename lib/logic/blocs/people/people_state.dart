import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

abstract class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object> get props => [];
}

class PeopleLoading extends PeopleState {}

class PeopleLoaded extends PeopleState {
  final List<Person> people;

  const PeopleLoaded([this.people = const []]);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'PeopleLoaded { people: $people }';
}

class PeopleNotLoaded extends PeopleState {}