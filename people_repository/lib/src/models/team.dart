import 'package:meta/meta.dart';
import 'package:people_repository/src/models/models.dart';
import '../entities/entities.dart';
import 'level.dart';

class Team {
  List<Person> member;
  final bool available;
  final String id;
  final String nickname;
  final Level level;

  Team(this.nickname, this.level, {this.available = false, String note = '', String id})
      : this.id = id;

  Team copyWith({bool complete, String id, String note, Level level, String task}) {
    return Team(
      task ?? this.nickname,
      level ?? this.level,
      available: complete ?? this.available,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      available.hashCode ^ nickname.hashCode ^ id.hashCode ^ level.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              available == other.available &&
              nickname == other.nickname &&
              level == other.level &&
              id == other.id;

  @override
  String toString() {
    return 'Todo { complete: $available, task: $nickname, level: $level, id: $id }';
  }

  TeamEntity toEntity() {
    return TeamEntity(nickname, id, level, available);
  }

  static Team fromEntity(TeamEntity entity) {
    return Team(
      entity.nickname,
      entity.level,
      available: entity.available ?? false,
      id: entity.id,
    );
  }
}