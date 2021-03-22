import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:people_repository/src/models/level.dart';

class PlayerEntity extends Equatable {
  final String? id;
  final String nickname;
  final Level? level;
  final bool? available;

  PlayerEntity(this.id, this.nickname, this.level, this.available);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'level' : level,
      'available': available,
    };
  }

  static PlayerEntity fromJson(Map<String, Object> json) {
    return PlayerEntity(
      json['id'] as String,
      json['nickname'] as String,
      json['level'] as Level?,
      json['available'] as bool,
    );
  }

  static PlayerEntity fromSnapshot(DocumentSnapshot snap) {
    Level? level;
    for(Level l in Level.values){
      if(snap['level'] == l.toString()){
        level = l;
      }
    }
    return PlayerEntity(
      snap.id,
      snap['nickname'],
      level,
      snap['available'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'nickname': nickname,
      'level': level.toString(),
      'available': available,
    };
  }

  @override
  List<Object?> get props => [ id, nickname, level, available];

  @override
  String toString() {
    return 'PlayerEntity { id: $id, nickname: $nickname, level: $level, available: $available }';
  }
}