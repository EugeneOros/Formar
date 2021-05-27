import 'package:repositories/src/entities/entities.dart';

class Match {
  final String? id;
  final String? firstTeam;
  final String? secondTeam;
  List<Score> sets;

  Match({String? id, this.firstTeam, this.secondTeam, List<Score>? sets})
      : this.id = id,
        this.sets = sets ?? [];

  Match copyWith({String? id, String? firstTeam, String? secondTeam, List<Score>? sets}) {
    return Match(
      id: id ?? this.id,
      firstTeam: firstTeam ?? this.firstTeam,
      secondTeam: secondTeam ?? this.secondTeam,
      sets: sets ?? this.sets,
    );
  }

  MatchEntity toEntity() {
    return MatchEntity(id, firstTeam, secondTeam, getMatches());
  }

  List<String> getMatches() {
    List<String> playersIds = [];
    for (Score set in sets) {
      String setStr = set.firstTeamPoints.toString() + ":" + set.secondTeamPoints.toString();
      playersIds.add(setStr);
    }
    return playersIds;
  }

  static Match fromEntity(MatchEntity entity) {
    List<Score> sets = [];
    for (String setStr in entity.sets!) {
      List<String> setsStr = setStr.split(":");
      sets.add(Score(firstTeamPoints: int.parse(setsStr[0]), secondTeamPoints: int.parse(setsStr[1])));
    }
    return Match(
      id: entity.id,
      firstTeam: entity.firstTeam,
      secondTeam: entity.secondTeam,
      sets: sets,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Match &&
          runtimeType == other.runtimeType &&
          firstTeam == other.firstTeam &&
          id == other.id &&
          secondTeam == other.secondTeam &&
          sets == other.sets;

  @override
  int get hashCode => firstTeam.hashCode ^ id.hashCode ^ secondTeam.hashCode ^ sets.hashCode;

  @override
  String toString() {
    return 'Match { id: $id, firstTeam: $firstTeam, secondTeam: $secondTeam, sets: $sets}';
  }
}

class Score {
  final int firstTeamPoints;
  final int secondTeamPoints;

  Score({required this.firstTeamPoints, required this.secondTeamPoints});

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
