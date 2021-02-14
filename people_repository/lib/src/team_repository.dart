import 'dart:async';
import 'package:people_repository/src/models/team.dart';

import 'models/models.dart';

abstract class TeamRepository {
  // Future<void> addNewPerson(Person todo);

  // Future<void> deletePerson(Person todo);

  Stream<List<Team>> teams();

  // Future<void> updatePerson(Person todo);

  Future<void> formTeams();
}