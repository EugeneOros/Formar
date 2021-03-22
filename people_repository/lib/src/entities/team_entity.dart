import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String? id;
  final String? name;
  final int? power;
  final List<String>? playersIds;

  TeamEntity(this.id, this.name, this.power, this.playersIds);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'capacity': power,
      'membersNames' : playersIds,
    };
  }


  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['id'] as String?,
      json['name'] as String?,
      json['power'] as int?,
      json['playersIds'] as List<String>?,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    return TeamEntity(
      snap.id,
      snap['name'],
      snap['power'],
      (snap['playersIds'] as List?)?.map((item) => item as String).toList(),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'power': power,
      'playersIds': playersIds,
    };
  }

  @override
  List<Object?> get props => [id, name, power, playersIds];

  @override
  String toString() {
    return 'TeamEntity { id: $id, name: $name, power: $power, playersIds: $playersIds }';
  }

}