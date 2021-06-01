import 'package:repositories/repositories.dart';
import 'package:repositories/src/entities/entities.dart';

class Match {
  final String? id;
  final Team? firstTeam;
  final Team? secondTeam;
  final int? round;
  List<Score> sets;

  Match({String? id, this.firstTeam, this.secondTeam, this.round, List<Score>? sets})
      : this.id = id,
        this.sets = sets ?? [];

  Match copyWith({String? id, Team? firstTeam, Team? secondTeam, int? round, List<Score>? sets}) {
    return Match(
      id: id ?? this.id,
      firstTeam: firstTeam ?? this.firstTeam,
      secondTeam: secondTeam ?? this.secondTeam,
      round: round,
      sets: sets ?? this.sets,
    );
  }

  bool isCompleteSets(){
    for(Score score in sets){
      if(score.firstTeamPoints == null || score.secondTeamPoints == null)
        return false ;
    }
    return true;
  }

  MatchEntity toEntity() {
    return MatchEntity(id, firstTeam != null ? firstTeam!.id : "null", secondTeam != null ? secondTeam!.id : "null", round, getSetsStr());
  }

  List<String> getSetsStr() {
    List<String> setsStr = [];
    for (Score set in sets) {
      String setStr = set.firstTeamPoints.toString() + ":" + set.secondTeamPoints.toString();
      setsStr.add(setStr);
    }
    return setsStr;
  }

  static Match fromEntity(MatchEntity entity, List<Team> tournamentTeams) {
    List<Score> sets = [];
    Team? firstTeam;
    Team? secondTeam;
    for (String setStr in entity.sets!) {
      List<String> setsStr = setStr.split(":");
      sets.add(Score(firstTeamPoints: setsStr[0] == "null" ? null : int.parse(setsStr[0]), secondTeamPoints:  setsStr[1] == "null" ? null : int.parse(setsStr[1])));
    }
    for(Team team in tournamentTeams){

      if(team.id == entity.firstTeam)
        firstTeam = team;
      if(team.id == entity.secondTeam)
        secondTeam = team;
    }
    return Match(
      id: entity.id,
      firstTeam: firstTeam,
      secondTeam: secondTeam,
      round: entity.round,
      sets: sets,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstTeam == other.firstTeam &&
          secondTeam == other.secondTeam &&
          round == other.round &&
          sets == other.sets;

  @override
  int get hashCode => id.hashCode ^ firstTeam.hashCode  ^ secondTeam.hashCode ^ round.hashCode ^ sets.hashCode;

  @override
  String toString() {
    return 'Match { id: $id, firstTeam: $firstTeam, secondTeam: $secondTeam, round: $round, sets: $sets}';
  }
}

class Score {
  int? firstTeamPoints;
  int? secondTeamPoints;

  Score({ this.firstTeamPoints,  this.secondTeamPoints});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Score && runtimeType == other.runtimeType && firstTeamPoints == other.firstTeamPoints && secondTeamPoints == other.secondTeamPoints;

  @override
  int get hashCode => firstTeamPoints.hashCode ^ secondTeamPoints.hashCode;

  @override
  String toString() {
    return 'Score { firstTeamPoints: $firstTeamPoints, secondTeamPoints: $secondTeamPoints}';
  }
}
