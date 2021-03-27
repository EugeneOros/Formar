import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:meta/meta.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:repositories/repositories.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final PlayersRepository peopleRepository;
  StreamSubscription? _peopleSubscription;
  StreamSubscription? _authenticationSubscription;
  final AuthenticationBloc _authenticationBloc;

  PeopleBloc(
      {required PlayersRepository peopleRepository, required AuthenticationBloc authenticationBloc})
      : assert(peopleRepository != null),
        _authenticationBloc = authenticationBloc,
        peopleRepository = peopleRepository,
        super(PeopleLoading()) {
    _authenticationSubscription = authenticationBloc.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        add(LoadPeople());
      }
    });
  }


  @override
  Stream<PeopleState> mapEventToState(PeopleEvent event) async* {
    if (event is LoadPeople) {
      yield* _mapLoadPeopleToState();
    } else if (event is AddPerson) {
      yield* _mapAddPersonToState(event);
    } else if (event is UpdatePerson) {
      yield* _mapUpdatePersonToState(event);
    } else if (event is DeletePerson) {
      yield* _mapDeletePersonToState(event);
    } else if (event is ToggleAll) {
      yield* _mapToggleAllToState();
    } else if (event is ClearCompleted) {
      yield* _mapClearCompletedToState();
    } else if (event is PeopleUpdated) {
      yield* _mapPeopleUpdateToState(event);
    } else if (event is TurnOffPeople){
      yield* _mapTurnOffPeopleToState();
    }
  }

  Stream<PeopleState> _mapLoadPeopleToState() async* {
    _peopleSubscription?.cancel();
    _peopleSubscription = peopleRepository.players().listen(
          (people) => add(PeopleUpdated(people)),
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

  Stream<PeopleState> _mapAddPersonToState(AddPerson event) async* {
    peopleRepository.addNewPlayer(event.person);
  }

  Stream<PeopleState> _mapUpdatePersonToState(UpdatePerson event) async* {
    peopleRepository.updatePlayer(event.updatedPerson);
  }

  Stream<PeopleState> _mapDeletePersonToState(DeletePerson event) async* {
    peopleRepository.deletePlayer(event.person);
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

  Stream<PeopleState> _mapPeopleUpdateToState(PeopleUpdated event) async* {
    yield PeopleLoaded(event.people);
  }

  @override
  Future<void> close() {
    _peopleSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}