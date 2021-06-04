import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  final String? id;
  final String? firstTeam;
  final String? secondTeam;
  final int? round;
  final int? game;
  final List<String>? sets;

  MatchEntity(this.id, this.firstTeam, this.secondTeam, this.round, this.game, this.sets);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'firstTeam': firstTeam,
      'secondTeam' : secondTeam,
      'round' : round,
      'game' : game,
      'sets': sets
    };
  }

  static MatchEntity fromJson(Map<String, Object> json) {
    return MatchEntity(
      json['id'] as String?,
      json['firstTeam'] as String,
      json['secondTeam'] as String,
      json['round'] as int,
      json['game'] as int,
      json['sets'] as List<String>?,
    );
  }

  static MatchEntity fromSnapshot(DocumentSnapshot snap) {
    return MatchEntity(
      snap.id,
      snap['firstTeam'],
      snap['secondTeam'],
      snap['round'],
      snap['game'],
      (snap['sets'] as List?)?.map((item) => item as String).toList(),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'firstTeam': firstTeam,
      'secondTeam': secondTeam,
      'round': round,
      'game': game,
      'sets': sets,
    };
  }

  @override
  List<Object?> get props => [id, firstTeam, secondTeam, round, game, sets];

  @override
  String toString() {
    return 'TeamEntity { id: $id, firstTeam: $firstTeam, secondTeam: $secondTeam, round: $round, game: $game, sets: $sets }';
  }

}