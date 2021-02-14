import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

abstract class TeamsEvent extends Equatable {
  const TeamsEvent();

  @override
  List<Object> get props => [];
}

class LoadTeams extends TeamsEvent {}

class FormTeams extends TeamsEvent {}

class TeamsUpdated extends TeamsEvent {
  final List<Team> teams;

  const TeamsUpdated(this.teams);

  @override
  List<Object> get props => [teams];
}

// class UpdatePerson extends TeamsEvent {
//   final Person updatedPerson;
//
//   const UpdatePerson(this.updatedPerson);
//
//   @override
//   List<Object> get props => [updatedPerson];
//
//   @override
//   String toString() => 'UpdateTodo { updatedTodo: $updatedPerson }';
// }
//
// class ClearCompleted extends TeamsEvent {}
//
// class ToggleAll extends TeamsEvent {}
//



// class AddPerson extends TeamsEvent {
//   final Person person;
//
//   const AddPerson(this.person);
//
//   @override
//   List<Object> get props => [person];
//
//   @override
//   String toString() => 'AddTodo { todo: $person }';
// }

//
// class DeletePerson extends TeamsEvent {
//   final Person people;
//
//   const DeletePerson(this.people);
//
//   @override
//   List<Object> get props => [people];
//
//   @override
//   String toString() => 'DeleteTodo { todo: $people }';
// }
