import 'package:repositories/src/entities/entities.dart';

class Match {
  final String? id;
  final String? firstTeam;
  final String? secondTeam;
  final int? round;
  List<Score> sets;

  Match({String? id, this.firstTeam, this.secondTeam, this.round, List<Score>? sets})
      : this.id = id,
        this.sets = sets ?? [];

  Match copyWith({String? id, String? firstTeam, String? secondTeam, int? round, List<Score>? sets}) {
    return Match(
      id: id ?? this.id,
      firstTeam: firstTeam ?? this.firstTeam,
      secondTeam: secondTeam ?? this.secondTeam,
      round: round,
      sets: sets ?? this.sets,
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(id, firstTeam, secondTeam, round, getSetsStr());
  }

  List<String> getSetsStr() {
    List<String> setsStr = [];
    for (Score set in sets) {
      String setStr = set.firstTeamPoints.toString() + ":" + set.secondTeamPoints.toString();
      setsStr.add(setStr);
    }
    return setsStr;
  }

  static Match fromEntity(MatchEntity entity) {
    List<Score> sets = [];
    for (String setStr in entity.sets!) {
      List<String> setsStr = setStr.split(":");
      sets.add(Score(firstTeamPoints: setsStr[0] == "null" ? null : int.parse(setsStr[0]), secondTeamPoints:  setsStr[1] == "null" ? null : int.parse(setsStr[1])));
    }
    return Match(
      id: entity.id,
      firstTeam: entity.firstTeam,
      secondTeam: entity.secondTeam,
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
