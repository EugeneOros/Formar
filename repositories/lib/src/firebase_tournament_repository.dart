import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repositories/repositories.dart';
import 'package:repositories/src/tournament_repository.dart';

import 'entities/entities.dart';

class FirebaseTournamentRepository implements TournamentRepository {
  final TeamRepository teamRepository;

  FirebaseTournamentRepository({required this.teamRepository});

  @override
  Stream<List<Tournament>> tournaments() {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.snapshots().asyncMap(_tournamentsFromSnapshot);
  }

  @override
  Future<void> updateTournament(Tournament tournament) async {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    CollectionReference matchesCollection = tournamentCollection.doc(tournament.id).collection("matches");
    // print(tournament.matches);

    // await matchesCollection.snapshots().forEach((element) {
    //   for (QueryDocumentSnapshot snapshot in element.docs) {
    //     snapshot.reference.delete();
    //   }
    // });
    List<Match> matchesUpdated = [];

    matchesCollection.get().then((value) {
      Match? matchUpdated;
      value.docs.forEach((element) {
        matchUpdated = null;
        for (Match match in tournament.matches) {
          if (match.id == element.id) {
            matchUpdated = match;
            matchesCollection.doc(element.id).update(match.toEntity().toDocument());
          }
        }
        if (matchUpdated == null) {
          matchesCollection.doc(element.id).delete().then((value) {
            print("Success!");
          });
        }else{
          matchesUpdated.add(matchUpdated!);
        }
      });
    }).then((value) {
      print("updated M");
      print(matchesUpdated);
      for (Match match in tournament.matches) {
        if(!matchesUpdated.contains(match)){
          matchesCollection.add(match.toEntity().toDocument());
        }
        // final snapShot = await matchesCollection.doc(match.id).get();
        // if (snapShot.exists) {
        //   matchesCollection.doc(match.id).update(match.toEntity().toDocument());
        // } else {
        // matchesCollection.add(match.toEntity().toDocument());
        // }
      }
    });

    return tournamentCollection.doc(tournament.id).update(tournament.toEntity().toDocument());
  }

  @override
  Future<DocumentReference> addTournament(Tournament tournament) async {
    print(tournament.matches);
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    Future<DocumentReference> result = tournamentCollection.add(tournament.toEntity().toDocument());
    DocumentReference tournamentReference = await result;
    DocumentSnapshot tournamentRSnapshot = await tournamentReference.get();
    var tournamentId = tournamentRSnapshot.reference.id;
    CollectionReference matchesCollection = tournamentCollection.doc(tournamentId).collection("matches");
    for (Match match in tournament.matches) {
      matchesCollection.add(match.toEntity().toDocument());
    }
    return result;
  }

  @override
  Future<void> deleteTournament(Tournament tournament) async {
    CollectionReference tournamentCollection = FirebaseFirestore.instance.collection("tournaments");
    return tournamentCollection.doc(tournament.id).delete();
  }

  Future<List<Tournament>> _tournamentsFromSnapshot(QuerySnapshot snapshot) async {
    List<Future<Tournament>> futures = snapshot.docs.map((doc) async {
      TournamentEntity tournamentEntity = TournamentEntity.fromSnapshot(doc);
      return Tournament.fromEntity(
          tournamentEntity, await _getTeamsByIds(tournamentEntity.teamsIds!), await currentMatchesList(tournamentEntity.id!));
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
