import 'package:meta/meta.dart';
import '../entities/entities.dart';
import 'level.dart';

@immutable
class Person {
  final bool available;
  final String id;
  final String note;
  final String nickname;
  final Level level;

  Person(this.nickname, this.level, {this.available = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id;

  Person copyWith({bool complete, String id, String note, Level level, String task}) {
    return Person(
      task ?? this.nickname,
      level ?? this.level,
      available: complete ?? this.available,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  int get hashCode =>
      available.hashCode ^ nickname.hashCode ^ note.hashCode ^ id.hashCode ^ level.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Person &&
              runtimeType == other.runtimeType &&
              available == other.available &&
              nickname == other.nickname &&
              level == other.level &&
              note == other.note &&
              id == other.id;

  @override
  String toString() {
    return 'Todo { complete: $available, task: $nickname, note: $note, level: $level, id: $id }';
  }

  PeopleEntity toEntity() {
    return PeopleEntity(nickname, id, note, level, available);
  }

  static Person fromEntity(PeopleEntity entity) {
    return Person(
      entity.nickname,
      entity.level,
      available: entity.available ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}