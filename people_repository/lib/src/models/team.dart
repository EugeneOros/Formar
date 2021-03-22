import 'package:meta/meta.dart';
import 'package:people_repository/src/models/models.dart';
import '../entities/entities.dart';

class Team {
  final String? id;
  final String? name;
  final List<String?> membersNames;
  int? _power;

  Team(this.name, this._power, {List<String?>? membersNames, String? id})
      : this.id = id, this.membersNames = membersNames == null ? [] : membersNames;

  Team copyWith({String? id, String? name, int? capacity, List<String>? membersNames}) {
    return Team(
      name ?? this.name,
      capacity ?? this._power,
      membersNames: membersNames ?? this.membersNames,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ _power.hashCode ^ membersNames.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              _power == other._power &&
              membersNames == other.membersNames &&
              id == other.id;

  @override
  String toString() {
    return 'Team { name: $name, capacity: $_power, membersNames: $membersNames, id: $id }';
  }

  int? getPower(){
    return _power;
  }

  void increasePower(int powerToAdd){
    if(this._power != null)
      this._power = this._power! + powerToAdd;
  }


  TeamEntity toEntity() {
    return TeamEntity(name, _power, membersNames, id);
  }

  // int getPower(){
  // }

  static Team fromEntity(TeamEntity entity) {
    return Team(
      entity.name,
      entity.capacity,
      membersNames: entity.membersNames,
      id: entity.id,
    );
  }
}