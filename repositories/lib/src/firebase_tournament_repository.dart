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
      return Tournament.fromEntity(tournamentEntity, await _getTeamsByIds(tournamentEntity.teamsIds!), await currentMatchesList(tournamentEntity.id!));
    }).toList();
    return await Future.wait(futures);
  }
  //
  // Future<List<Match>> currentMatchesList(tournamentId) async {
  //   User user = _auth.currentUser!;
  //   CollectionReference playersCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
  //   List<Player> players;
  //   QuerySnapshot querySnapshot = await playersCollection.get();
  //   players = querySnapshot.docs.map((doc) => Player.fromEntity(PlayerEntity.fromSnapshot(doc))).toList();
  //   return players;
  // }
  Future<List<Team>> _getTeamsByIds(List<String> playersIds) async {
    List<Team> teams = [];
    for (String teamId in playersIds) {
      teams.add(await teamRepository.getTeam(teamId) as Team);
    }
    return teams;
  }

  Future<List<Match>> currentMatchesList(String tournamentId) async {
    CollectionReference matchesCollection = FirebaseFirestore.instance.collection("tournaments").doc(tournamentId).collection("matches");
    List<Future<Match>> matches;
    QuerySnapshot querySnapshot = await matchesCollection.get();
    matches = querySnapshot.docs.map((doc) async {
      MatchEntity matchEntity = MatchEntity.fromSnapshot(doc);
      return Match.fromEntity(matchEntity);
    }).toList();

    return Future.wait(matches);
  }
}
