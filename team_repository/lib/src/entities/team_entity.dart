import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:team_repository/src/models/level.dart';

class TeamEntity extends Equatable {
  final bool available;
  final String id;
  final String nickname;
  final Level level;

  TeamEntity(this.nickname, this.id,  this.level, this.available);

  Map<String, Object> toJson() {
    return {
      'available': available,
      'nickname': nickname,
      'level' : level,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'TodoEntity { available: $available, nickname: $nickname level: $level, id: $id }';
  }

  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['nickname'] as String,
      json['id'] as String,
      json['level'] as Level,
      json['available'] as bool,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    Level level;
    for(Level l in Level.values){
      if(snap['level'] == l.toString()){
        level = l;
      }
    }
    return TeamEntity(
      snap['nickname'],
      snap.id,
      level,
      snap['available'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'available': available,
      'nickname': nickname,
      'level': level.toString(),
    };
  }

  @override
  List<Object> get props => [available, id, level, nickname];
}