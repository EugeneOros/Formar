import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:repositories/src/models/level.dart';
import 'package:repositories/src/models/sex.dart';

class PlayerEntity extends Equatable {
  final String? id;
  final String nickname;
  final Level level;
  final Sex sex;
  final bool available;

  PlayerEntity(this.id, this.nickname, this.level, this.sex,  this.available);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'level' : level,
      'sex' : sex,
      'available': available,
    };
  }

  static PlayerEntity fromJson(Map<String, Object> json) {
    return PlayerEntity(
      json['id'] as String,
      json['nickname'] as String,
      json['level'] as Level,
      json['sex'] as Sex,
      json['available'] as bool,
    );
  }

  static PlayerEntity fromSnapshot(DocumentSnapshot snap) {
    Level? level;
    Sex? sex;

    for(Level l in Level.values)
      if(snap['level'] == l.toString())
        level = l;

    for(Sex s in Sex.values)
      if(snap['sex'] == s.toString())
        sex = s;

    return PlayerEntity(
      snap.id,
      snap['nickname'],
      level ?? Level.beginner,
      sex ?? Sex.man,
      snap['available'],
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'nickname': nickname,
      'level': level.toString(),
      'sex' : sex.toString(),
      'available': available,
    };
  }

  @override
  List<Object?> get props => [ id, nickname, level, sex, available];

  @override
  String toString() {
    return 'PlayerEntity { id: $id, nickname: $nickname, level: $level, sex: $sex, available: $available }';
  }
}