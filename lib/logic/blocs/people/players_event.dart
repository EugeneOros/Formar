import 'package:equatable/equatable.dart';
import 'package:repositories/repositories.dart';

abstract class PlayersEvent extends Equatable {
  const PlayersEvent();

  @override
  List<Object> get props => [];
}

class LoadPlayers extends PlayersEvent {}

class TurnOffPlayers extends PlayersEvent {}

class AddPlayer extends PlayersEvent {
  final Player player;

  const AddPlayer(this.player);

  @override
  List<Object> get props => [player];

  @override
  String toString() => 'AddPlayer { player: $player }';
}

class UpdatePlayer extends PlayersEvent {
  final Player updatedPlayer;

  const UpdatePlayer(this.updatedPlayer);

  @override
  List<Object> get props => [updatedPlayer];

  @override
  String toString() => 'UpdatePlayer { updatedPlayer: $updatedPlayer }';
}



class DeletePlayer extends PlayersEvent {
  final Player player;

  const DeletePlayer(this.player);

  @override
  List<Object> get props => [player];

  @override
  String toString() => 'DeletePlayer { player: $player }';
}

class ClearCompleted extends PlayersEvent {}

class ToggleAll extends PlayersEvent {}

class PlayersUpdated extends PlayersEvent {
  final List<Player> players;

  const PlayersUpdated(this.players);

  @override
  List<Object> get props => [players];
}