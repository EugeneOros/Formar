import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

abstract class TournamentsState extends Equatable {
  const TournamentsState();

  @override
  List<Object> get props => [];
}

class TournamentsLoading extends TournamentsState {}

class TournamentsLoaded extends TournamentsState {
  final List<Tournament> tournaments;

  const TournamentsLoaded([this.tournaments = const []]);

  @override
  List<Object> get props => [tournaments];

  @override
  String toString() => 'TournamentsLoaded { tournaments: $tournaments }';
}

class TournamentsNotLoaded extends TournamentsState {}