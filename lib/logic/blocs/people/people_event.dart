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
  final Player person;

  const AddPerson(this.person);

  @override
  List<Object> get props => [person];

  @override
  String toString() => 'AddPerson { person: $person }';
}

class UpdatePerson extends PeopleEvent {
  final Player updatedPerson;

  const UpdatePerson(this.updatedPerson);

  @override
  List<Object> get props => [updatedPerson];

  @override
  String toString() => 'UpdatePerson { updatedPerson: $updatedPerson }';
}



class DeletePerson extends PeopleEvent {
  final Player person;

  const DeletePerson(this.person);

  @override
  List<Object> get props => [person];

  @override
  String toString() => 'DeletePerson { person: $person }';
}

class ClearCompleted extends PeopleEvent {}

class ToggleAll extends PeopleEvent {}

class PeopleUpdated extends PeopleEvent {
  final List<Player> people;

  const PeopleUpdated(this.people);

  @override
  List<Object> get props => [people];
}