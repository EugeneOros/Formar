import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PeopleEntity extends Equatable {
  final bool complete;
  final String id;
  final String note;
  final String task;

  PeopleEntity(this.task, this.id, this.note, this.complete);

  Map<String, Object> toJson() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'TodoEntity { complete: $complete, task: $task, note: $note, id: $id }';
  }

  static PeopleEntity fromJson(Map<String, Object> json) {
    return PeopleEntity(
      json['task'] as String,
      json['id'] as String,
      json['note'] as String,
      json['complete'] as bool,
    );
  }

  static PeopleEntity fromSnapshot(DocumentSnapshot snap) {
    return PeopleEntity(
      snap['task'],
      snap.id,
      snap['note'],
      snap['complete'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'complete': complete,
      'task': task,
      'note': note,
    };
  }

  @override
  List<Object> get props => [complete, id, note, task];
}