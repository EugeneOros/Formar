import 'package:people_repository/src/entities/entities.dart';
import 'package:people_repository/src/models/models.dart';

class Team {
  final String? id;
  final String? name;
  final List<Player> players;
  int? power;

  Team({String? id, this.name, this.power, List<Player>? players})
      : this.id = id, this.players = players == null ? [] : players;

  int? getPower(){
    return power;
  }

  Team copyWith({String? id, String? name, int? power, List<Player>? players}) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      power: power ?? this.power,
      players: players ?? this.players,
    );
  }

  void increasePower(int powerToAdd){
    if(this.power != null)
      this.power = this.power! + powerToAdd;
  }

  TeamEntity toEntity() {
    return TeamEntity(id, name, power, getPlayersIds());
  }

  List<String> getPlayersIds(){
    List<String> playersIds = [];
    for(Player player in players){
      playersIds.add(player.id!);
    }
    return playersIds;
  }

  static Team fromEntity(String? id, String? name, int? power, List<Player> players) {
    return Team(
      id: id,
      name: name,
      power: power,
      players: players,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              power == other.power &&
              players == other.players;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ power.hashCode ^ players.hashCode;


  @override
  String toString() {
    return 'Team { id: $id, name: $name, power: $power, players: $players }';
  }

}