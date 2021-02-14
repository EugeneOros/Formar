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

  // FirebaseUser user = await _auth.currentUser();
  // final CollectionReference peopleCollection = FirebaseFirestore.instance.collection('todos');

  // Future<CollectionReference> getPeopleCollection() async {
  //   User user = _auth.currentUser;
  //   return FirebaseFirestore.instance.collection(user.uid.toString());
  // }

  // @override
  // Future<void> addNewPerson(Person todo) async {
  //   User user = _auth.currentUser;
  //   CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
  //   return peopleCollection.add(todo.toEntity().toDocument());
  // }

  // @override
  // Future<void> deletePerson(Person todo) async {
  //   User user = _auth.currentUser;
  //   CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
  //   return peopleCollection.doc(todo.id).delete();
  // }

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
      return teams.reversed;
    });
    
  }

  // @override
  // Future<void> updatePerson(Person update) {
  //   User user = _auth.currentUser;
  //   CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
  //   return peopleCollection
  //       .doc(update.id)
  //       .update(update.toEntity().toDocument());
  // }

  @override
  Future<void> formTeams() async {
    User user = _auth.currentUser;
    int numMember = 6;
    CollectionReference teamsCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("teams");
    teamsCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    List<Person> people = await peopleRepository.currentPeopleList();
    people.sort((a, b) => a.level.index.compareTo(b.level.index));
    List<Team> teams = [];
    for (int i = 0; i <= people.length / numMember; i++) {
      teams.add(Team("Team" + i.toString(), numMember, membersNames: []));
    }

    for (Team team in teams) {
      team.membersNames.add("jo");
      teamsCollection.add(team.toEntity().toDocument());
    }

    // List<Person> list = peopleRepository.people();
  }
}
