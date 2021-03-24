
import 'dart:async';

import 'package:repositories/repositories.dart';

import 'models/models.dart';

abstract class PlayersRepository {
  Future<void> addNewPlayer(Player person);

  Future<void> deletePlayer(Player person);

  Stream<List<Player>> players();

  Future<List<Player>> currentPlayersList();

  Future<void> updatePlayer(Player person);

  Future getPlayer(String personID);
}