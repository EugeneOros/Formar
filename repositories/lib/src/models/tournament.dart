import 'package:repositories/src/entities/entities.dart';
import 'package:repositories/src/models/models.dart';

class Tournament {
  String? id;
  String ownerId;
  String name;
  List<Team> teams;
  int winPoints;
  int drawPoints;
  int lossPoints;
  int encountersNum;
  List<Match> matches;

  Tournament({
    String? id,
    required this.ownerId,
    required this.name,
    winPoints = 2,
    drawPoints = 1,
    lossPoints = 0,
    encountersNum = 1,
    List<Team>? teams,
    List<Match>? matches,
  })  : this.id = id,
        this.teams = teams ?? [],
        this.matches = matches ?? [],
        this.winPoints = winPoints,
        this.drawPoints = drawPoints,
        this.lossPoints = lossPoints,
        this.encountersNum = encountersNum;

  Tournament copyWith({
    String? id,
    String? ownerId,
    String? name,
    List<Team>? teams,
    List<Match>? matches,
    int? winPoints,
    int? drawPoints,
    int? lossPoints,
    int? encountersNum,
  }) {
    return Tournament(
        id: id ?? this.id,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        teams: teams,
        matches: matches,
        winPoints: winPoints,
        drawPoints: drawPoints,
        lossPoints: lossPoints,
        encountersNum: encountersNum);
  }

  TournamentEntity toEntity() {
    return TournamentEntity(id, ownerId, name, getTeamsIds(), winPoints, drawPoints, lossPoints, encountersNum);
  }

  // void _setStat(TeamStat teamStat){
  //   teamStat.matchPlayed ++;
  //   int firstTeamSetsCount = 0;
  //   int secondTeamSetsCount = 0;
  //   int firstTeamScoreCount = 0;
  //   int secondTeamScoreCount = 0;
  //   for (Score set in sets) {
  //     if (set.firstTeamPoints == null || set.secondTeamPoints == null) {
  //       return null;
  //     } else if (set.firstTeamPoints! > set.secondTeamPoints!) {
  //       firstTeamSetsCount++;
  //     } else if (set.firstTeamPoints! < set.secondTeamPoints!) {
  //       secondTeamSetsCount++;
  //     } else {
  //       firstTeamSetsCount++;
  //       secondTeamSetsCount++;
  //     }
  //   }
  // }

  static List<TeamStat> getLeaderList(
      {List<Match> matches = const [], List<Team> teams = const [], int pointsForWins = 2, pointsForDraw = 1, pointsForLoss = 0}) {
    List<TeamStat> teamsStats = [];
    for (Team team in teams) {
      teamsStats.add(TeamStat(team: team));
    }
    for (Match match in matches) {
      if (!match.isCompleteSets()) continue;
      int firstTeamSetsCount = 0;
      int secondTeamSetsCount = 0;
      int firstTeamScoreCount = 0;
      int secondTeamScoreCount = 0;
      for (Score set in match.sets) {
        firstTeamScoreCount += set.firstTeamPoints!;
        secondTeamScoreCount += set.secondTeamPoints!;
        if (set.firstTeamPoints! > set.secondTeamPoints!) {
          firstTeamSetsCount++;
        } else if (set.firstTeamPoints! < set.secondTeamPoints!) {
          secondTeamSetsCount++;
        } else {
          firstTeamSetsCount++;
          secondTeamSetsCount++;
        }
      }
      if (match.firstTeam != null && match.secondTeam != null) {
        for (TeamStat teamStat in teamsStats) {
          if (teamStat.team.id == match.firstTeam!.id) {
            teamStat.matchPlayed++;
            teamStat.wins += firstTeamSetsCount > secondTeamSetsCount ? 1 : 0;
            teamStat.draws += firstTeamSetsCount == secondTeamSetsCount ? 1 : 0;
            teamStat.losses += firstTeamSetsCount < secondTeamSetsCount ? 1 : 0;
            teamStat.setDifference += firstTeamSetsCount - secondTeamSetsCount;
            teamStat.pointsDifference += firstTeamScoreCount - secondTeamScoreCount;
          } else if (teamStat.team.id == match.secondTeam!.id) {
            teamStat.matchPlayed++;
            teamStat.wins += firstTeamSetsCount < secondTeamSetsCount ? 1 : 0;
            teamStat.draws += firstTeamSetsCount == secondTeamSetsCount ? 1 : 0;
            teamStat.losses += firstTeamSetsCount > secondTeamSetsCount ? 1 : 0;
            teamStat.setDifference += secondTeamSetsCount - firstTeamSetsCount;
            teamStat.pointsDifference += secondTeamScoreCount - firstTeamScoreCount;
          }
        }
      }
    }
    for (TeamStat teamStat in teamsStats) {
      teamStat.points =
          (teamStat.wins * pointsForWins).toInt() + (teamStat.draws * pointsForDraw).toInt() + (teamStat.losses * pointsForLoss).toInt();
    }
    // teams.
    teamsStats.sort((a, b) => b.points.compareTo(a.points));
    return teamsStats;
  }

  List<String> getTeamsIds() {
    List<String> teamsIds = [];
    for (Team team in teams) {
      teamsIds.add(team.id!);
    }
    return teamsIds;
  }

  static Tournament fromEntity(TournamentEntity tournamentEntity, List<Team> teams, List<Match> matches) {
    return Tournament(
      id: tournamentEntity.id,
      ownerId: tournamentEntity.ownerId,
      name: tournamentEntity.name,
      teams: teams,
      winPoints: tournamentEntity.winPoints,
      drawPoints: tournamentEntity.drawPoints,
      lossPoints: tournamentEntity.lossPoints,
      encountersNum: tournamentEntity.encountersNum,
      matches: matches,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tournament &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ownerId == other.ownerId &&
          name == other.name &&
          teams == other.teams &&
          matches == other.matches &&
          winPoints == other.winPoints &&
          drawPoints == other.drawPoints &&
          lossPoints == other.lossPoints &&
          encountersNum == other.encountersNum;

  @override
  int get hashCode =>
      id.hashCode ^
      ownerId.hashCode ^
      name.hashCode ^
      teams.hashCode ^
      matches.hashCode ^
      winPoints.hashCode ^
      drawPoints.hashCode ^
      lossPoints.hashCode ^
      encountersNum.hashCode;

  @override
  String toString() {
    return 'Tournament { id: $id, ownerId: $ownerId, name: $name, teams: $teams, matches: $matches win points: $winPoints, drawPoints: $drawPoints, lossPoints: $lossPoints, encountersNum: $encountersNum }';
  }
}

class TeamStat {
  int points;
  final Team team;
  int wins;
  int draws;
  int losses;
  int matchPlayed;
  int setDifference;
  int pointsDifference;
  int extraPoints;

  TeamStat(
      {required this.team,
      this.points = 0,
      this.wins = 0,
      this.draws = 0,
      this.losses = 0,
      this.matchPlayed = 0,
      this.setDifference = 0,
      this.pointsDifference = 0,
      this.extraPoints = 0});
}
