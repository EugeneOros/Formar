import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repositories/repositories.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/team.dart';

class FirebaseTeamRepository implements TeamRepository {
  final PlayersRepository peopleRepository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseTeamRepository({required this.peopleRepository});

  @override
  Stream<List<Team>> teams() {
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    return teamsCollection.snapshots().asyncMap(_teamsFromSnapshot);
  }

  @override
  Future<void> formTeams(bool isBalanced, int numMembers, {String? defaultTeamName, String? defaultReplacementName}) async {
    List<Team> teams;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    (await teamsCollection.get()).docs.length;

    List<Player> people = _sortShuffleList(await peopleRepository.currentPlayersList());
    if (people.length < 2) return;

    if(numMembers==1){
      teams = [];
      for (int i = 0; i < people.length; i++) {
        teams.add(Team(name: people[i].nickname, players: [people[i]]));
      }
      teams.forEach((team) {
        teamsCollection.add(team.toEntity().toDocument());
      });
      return;
    }

    if (!isBalanced && people.length / numMembers >= 2) {
      teams = _createTeams((people.length / numMembers).floor(), (await teamsCollection.get()).docs.length, defaultTeamName: defaultTeamName);
      teams = _sortPeopleToTeams(people.sublist(0, people.length - (people.length % numMembers)), teams);
      if (people.length % numMembers != 0 && people.length / numMembers > 2) {
        teams.add(_createTeamReplacement(
            people.sublist(people.length - (people.length % numMembers), people.length), defaultReplacementName: defaultReplacementName));
      }
    } else {
      teams = _createTeams(max((people.length / numMembers).ceil(), 2), (await teamsCollection.get()).docs.length, defaultTeamName: defaultTeamName);
      teams = _sortPeopleToTeams(people, teams);
    }

    teams.forEach((team) {
      team.players.sort((p1, p2) => p2.level.index.compareTo(p1.level.index));
      teamsCollection.add(team.toEntity().toDocument());
    });
  }

  @override
  Future<void> updateTeam(Team team) {
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    return teamsCollection.doc(team.id).update(team.toEntity().toDocument());
  }

  @override
  Future<DocumentReference> addTeam(Team team) async {
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    return teamsCollection.add(team.toEntity().toDocument());
  }

  @override
  Future<void> deleteTeam(Team team) async {
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    return teamsCollection.doc(team.id).delete();
  }

  @override
  Future<void> deleteAll() async {
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("teams");
    teamsCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<List<Team>> _teamsFromSnapshot(QuerySnapshot snapshot) async {
    List<Future<Team>> futures = snapshot.docs.map((doc) async {
      TeamEntity teamEntity = TeamEntity.fromSnapshot(doc);
      return Team.fromEntity(teamEntity.id, teamEntity.name, await _getPeopleByIds(teamEntity.playersIds!));
    }).toList();
    return await Future.wait(futures);
  }

  Future<List<Player>> _getPeopleByIds(List<String> playersIds) async {
    List<Player> players = [];
    for (String playerId in playersIds) {
      var player = await peopleRepository.getPlayer(playerId);
      if(player != null)
        players.add(player as Player);
    }
    return players;
  }

  List<Player> _sortShuffleList(List<Player> people) {
    people = people.where((element) => element.available).toList();
    people = people.reversed.toList();
    List<Player> result = [];
    for (Level level in Level.values) {
      result.addAll(people.where((element) => element.level == level).toList()
        ..shuffle());
    }
    return result.reversed.toList();
  }

  List<Team> _sortPeopleToTeams(List<Player> players, List<Team> teams) {
    List<Player> playersWoman = players.where((p) => p.sex == Sex.woman).toList();
    List<Player> playersMan = players.where((p) => p.sex == Sex.man).toList();

    for (int i = 0; i < players.length; i += teams.length) {
      if (i + teams.length <= playersMan.length) {
        for (int j = 0; j < teams.length; j++) {
          teams[j].players.add(playersMan[i + j]);
        }
        teams.sort((t1, t2) => t1.power.compareTo(t2.power));
      }
      if (i + teams.length <= playersWoman.length) {
        for (int j = 0; j < teams.length; j++) {
          teams[j].players.add(playersWoman[i + j]);
        }
        teams.sort((t1, t2) => t1.power.compareTo(t2.power));
      }
    }

    List<Player> remainderMen = playersMan.sublist((playersMan.length / teams.length).floor() * teams.length, playersMan.length);
    List<Player> remainderWomen = playersWoman.sublist((playersWoman.length / teams.length).floor() * teams.length, playersWoman.length);
    List<Player> remainder = _sortShuffleList(remainderWomen + remainderMen);

    int indexTeam = 0;
    teams.sort((t1, t2) => t1.power.compareTo(t2.power));
    for (Player player in remainder) {
      if (indexTeam >= teams.length) {
        indexTeam = 0;
        teams.sort((t1, t2) => t1.power.compareTo(t2.power));
      }
      teams[indexTeam].players.add(player);
      indexTeam++;
    }

    return teams;
  }

  Team _createTeamReplacement(List<Player> players, {String? defaultReplacementName}) {
    return Team(name: defaultReplacementName ?? "Replacement", players: players);
  }

  List<Team> _createTeams(int numTeams, int startWithNumber, {String? defaultTeamName}) {
    List<Team> teams = [];
    for (int i = 0; i < numTeams; i++) {
      teams.add(Team(name: (defaultTeamName ?? "Team") + " " + (i + startWithNumber + 1).toString(), players: []));
    }
    return teams;
  }

  Future<List<Team>> currentTeamsList() async {
    User user = _auth.currentUser!;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("teams");
    List<Future<Team>> teams;
    QuerySnapshot querySnapshot = await teamsCollection.get();
    teams = querySnapshot.docs.map((doc) async {
      TeamEntity teamEntity = TeamEntity.fromSnapshot(doc);
      return Team.fromEntity(teamEntity.id, teamEntity.name, await _getPeopleByIds(teamEntity.playersIds!));
    }).toList();

    return Future.wait(teams);
  }


  Future getTeam(String teamID) async {
    List<Team> teams = await currentTeamsList();
    for (Team t in teams) {
      if (t.id == teamID) {
        return t;
      }
    }
    return null;
  }
}
