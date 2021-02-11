import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:people_repository/people_repository.dart';
import 'entities/entities.dart';

class FirebasePeopleRepository implements PeopleRepository {
  final peopleCollection = FirebaseFirestore.instance.collection('todos');

  @override
  Future<void> addNewPerson(Person todo) {
    return peopleCollection.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deletePerson(Person todo) async {
    return peopleCollection.document(todo.id).delete();
  }

  @override
  Stream<List<Person>> people() {
    return peopleCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Person.fromEntity(PeopleEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updatePerson(Person update) {
    return peopleCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }
}