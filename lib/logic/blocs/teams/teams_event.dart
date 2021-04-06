import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

abstract class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTeams extends TeamsEvent {}

class FormTeams extends TeamsEvent {
  final bool isBalanced;
  final int? counterTeamMember;
  final String? defaultReplacementName;
  final String? defaultTeamName;

  const FormTeams(this.isBalanced, this.counterTeamMember, {this.defaultReplacementName, this.defaultTeamName});

  @override
  List<Object?> get props => [isBalanced, counterTeamMember];

}

class TeamsUpdated extends TeamsEvent {
  final List<Team> teams;

  const TeamsUpdated(this.teams);

  @override
  List<Object> get props => [teams];
}

class AddTeam extends TeamsEvent {
  final Team team;

  const AddTeam(this.team);

  @override
  List<Object> get props => [team];

  @override
  String toString() => 'AddTeam { team: $team }';
}

class UpdateTeam extends TeamsEvent {
  final Team updatedTeam;

  const UpdateTeam(this.updatedTeam);

  @override
  List<Object> get props => [updatedTeam];

  @override
  String toString() => 'UpdateTeam { updatedTeam: $updatedTeam }';
}

class DeleteTeam extends TeamsEvent {
  final Team team;

  const DeleteTeam(this.team);

  @override
  List<Object> get props => [team];

  @override
  String toString() => 'DeleteTeam { team: $team }';
}

class DeleteAll extends TeamsEvent {}