import 'dart:async';
import 'package:repositories/src/models/team.dart';

import 'models/models.dart';

abstract class TeamRepository {

  Stream<List<Team>> teams();

  Future<void> formTeams( bool isBalanced, int numMembers, {String? defaultTeamName, String? defaultReplacementName});

  Future<void> updateTeam(Team team);

  Future<void> addTeam(Team team);

  Future<void> deleteTeam(Team team);

  Future<void> deleteAll();

  Future getTeam(String teamID);

  Future<List<Team>> currentTeamsList();
}