
import 'dart:async';

import 'package:people_repository/people_repository.dart';

import 'models/models.dart';

abstract class PeopleRepository {
  Future<void> addNewPerson(Person person);

  Future<void> deletePerson(Person person);

  Stream<List<Person>> people();

  Future<List<Person>> currentPeopleList();

  Future<void> updatePerson(Person person);
}