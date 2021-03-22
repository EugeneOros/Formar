import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:people_repository/people_repository.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/team.dart';

class FirebaseTeamRepository implements TeamRepository {
  final PeopleRepository peopleRepository;

  FirebaseTeamRepository({required this.peopleRepository});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<List<Team>> teams(){
    User user = _auth.currentUser!;
    CollectionReference teamsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("teams");
    return teamsCollection.snapshots().asyncMap(_teamsFromSnapshot);

  }

  Future<List<Team>> _teamsFromSnapshot(QuerySnapshot snapshot) async{
    List<Future<Team>> futures = snapshot.docs.map((doc) async {
      TeamEntity teamEntity = TeamEntity.fromSnapshot(doc);
      return Team.fromEntity(teamEntity.id, teamEntity.name, teamEntity.power, await _getPeopleByIds(teamEntity.playersIds!));
    }).toList();
    return await Future.wait(futures);
  }


  @override
  Future<void> formTeams(bool isBalanced, int numMembers) async {
    User user = _auth.currentUser!;
    List<Team> teams;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("teams");
    teamsCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    List<Player> people = _sortShuffleList(await peopleRepository.currentPeopleList());
    if(people.length < 2)
      return;

    if(!isBalanced && people.length / numMembers >= 2){
        teams = _createTeams((people.length / numMembers).floor());
        teams = _sortPeopleToTeams(people.sublist(0,people.length-(people.length%numMembers)), teams);
        if(people.length % numMembers != 0 && people.length / numMembers > 2){
          teams.add(_createTeamReplacement(people.sublist(people.length-(people.length%numMembers), people.length)));
        }
    }else{
      teams = _createTeams(max((people.length / numMembers).ceil(), 2));
      teams = _sortPeopleToTeams(people, teams);
    }

    for (Team team in teams)
      teamsCollection.add(team.toEntity().toDocument());
  }

  Future<List<Player>> _getPeopleByIds(List<String> playersIds) async{
    List<Player> players = [];
    for(String playerId in playersIds){
      players.add(await peopleRepository.getPerson(playerId) as Player);
    }
    return players;
  }

  List<Player> _sortShuffleList(List<Player> people){
    people = people.where((element) => element.available ?? false).toList();
    people = people.reversed.toList();
    List<Player> result = [];
    for( Level level in Level.values){
      result.addAll(people.where((element) => element.level == level).toList()..shuffle());
    }
    return result.reversed.toList();
  }

  List<Team> _sortPeopleToTeams(List<Player> people, List<Team> teams){
    int indexTeam = 0;
    for (Player person in people) {
      if (indexTeam >= teams.length) {
        indexTeam = 0;
        teams.sort((a, b) => a.getPower()!.compareTo(b.getPower()!));
      }
      teams[indexTeam].players.add(person);
      teams[indexTeam].increasePower(person.level!.index + 1);
      indexTeam++;
    }
    return teams;
  }

  Team _createTeamReplacement(List<Player> players){
    int power = 0;
    for(Player member in players){
      power += member.level!.index;
    }
    return Team(name: "Replacement", power: power, players: players);
  }

  List<Team> _createTeams(int numTeams){
    List<Team> teams = [];
    for (int i = 0; i < numTeams; i++) {
      teams.add(Team(name: "Team " + (i + 1).toString(), power: 0, players: []));
    }
    return teams;
  }
}
