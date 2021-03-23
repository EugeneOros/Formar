import 'dart:async';
import 'package:repositories/src/models/team.dart';

import 'models/models.dart';

abstract class TeamRepository {

  Stream<List<Team>> teams();

  Future<void> formTeams( bool isBalanced, int numMembers);
}