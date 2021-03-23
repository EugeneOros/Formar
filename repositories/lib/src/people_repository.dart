
import 'dart:async';

import 'package:repositories/repositories.dart';

import 'models/models.dart';

abstract class PeopleRepository {
  Future<void> addNewPerson(Player person);

  Future<void> deletePerson(Player person);

  Stream<List<Player>> people();

  Future<List<Player>> currentPeopleList();

  Future<void> updatePerson(Player person);

  Future getPerson(String personID);
}