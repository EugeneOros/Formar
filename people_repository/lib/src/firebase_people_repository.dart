import 'dart:async';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:people_repository/people_repository.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePeopleRepository implements PeopleRepository {
  // final FirebaseAuth _auth = ;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // FirebaseUser user = await _auth.currentUser();
  // final CollectionReference peopleCollection = FirebaseFirestore.instance.collection('todos');

  Future<CollectionReference> getPeopleCollection() async {
    User user = _auth.currentUser;
    return FirebaseFirestore.instance.collection(user.uid.toString());
  }

  @override
  Future<void> addNewPerson(Person person) async {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.add(person.toEntity().toDocument());
  }

  @override
  Future<void> deletePerson(Person todo) async {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Person>> people() {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.snapshots().map((snapshot) {
      List<Person> people = snapshot.docs
          .map((doc) => Person.fromEntity(PeopleEntity.fromSnapshot(doc)))
          .toList();
      people.sort((a, b) => a.compareTo(a.nickname.toUpperCase(), b.nickname.toUpperCase()));
      return people;
    });
  }

  Future<List<Person>> currentPeopleList() async {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    List<Person> people;
    // peopleCollection.snapshots().map((snapshot) {
    //    people = snapshot.docs
    //       .map((doc) => Person.fromEntity(PeopleEntity.fromSnapshot(doc)))
    //       .toList();
    //    // print(people);
    //   // people.sort((a, b) => a.level.index.compareTo(b.level.index));
    // });

    QuerySnapshot querySnapshot = await peopleCollection.getDocuments();
    people = querySnapshot.documents.map((doc) => Person.fromEntity(PeopleEntity.fromSnapshot(doc))).toList();
    print(people);
    return people;
  }


  @override
  Future<void> updatePerson(Person person) {
    User user = _auth.currentUser;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection
        .doc(person.id)
        .update(person.toEntity().toDocument());
  }
}