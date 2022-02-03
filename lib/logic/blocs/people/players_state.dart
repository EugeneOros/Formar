part of 'players_bloc.dart';

abstract class PlayersState extends Equatable {
  const PlayersState();

  @override
  List<Object> get props => [];
}

class PeopleLoading extends PlayersState {}

class PeopleLoaded extends PlayersState {
  final List<Player> people;

  const PeopleLoaded([this.people = const []]);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'PeopleLoaded { people: $people }';
}

class PeopleNotLoaded extends PlayersState {}