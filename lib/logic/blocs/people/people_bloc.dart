import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:meta/meta.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:people_repository/people_repository.dart';

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  final PeopleRepository _peopleRepository;
  StreamSubscription _peopleSubscription;
  StreamSubscription _authenticationSubscription;
  final AuthenticationBloc _authenticationBloc;

  // StreamSubscription _peopleSubscription;

  PeopleBloc(
      {@required PeopleRepository peopleRepository, @required AuthenticationBloc authenticationBloc})
      : assert(peopleRepository != null),
        _authenticationBloc = authenticationBloc,
        _peopleRepository = peopleRepository,
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
    _peopleSubscription = _peopleRepository.people().listen(
          (people) => add(PeopleUpdated(people)),
    );
  }

  Stream<PeopleState> _mapTurnOffPeopleToState() async* {
    final currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Person> availablePeople =
      currentState.people.where((person) => person.available).toList();
      availablePeople.forEach((person) {
        _peopleRepository.updatePerson(person.copyWith(available: !person.available));
      });
    }
  }

  Stream<PeopleState> _mapAddPersonToState(AddPerson event) async* {
    _peopleRepository.addNewPerson(event.person);
  }

  Stream<PeopleState> _mapUpdatePersonToState(UpdatePerson event) async* {
    _peopleRepository.updatePerson(event.updatedPerson);
  }

  Stream<PeopleState> _mapDeletePersonToState(DeletePerson event) async* {
    _peopleRepository.deletePerson(event.person);
  }

  Stream<PeopleState> _mapToggleAllToState() async* {
    final currentState = state;
    if (currentState is PeopleLoaded) {
      final allComplete = currentState.people.every((todo) => todo.available);
      final List<Person> updatedPeople = currentState.people
          .map((todo) => todo.copyWith(available: !allComplete))
          .toList();
      updatedPeople.forEach((updatedTodo) {
        _peopleRepository.updatePerson(updatedTodo);
      });
    }
  }

  Stream<PeopleState> _mapClearCompletedToState() async* {
    final currentState = state;
    if (currentState is PeopleLoaded) {
      final List<Person> completedPeople =
      currentState.people.where((person) => person.available).toList();
      completedPeople.forEach((completedTodo) {
        _peopleRepository.deletePerson(completedTodo);
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