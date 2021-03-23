import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TeamEntity extends Equatable {
  final String? id;
  final String name;
  final List<String>? playersIds;

  TeamEntity(this.id, this.name, this.playersIds);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'membersNames' : playersIds,
    };
  }


  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['id'] as String?,
      json['name'] as String,
      json['playersIds'] as List<String>?,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    return TeamEntity(
      snap.id,
      snap['name'],
      (snap['playersIds'] as List?)?.map((item) => item as String).toList(),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'playersIds': playersIds,
    };
  }

  @override
  List<Object?> get props => [id, name, playersIds];

  @override
  String toString() {
    return 'TeamEntity { id: $id, name: $name, playersIds: $playersIds }';
  }

}