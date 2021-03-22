import 'package:meta/meta.dart';
import 'package:people_repository/src/models/models.dart';
import '../entities/entities.dart';

class Team {
  final String? id;
  final String? name;
  // final List<String?> membersNames;
  final List<Person> players;
  int? _power;

  Team(this.name, this._power, {List<Person>? players, String? id})
      : this.id = id, this.players = players == null ? [] : players;

  Team copyWith({String? id, String? name, int? capacity, List<Person>? players}) {
    return Team(
      name ?? this.name,
      capacity ?? this._power,
      players: players ?? this.players,
      id: id ?? this.id,
    );
  }

  @override
  int get hashCode =>
      name.hashCode ^ _power.hashCode ^ players.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              _power == other._power &&
              players == other.players &&
              id == other.id;

  @override
  String toString() {
    return 'Team { name: $name, capacity: $_power, players: $players, id: $id }';
  }

  int? getPower(){
    return _power;
  }

  void increasePower(int powerToAdd){
    if(this._power != null)
      this._power = this._power! + powerToAdd;
  }


  TeamEntity toEntity() {
    return TeamEntity(name, _power, getPlayersIds(), id);
  }

  List<String> getPlayersIds(){
    List<String> playersNames = [];
    for(Person player in players){
      playersNames.add(player.id!);
    }
    return playersNames;
  }
  // int getPower(){
  // }

  static Team fromEntity(String? id, String? name, int? power, List<Person> players) {
    return Team(
      name,
      power,
      players: players,
      id: id,
    );
  }
}