
import 'dart:async';

import 'package:team_repository/team_repository.dart';

import 'models/models.dart';

abstract class TeamRepository {
  Future<void> addNewPerson(Person todo);

  Future<void> deletePerson(Person todo);

  Stream<List<Person>> teams();

  Future<void> updatePerson(Person todo);

  Future<void> formTeams(Person todo);
}