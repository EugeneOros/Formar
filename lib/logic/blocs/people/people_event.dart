import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

abstract class PeopleEvent extends Equatable {
  const PeopleEvent();

  @override
  List<Object> get props => [];
}

class LoadPeople extends PeopleEvent {}

class TurnOffPeople extends PeopleEvent {}

class AddPerson extends PeopleEvent {
  final Person person;

  const AddPerson(this.person);

  @override
  List<Object> get props => [person];

  @override
  String toString() => 'AddTodo { todo: $person }';
}

class UpdatePerson extends PeopleEvent {
  final Person updatedPerson;

  const UpdatePerson(this.updatedPerson);

  @override
  List<Object> get props => [updatedPerson];

  @override
  String toString() => 'UpdateTodo { updatedTodo: $updatedPerson }';
}



class DeletePerson extends PeopleEvent {
  final Person people;

  const DeletePerson(this.people);

  @override
  List<Object> get props => [people];

  @override
  String toString() => 'DeleteTodo { todo: $people }';
}

class ClearCompleted extends PeopleEvent {}

class ToggleAll extends PeopleEvent {}

class PeopleUpdated extends PeopleEvent {
  final List<Person> people;

  const PeopleUpdated(this.people);

  @override
  List<Object> get props => [people];
}