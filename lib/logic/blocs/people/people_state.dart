import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

abstract class PeopleState extends Equatable {
  const PeopleState();

  @override
  List<Object> get props => [];
}

class PeopleLoading extends PeopleState {}

class PeopleLoaded extends PeopleState {
  final List<Player> people;

  const PeopleLoaded([this.people = const []]);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'PeopleLoaded { people: $people }';
}

class PeopleNotLoaded extends PeopleState {}