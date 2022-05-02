import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:repositories/repositories.dart';

part 'players_event.dart';

part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  final PlayersRepository peopleRepository;
  StreamSubscription? _peopleSubscription;
  StreamSubscription? _authenticationSubscription;

  PlayersBloc({
    required PlayersRepository peopleRepository,
    required AuthenticationBloc authenticationBloc,
  })  : peopleRepository = peopleRepository,
        super(PeopleLoading()) {
    _authenticationSubscription = authenticationBloc.stream.listen(
      (state) {
        if (state is AuthenticationStateAuthenticated) {
          add(LoadPlayers());
        }
      },
    );
    on<LoadPlayers>(_mapLoadPlayersToState);
    on<AddPlayer>(_mapAddPlayerToState);
    on<UpdatePlayer>(_mapUpdatePlayerToState);
    on<DeletePlayer>(_mapDeletePlayerToState);
    on<ToggleAll>(_mapToggleAllToState);
    on<ClearCompleted>(_mapClearCompletedToState);
    on<PlayersUpdated>(_mapPlayersUpdateToState);
    on<TurnOffPlayers>(_mapTurnOffPlayersToState);
  }

  void _mapLoadPlayersToState(LoadPlayers event, Emitter<PlayersState> emit) {
    _peopleSubscription?.cancel();
    _peopleSubscription = peopleRepository.players().listen(
          (people) => add(PlayersUpdated(people)),
        );
  }

  void _mapTurnOffPlayersToState(TurnOffPlayers event, Emitter<PlayersState> emit) {
    final PlayersState currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Player> availablePeople = currentState.people.where((person) => person.available).toList();
      availablePeople.forEach((person) {
        peopleRepository.updatePlayer(person.copyWith(available: !person.available));
      });
    }
  }

  void _mapAddPlayerToState(AddPlayer event, Emitter<PlayersState> emit) {
    peopleRepository.addNewPlayer(event.player);
  }

  void _mapUpdatePlayerToState(UpdatePlayer event, Emitter<PlayersState> emit) {
    peopleRepository.updatePlayer(event.updatedPlayer);
  }

  void _mapDeletePlayerToState(DeletePlayer event, Emitter<PlayersState> emit) {
    peopleRepository.deletePlayer(event.player);
  }

  void _mapToggleAllToState(ToggleAll event, Emitter<PlayersState> emit) {
    final PlayersState currentState = state;
    if (currentState is PeopleLoaded) {
      final allComplete = currentState.people.every((todo) => todo.available);
      final List<Player> updatedPeople = currentState.people.map((todo) => todo.copyWith(available: !allComplete)).toList();
      updatedPeople.forEach((updatedTodo) {
        peopleRepository.updatePlayer(updatedTodo);
      });
    }
  }

  void _mapClearCompletedToState(ClearCompleted event, Emitter<PlayersState> emit) {
    final PlayersState currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Player> completedPeople = currentState.people.where((person) => person.available).toList();
      completedPeople.forEach((completedTodo) {
        peopleRepository.deletePlayer(completedTodo);
      });
    }
  }

  void _mapPlayersUpdateToState(PlayersUpdated event, Emitter<PlayersState> emit) {
    emit(PeopleLoaded(event.players));
  }

  @override
  Future<void> close() {
    _peopleSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}
