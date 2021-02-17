import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:people_repository/people_repository.dart';

import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/team.dart';

class FirebaseTeamRepository implements TeamRepository {
  final PeopleRepository peopleRepository;

  FirebaseTeamRepository({@required this.peopleRepository});

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Stream<List<Team>> teams() {
    User user = _auth.currentUser;
    CollectionReference teamsCollection = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("teams");

    return teamsCollection.snapshots().map((snapshot) {
      List<Team> teams;
      teams = snapshot.docs
          .map((doc) => Team.fromEntity(TeamEntity.fromSnapshot(doc)))
          .toList();
      teams.sort((a, b) => a.name.compareTo(b.name));
      return teams;
    });
  }

  @override
  Future<void> formTeams(bool isBalanced) async {
    User user = _auth.currentUser;
    int numMember = 6;
    List<Team> teams;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("teams");
    teamsCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    List<Person> people = _sortShuffleList(await peopleRepository.currentPeopleList());
    if(people.length < 2)
      return;

    if(!isBalanced && people.length / numMember > 2){
        teams = _createTeams((people.length / numMember).floor());
        teams = _sortPeopleToTeams(people.sublist(0,people.length-(people.length%numMember)), teams);
        if(people.length % numMember != 0 && people.length / numMember > 2){
          teams.add(_createTeamReplacement(people.sublist(people.length-(people.length%numMember), people.length)));
        }
    }else{
      teams = _createTeams(max((people.length / numMember).ceil(), 2));
      teams = _sortPeopleToTeams(people, teams);
    }

    for (Team team in teams)
      teamsCollection.add(team.toEntity().toDocument());
  }

  List<Person> _sortShuffleList(List<Person> people){
    people = people.where((element) => element.available).toList();
    people = people.reversed.toList();
    List<Person> result = [];
    for( Level level in Level.values){
      result.addAll(people.where((element) => element.level == level).toList()..shuffle());
    }
    return result.reversed.toList();
  }

  List<Team> _sortPeopleToTeams(List<Person> people, List<Team> teams){
    int indexTeam = 0;
    for (Person person in people) {
      if (indexTeam >= teams.length) {
        indexTeam = 0;
        teams.sort((a, b) => a.getPower().compareTo(b.getPower()));
      }
      teams[indexTeam].membersNames.add(person.nickname);
      teams[indexTeam].increasePower(person.level.index + 1);
      indexTeam++;
    }
    return teams;
  }

  Team _createTeamReplacement(List<Person> members){
    List<String> membersNames = [];
    int power = 0;
    for(Person member in members){
      membersNames.add(member.nickname);
      power += member.level.index;
    }
    return Team("Replacement", power, membersNames: membersNames);
  }

  List<Team> _createTeams(int numTeams){
    List<Team> teams = [];
    for (int i = 0; i < numTeams; i++) {
      teams.add(Team("Team " + (i + 1).toString(), 0, membersNames: []));
    }
    return teams;
  }
}
