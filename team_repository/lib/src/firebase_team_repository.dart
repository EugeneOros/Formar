import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team_repository/team_repository.dart';
// import '../team_repository.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePeopleRepository implements TeamRepository {
  // final FirebaseAuth _auth = ;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // FirebaseUser user = await _auth.currentUser();
  // final CollectionReference peopleCollection = FirebaseFirestore.instance.collection('todos');

  Future<CollectionReference> getPeopleCollection() async {
    User user = _auth.currentUser;
    return FirebaseFirestore.instance.collection(user.uid.toString());
  }

  @override
  Future<void> addNewPerson(Person todo) async {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deletePerson(Person todo) async {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Person>> teams() {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Person.fromEntity(TeamEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updatePerson(Person update) {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance.collection("users").doc(user.uid).collection("peoples");
    return peopleCollection
        .doc(update.id)
        .update(update.toEntity().toDocument());
  }

  @override
  Future<void> formTeams(Person todo) {
    // TODO: implement formTeams
    throw UnimplementedError();
  }
}