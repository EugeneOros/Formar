class Match {
  final String? firstTeam;
  final String? secondTeam;
  List<Score> sets;

  Match({this.firstTeam, this.secondTeam, List<Score>? sets}) : this.sets = sets ?? [Score()];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Match &&
              runtimeType == other.runtimeType &&
              firstTeam == other.firstTeam &&
              secondTeam == other.secondTeam &&
              sets == other.sets;

  @override
  int get hashCode =>
      firstTeam.hashCode ^ secondTeam.hashCode ^ sets.hashCode;

  @override
  String toString() {
    return 'Match { firstTeam: $firstTeam, secondTeam: $secondTeam, sets: $sets}';
  }
}

class Score {
  final int? firstTeamPoints;
  final int? secondTeamPoints;

  Score({this.firstTeamPoints, this.secondTeamPoints});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Score &&
              runtimeType == other.runtimeType &&
              firstTeamPoints == other.firstTeamPoints &&
              secondTeamPoints == other.secondTeamPoints;

  @override
  int get hashCode =>
      firstTeamPoints.hashCode ^ secondTeamPoints.hashCode;

  @override
  String toString() {
    return 'Score { firstTeamPoints: $firstTeamPoints, secondTeamPoints: $secondTeamPoints}';
  }
}
