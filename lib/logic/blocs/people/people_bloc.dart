import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:repositories/repositories.dart';

class PeopleBloc extends Bloc<PlayersEvent, PeopleState> {
  final PlayersRepository peopleRepository;
  StreamSubscription? _peopleSubscription;
  StreamSubscription? _authenticationSubscription;

  PeopleBloc(
      {required PlayersRepository peopleRepository, required AuthenticationBloc authenticationBloc})
      : peopleRepository = peopleRepository,
        super(PeopleLoading()) {
    _authenticationSubscription = authenticationBloc.stream.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        add(LoadPlayers());
      }
    });
  }


  @override
  Stream<PeopleState> mapEventToState(PlayersEvent event) async* {
    if (event is LoadPlayers) {
      yield* _mapLoadPeopleToState();
    } else if (event is AddPlayer) {
      yield* _mapAddPersonToState(event);
    } else if (event is UpdatePlayer) {
      yield* _mapUpdatePersonToState(event);
    } else if (event is DeletePlayer) {
      yield* _mapDeletePersonToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } else if (event is PlayersUpdated) {
      yield* _mapPeopleUpdateToState(event);
    } else if (event is TurnOffPlayers){
      yield* _mapTurnOffPeopleToState();
    }
  }

  Stream<PeopleState> _mapLoadPeopleToState() async* {
    _peopleSubscription?.cancel();
    _peopleSubscription = peopleRepository.players().listen(
          (people) => add(PlayersUpdated(people)),
    );
  }

  Stream<PeopleState> _mapTurnOffPeopleToState() async* {
    final PeopleState currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Player> availablePeople =
      currentState.people.where((person) => person.available).toList();
      availablePeople.forEach((person) {
        peopleRepository.updatePlayer(person.copyWith(available: !person.available));
      });
    }
  }

  Stream<PeopleState> _mapAddPersonToState(AddPlayer event) async* {
    peopleRepository.addNewPlayer(event.player);
  }

  Stream<PeopleState> _mapUpdatePersonToState(UpdatePlayer event) async* {
    peopleRepository.updatePlayer(event.updatedPlayer);
  }

  Stream<PeopleState> _mapDeletePersonToState(DeletePlayer event) async* {
    peopleRepository.deletePlayer(event.player);
  }

  Stream<PeopleState> _mapToggleAllToState() async* {
    final PeopleState currentState = state;
    if (currentState is PeopleLoaded) {
      final allComplete = currentState.people.every((todo) => todo.available);
      final List<Player> updatedPeople = currentState.people
          .map((todo) => todo.copyWith(available: !allComplete))
          .toList();
      updatedPeople.forEach((updatedTodo) {
        peopleRepository.updatePlayer(updatedTodo);
      });
    }
  }

  Stream<PeopleState> _mapClearCompletedToState() async* {
    final PeopleState currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Player> completedPeople =
      currentState.people.where((person) => person.available).toList();
      completedPeople.forEach((completedTodo) {
        peopleRepository.deletePlayer(completedTodo);
      });
    }
  }

  Stream<PeopleState> _mapPeopleUpdateToState(PlayersUpdated event) async* {
    yield PeopleLoaded(event.players);
  }

  @override
  Future<void> close() {
    _peopleSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}