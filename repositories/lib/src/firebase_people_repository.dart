import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repositories/repositories.dart';
import 'entities/entities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasePeopleRepository implements PeopleRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<CollectionReference> getPeopleCollection() async {
    User user = _auth.currentUser!;
    return FirebaseFirestore.instance.collection(user.uid.toString());
  }

  @override
  Future<DocumentReference> addNewPerson(Player person) async {
    User user = _auth.currentUser!;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.add(person.toEntity().toDocument());
  }

  @override
  Future<void> deletePerson(Player todo) async {
    User user = _auth.currentUser!;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Player>> people() {
    User user = _auth.currentUser!;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection.snapshots().map((snapshot) {
      List<Player> people = snapshot.docs
          .map((doc) => Player.fromEntity(PlayerEntity.fromSnapshot(doc)))
          .toList();
      people.sort((a, b) => a.compareTo(a.nickname.toUpperCase(), b.nickname.toUpperCase()));
      return people;
    });
  }

  Future<List<Player>> currentPeopleList() async {
    User user = _auth.currentUser!;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    List<Player> people;
    QuerySnapshot querySnapshot = await peopleCollection.get();
    people = querySnapshot.docs.map((doc) => Player.fromEntity(PlayerEntity.fromSnapshot(doc))).toList();
    return people;
  }


  @override
  Future<void> updatePerson(Player person) {
    User user = _auth.currentUser!;
    CollectionReference peopleCollection = FirebaseFirestore.instance
        .collection("users").doc(user.uid).collection("peoples");
    return peopleCollection
        .doc(person.id)
        .update(person.toEntity().toDocument());
  }

  Future getPerson(String personID) async{
    List<Player> people = await currentPeopleList();
    for(Player p in people){
      if(p.id == personID){
        return p;
      }
    }
    return null;
  }
}