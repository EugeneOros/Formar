import 'package:repositories/src/entities/entities.dart';
import 'package:repositories/src/models/models.dart';

class Tournament {
  final String? id;
  final String name;
  final List<Team> teams;
  final int winPoints;
  final int drawPoints;
  final int lossPoints;
  final int encountersNum;

  Tournament({String? id, required this.name, winPoints = 2, drawPoints = 1, lossPoints = 0, encountersNum = 1, List<Team>? teams})
      : this.id = id,
        this.teams = teams ?? [],
        this.winPoints = winPoints,
        this.drawPoints = drawPoints,
        this.lossPoints = lossPoints,
        this.encountersNum = encountersNum;

  Tournament copyWith({String? id, String? name, List<Player>? players}) {
    return Tournament(
        id: id ?? this.id,
        name: name ?? this.name,
        teams: teams,
        winPoints: winPoints,
        drawPoints: drawPoints,
        lossPoints: lossPoints,
        encountersNum: encountersNum);
  }

  TournamentEntity toEntity() {
    return TournamentEntity(id, name, getTeamsIds(), winPoints, drawPoints, lossPoints, encountersNum);
  }

  List<String> getTeamsIds() {
    List<String> teamsIds = [];
    for (Team team in teams) {
      teamsIds.add(team.id!);
    }
    return teamsIds;
  }

  static Tournament fromEntity(TournamentEntity tournamentEntity, List<Team> teams) {
    return Tournament(
      id: tournamentEntity.id,
      name: tournamentEntity.name,
      teams: teams,
      winPoints: tournamentEntity.winPoints,
      drawPoints: tournamentEntity.drawPoints,
      lossPoints: tournamentEntity.lossPoints,
      encountersNum: tournamentEntity.encountersNum,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tournament &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          teams == other.teams &&
          winPoints == other.winPoints &&
          drawPoints == other.drawPoints &&
          lossPoints == other.lossPoints &&
          encountersNum == other.encountersNum;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ teams.hashCode ^ winPoints.hashCode ^ drawPoints.hashCode ^ lossPoints.hashCode ^ encountersNum.hashCode;

  @override
  String toString() {
    return 'Tournament { id: $id, name: $name, teams: $teams, win points: $winPoints, drawPoints: $drawPoints, lossPoints: $lossPoints, encountersNum: $encountersNum }';
  }
}
