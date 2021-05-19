import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

abstract class TournamentsEvent extends Equatable {
  const TournamentsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTournaments extends TournamentsEvent {}

class FormMatches extends TournamentsEvent {
  // final bool isBalanced;
  // final int? counterTeamMember;
  // final String? defaultReplacementName;
  // final String? defaultTeamName;
  //
  // const FormMatches(this.isBalanced, this.counterTeamMember, {this.defaultReplacementName, this.defaultTeamName});
  //
  // @override
  // List<Object?> get props => [isBalanced, counterTeamMember];
}

class TournamentsUpdated extends TournamentsEvent {
  final List<Tournament> tournaments;

  const TournamentsUpdated(this.tournaments);

  @override
  List<Object> get props => [tournaments];
}

class AddTournament extends TournamentsEvent {
  final Tournament tournament;

  const AddTournament(this.tournament);

  @override
  List<Object> get props => [tournament];

  @override
  String toString() => 'AddTournament { tournament: $tournament }';
}

class UpdateTournament extends TournamentsEvent {
  final Tournament updatedTournament;

  const UpdateTournament(this.updatedTournament);

  @override
  List<Object> get props => [updatedTournament];

  @override
  String toString() => 'UpdateTournament { updatedTournament: $updatedTournament }';
}

class DeleteTournament extends TournamentsEvent {
  final Tournament tournament;

  const DeleteTournament(this.tournament);

  @override
  List<Object> get props => [tournament];

  @override
  String toString() => 'DeleteTournament { tournament: $tournament }';
}