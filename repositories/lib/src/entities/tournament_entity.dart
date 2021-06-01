import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TournamentEntity extends Equatable {
  final String? id;
  final String ownerId;
  final String name;
  final int winPoints;
  final int drawPoints;
  final int lossPoints;
  final int encountersNum;
  final List<String>? teamsIds;
  // final List<Match> matches;

  TournamentEntity(
      this.id, this.ownerId, this.name, this.teamsIds, this.winPoints, this.drawPoints, this.lossPoints, this.encountersNum);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'teams': teamsIds,
      'winPoints': winPoints,
      'drawPoints': drawPoints,
      'lossPoints': lossPoints,
      'encountersNum': encountersNum,
      // 'matches': matches,
    };
  }

  static TournamentEntity fromJson(Map<String, Object> json) {
    return TournamentEntity(
      json['id'] as String?,
      json['ownerId'] as String,
      json['name'] as String,
      json['teamsIds'] as List<String>?,
      json['winPoints'] as int,
      json['drawPoints'] as int,
      json['lossPoints'] as int,
      json['encountersNum'] as int,
      // json['matches'] as List<Match>,
    );
  }

  static TournamentEntity fromSnapshot(DocumentSnapshot snap) {
    return TournamentEntity(
      snap.id,
      snap['ownerId'],
      snap['name'],
      (snap['teamsIds'] as List?)?.map((item) => item as String).toList(),
      snap['winPoints'],
      snap['drawPoints'],
      snap['lossPoints'],
      snap['encountersNum'],
      // (snap['matches'] as List?)!.map((item) => item as Match).toList(),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'ownerId': ownerId,
      'teamsIds': teamsIds,
      'winPoints': winPoints,
      'drawPoints': drawPoints,
      'lossPoints': lossPoints,
      'encountersNum': encountersNum,
      // 'matches': matches,
    };
  }

  @override
  List<Object?> get props => [id, ownerId, name, teamsIds, winPoints, drawPoints, lossPoints, encountersNum];

  @override
  String toString() {
    return 'TournamentEntity { id: $id, ownerId: $ownerId, name: $name, teamsIds: $teamsIds, winPoints: $winPoints, drawPoints: $drawPoints, lossPoints: $lossPoints, encountersNum: $encountersNum }';
  }
}
