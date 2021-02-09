
import 'dart:async';

import 'package:people_repository/people_repository.dart';

abstract class PeopleRepository {
  Future<void> addNewPerson(Person todo);

  Future<void> deletePerson(Person todo);

  Stream<List<Person>> people();

  Future<void> updatePerson(Person todo);
}