import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/tournament_repository.dart';

import 'entities/entities.dart';

class FirebaseTournamentRepository implements TournamentRepository {
  final TeamRepository teamRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseTournamentRepository({required this.teamRepository});

  @override
  Stream<List<Tournament>> tournaments() {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.snapshots().asyncMap(_tournamentsFromSnapshot);
  }

  @override
  Future<void> updateTournament(Tournament tournament) {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.doc(tournament.id).update(tournament.toEntity().toDocument());
  }

  @override
  Future<DocumentReference> addTournament(Tournament tournament) async {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.add(tournament.toEntity().toDocument());
  }

  @override
  Future<void> deleteTournament(Tournament tournament) async {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.doc(tournament.id).delete();
  }

  Future<List<Tournament>> _tournamentsFromSnapshot(QuerySnapshot snapshot) async {
    List<Future<Tournament>> futures = snapshot.docs.map((doc) async {
      TournamentEntity tournamentEntity = TournamentEntity.fromSnapshot(doc);
      return Tournament.fromEntity(tournamentEntity, await _getTeamsByIds(tournamentEntity.teamsIds!));
    }).toList();
    return await Future.wait(futures);
  }

  Future<List<Team>> _getTeamsByIds(List<String> playersIds) async {
    List<Team> teams = [];
    for (String teamId in playersIds) {
      teams.add(await teamRepository.getTeam(teamId) as Team);
    }
    return teams;
  }
}
