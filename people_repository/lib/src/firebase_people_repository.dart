import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:people_repository/people_repository.dart';
import 'entities/entities.dart';

class FirebasePeopleRepository implements PeopleRepository {
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  @override
  Future<void> addNewPerson(Person todo) {
    return todoCollection.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deletePerson(Person todo) async {
    return todoCollection.document(todo.id).delete();
  }

  @override
  Stream<List<Person>> people() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Person.fromEntity(PeopleEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updatePerson(Person update) {
    return todoCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }
}