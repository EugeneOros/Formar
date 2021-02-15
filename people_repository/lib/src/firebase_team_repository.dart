import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:people_repository/people_repository.dart';

// import '../team_repository.dart';
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
      // print(teams);

      return teams;
    });
  }

  @override
  Future<void> formTeams() async {
    User user = _auth.currentUser;
    int numMember = 6;
    bool fairSort = false;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("teams");
    teamsCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    List<Person> peopleOld = await peopleRepository.currentPeopleList();
    peopleOld = peopleOld.where((element) => element.available).toList();
    peopleOld.sort((a, b) => a.level.index.compareTo(b.level.index));
    peopleOld = peopleOld.reversed.toList();
    List<Person> people = [];
    for( Level level in Level.values){
      // print(level);
      people.addAll(peopleOld.where((element) => element.level == level).toList()..shuffle());
    }
    people = people.reversed.toList();

    List<Team> teams = [];
    int numTeams;
    if(fairSort)
      numTeams = (people.length / numMember).ceil();
    else
      numTeams = (people.length / numMember).floor();
    print(numTeams.toString());
    for (int i = 0; i < numTeams; i++) {
      teams.add(Team("Team " + (i + 1).toString(), 0, membersNames: []));
    }

    int indexTeam = 0;
    print(people);
    for (Person person in people) {
      if (indexTeam >= numTeams) {
        indexTeam = 0;
        teams.sort((a, b) => a.getPower().compareTo(b.getPower()));
        // print(teams);
      }
      int countFull = 0;
      while(teams[indexTeam].membersNames.length >= numMember){
        indexTeam++;
        countFull++;
        if (indexTeam >= numTeams) {
          indexTeam = 0;
        }
        if(countFull >= numTeams) {
          break;
        }
      }
      if(countFull >= numTeams) {
        break;
      }
      teams[indexTeam].membersNames.add(person.nickname);
      teams[indexTeam].increasePower(person.level.index + 1);
      indexTeam++;
    }
    if(fairSort == false &&  people.length % numMember != 0){
      List<String> membersNames = [];
      int power = 0;
      for(int i = people.length - people.length % numMember; i < people.length; i++){
        membersNames.add(people[i].nickname);
        power += people[i].level.index;
      }
      teams.add(Team("Replacement", power, membersNames: membersNames));
    }

    for (Team team in teams) {
      teamsCollection.add(team.toEntity().toDocument());
    }
  }
}
