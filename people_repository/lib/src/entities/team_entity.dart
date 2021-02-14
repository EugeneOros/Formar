import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:people_repository/people_repository.dart';

class TeamEntity extends Equatable {
  final String id;
  final String name;
  final List<String> membersNames;
  final int capacity;

  TeamEntity(this.name, this.capacity, this.membersNames, this.id);

  Map<String, Object> toJson() {
    return {
      'name': name,
      'capacity': capacity,
      'membersNames' : membersNames,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'TeamEntity { name: $name, capacity: $capacity, membersNames: $membersNames, id: $id }';
  }

  static TeamEntity fromJson(Map<String, Object> json) {
    return TeamEntity(
      json['name'] as String,
      json['capacity'] as int,
      json['membersNames'] as List<String>,
      json['id'] as String,
    );
  }

  static TeamEntity fromSnapshot(DocumentSnapshot snap) {
    // snap.
    // Map<String, dynamic> map = Map<String, dynamic>();
    // map['membersNames'] = snap['membersNames'];
    return TeamEntity(
      snap['name'],
      snap['capacity'],
      (snap['membersNames'] as List)?.map((item) => item as String)?.toList(),
      snap.id,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'name': name,
      'capacity': capacity,
      'membersNames': membersNames,
    };
  }

  @override
  List<Object> get props => [name, capacity, membersNames, id];
}