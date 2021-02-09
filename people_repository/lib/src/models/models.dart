export 'person.dart';

import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Person {
  final bool complete;
  final String id;
  final String note;
  final String task;

  Person(this.task, {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id;

  Person copyWith({bool complete, String id, String note, String task}) {
    return Person(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Person &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;

  @override
  String toString() {
    return 'Todo { complete: $complete, task: $task, note: $note, id: $id }';
  }

  PeopleEntity toEntity() {
    return PeopleEntity(task, id, note, complete);
  }

  static Person fromEntity(PeopleEntity entity) {
    return Person(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}