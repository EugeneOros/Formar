import 'package:meta/meta.dart';
import 'package:people_repository/src/models/models.dart';
import '../entities/entities.dart';

class Team {
  final String id;
  final String name;
  final List<String> membersNames;
  final int capacity;

  Team(this.name, this.capacity, {List<String> membersNames, String id})
      : this.id = id, this.membersNames = membersNames == null ? [] : membersNames;

  Team copyWith({String id, String name, int capacity, List<String> membersNames}) {
    return Team(
      name ?? this.name,
      capacity ?? this.capacity,
      membersNames: membersNames ?? this.membersNames,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ capacity.hashCode ^ membersNames.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              capacity == other.capacity &&
              membersNames == other.membersNames &&
              id == other.id;

  @override
  String toString() {
    return 'Team { name: $name, capacity: $capacity, membersNames: $membersNames, id: $id }';
  }

  TeamEntity toEntity() {
    return TeamEntity(name, capacity, membersNames, id);
  }

  static Team fromEntity(TeamEntity entity) {
    return Team(
      entity.name,
      entity.capacity,
      membersNames: entity.membersNames,
      id: entity.id,
    );
  }
}