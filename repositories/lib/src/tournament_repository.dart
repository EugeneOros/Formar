
import 'package:repositories/repositories.dart';

abstract class TournamentRepository{
  Stream<List<Tournament>> tournaments();

  Future<void> updateTournament(Tournament tournament);

  Future<void> addTournament(Tournament tournament);

  Future<void> deleteTournament(Tournament tournament);
}