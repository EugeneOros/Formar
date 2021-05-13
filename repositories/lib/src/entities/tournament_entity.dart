import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentEntity {
  final String? id;
  final String name;
  final int winPoints;
  final int drawPoints;
  final int lossPoints;
  final int encountersNum;
  final List<String>? teamsIds;

  TournamentEntity(this.id, this.name, this.teamsIds, this.winPoints, this.drawPoints, this.lossPoints, this.encountersNum);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'teams': teamsIds,
      'winPoints': winPoints,
      'drawPoints': drawPoints,
      'lossPoints': lossPoints,
      'encountersNum': encountersNum,
    };
  }

  static TournamentEntity fromJson(Map<String, Object> json) {
    return TournamentEntity(
      json['id'] as String?,
      json['name'] as String,
      json['teamsIds'] as List<String>?,
      json['winPoints'] as int,
      json['drawPoints'] as int,
      json['lossPoints'] as int,
      json['encountersNum'] as int,
    );
  }

  static TournamentEntity fromSnapshot(DocumentSnapshot snap) {
    return TournamentEntity(
      snap.id,
      snap['name'],
      (snap['teamsIds'] as List?)?.map((item) => item as String).toList(),
      snap['winPoints'],
      snap['drawPoints'],
      snap['lossPoints'],
      snap['encountersNum'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'teamsIds': teamsIds,
      'winPoints': winPoints,
      'drawPoints': drawPoints,
      'lossPoints': lossPoints,
      'encountersNum': encountersNum,
    };
  }

  @override
  List<Object?> get props => [id, name, teamsIds, winPoints, drawPoints, lossPoints, encountersNum];

  @override
  String toString() {
    return 'TournamentEntity { id: $id, name: $name, teamsIds: $teamsIds, winPoints: $winPoints, drawPoints: $drawPoints, lossPoints: $lossPoints, encountersNum: $encountersNum }';
  }
}
