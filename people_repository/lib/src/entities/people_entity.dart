import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:people_repository/src/models/level.dart';

class PeopleEntity extends Equatable {
  final bool available;
  final String id;
  final String note;
  final String nickname;
  final Level level;

  PeopleEntity(this.nickname, this.id, this.note, this.level, this.available);

  Map<String, Object> toJson() {
    return {
      'available': available,
      'nickname': nickname,
      'note': note,
      'level' : level,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'TodoEntity { available: $available, nickname: $nickname, note: $note, level: $level, id: $id }';
  }

  static PeopleEntity fromJson(Map<String, Object> json) {
    return PeopleEntity(
      json['nickname'] as String,
      json['id'] as String,
      json['note'] as String,
      json['level'] as Level,
      json['available'] as bool,
    );
  }

  static PeopleEntity fromSnapshot(DocumentSnapshot snap) {
    Level level;
    for(Level l in Level.values){
      if(snap['level'] == l.toString()){
        level = l;
      }
    }
    return PeopleEntity(
      snap['nickname'],
      snap.id,
      snap['note'],
      level,
      snap['available'],
    );
  }

  Map<String, Object> toDocument() {
    return {
      'available': available,
      'nickname': nickname,
      'note': note,
      'level': level.toString(),
    };
  }

  @override
  List<Object> get props => [available, id, note, level, nickname];
}