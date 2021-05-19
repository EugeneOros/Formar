import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:repositories/repositories.dart';

import 'bloc.dart';

class TournamentsBloc extends Bloc<TournamentsEvent, TournamentsState> {
  final TournamentRepository _tournamentsRepository;
  StreamSubscription? _tournamentsSubscription;
  StreamSubscription? _authenticationSubscription;


  TournamentsBloc(
      {required TournamentRepository tournamentsRepository, required AuthenticationBloc authenticationBloc})
      : _tournamentsRepository = tournamentsRepository,
        super(TournamentsLoading()) {
    _authenticationSubscription = authenticationBloc.stream.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        add(LoadTournaments());
      }
    });
  }


  @override
  Stream<TournamentsState> mapEventToState(TournamentsEvent event) async* {
    if (event is LoadTournaments) {
      yield* _mapLoadTeamsToState();
    }  else if (event is TournamentsUpdated) {
      yield* _mapTournamentsUpdateToState(event);
    }else if (event is FormMatches) {
      yield* _mapFormMatchesToState(event);
    }else if (event is AddTournament) {
      yield* _mapAddTournamentToState(event);
    }else if (event is UpdateTournament) {
      yield* _mapUpdateTournamentToState(event);
    }else if (event is DeleteTournament) {
      yield* _mapDeleteTournamentToState(event);
    }
  }

  Stream<TournamentsState> _mapLoadTeamsToState() async* {
    _tournamentsSubscription?.cancel();
    _tournamentsSubscription = _tournamentsRepository.tournaments().listen(
            (teams) {
          teams.sort((a, b) => a.name.compareTo(b.name));
          return add(TournamentsUpdated(teams));
        });
  }

  Stream<TournamentsState> _mapTournamentsUpdateToState(TournamentsUpdated event) async* {
    yield TournamentsLoaded(event.tournaments);
  }

  Stream<TournamentsState> _mapFormMatchesToState(FormMatches event) async* {
    // _teamsRepository.formTeams(event.isBalanced, event.counterTeamMember!, defaultReplacementName: event.defaultReplacementName, defaultTeamName: event.defaultTeamName);
  }

  Stream<TournamentsState> _mapAddTournamentToState(AddTournament event) async* {
    _tournamentsRepository.addTournament(event.tournament);
  }

  Stream<TournamentsState> _mapUpdateTournamentToState(UpdateTournament event) async* {
    _tournamentsRepository.updateTournament(event.updatedTournament);
  }

  Stream<TournamentsState> _mapDeleteTournamentToState(DeleteTournament event) async* {
    _tournamentsRepository.deleteTournament(event.tournament);
  }

  @override
  Future<void> close() {
    _tournamentsSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}