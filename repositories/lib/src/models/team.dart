import 'package:repositories/src/entities/entities.dart';
import 'package:repositories/src/models/models.dart';

class Team {
  final String? id;
  final String name;
  final List<Player> players;

  Team({String? id,required this.name, List<Player>? players})
      : this.id = id, this.players = players ?? [];

  int get power{
    int power = 0;
    for(Player player in this.players){
      power += player.level.index + 1;
    }
    return power;
  }

  Team copyWith({String? id, String? name, List<Player>? players}) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
    );
  }

  TeamEntity toEntity() {
    return TeamEntity(id, name, getPlayersIds());
  }

  List<String> getPlayersIds(){
    List<String> playersIds = [];
    for(Player player in players){
      playersIds.add(player.id!);
    }
    return playersIds;
  }

  static Team fromEntity(String? id, String name, List<Player> players) {
    return Team(
      id: id,
      name: name,
      players: players,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Team &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode;


  @override
  String toString() {
    return 'Team { id: $id, name: $name, players: $players }';
  }

}