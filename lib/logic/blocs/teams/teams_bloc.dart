import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:repositories/repositories.dart';

part 'teams_event.dart';
part 'teams_state.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  final TeamRepository _teamsRepository;
  StreamSubscription? _teamsSubscription;
  StreamSubscription? _authenticationSubscription;


  TeamsBloc(
      {required TeamRepository teamsRepository, required AuthenticationBloc authenticationBloc})
      : _teamsRepository = teamsRepository,
        super(TeamsLoading()) {
    _authenticationSubscription = authenticationBloc.stream.listen((state) {
      if (state is AuthenticationStateAuthenticated) {
        add(LoadTeams());
      }
    });
  }


  @override
  Stream<TeamsState> mapEventToState(TeamsEvent event) async* {
    if (event is LoadTeams) {
      yield* _mapLoadTeamsToState();
    }  else if (event is TeamsUpdated) {
      yield* _mapTeamsUpdateToState(event);
    }else if (event is FormTeams) {
      yield* _mapFormTeamsToState(event);
    }else if (event is AddTeam) {
      yield* _mapAddTeamToState(event);
    }else if (event is UpdateTeam) {
      yield* _mapUpdateTeamToState(event);
    }else if (event is DeleteTeam) {
      yield* _mapDeleteTeamToState(event);
    }else if (event is DeleteAll) {
      yield* _mapDeleteAllToState();
    }
  }

  Stream<TeamsState> _mapLoadTeamsToState() async* {
    _teamsSubscription?.cancel();
    _teamsSubscription = _teamsRepository.teams().listen(
          (teams) {
            teams.sort((a, b) => a.name.compareTo(b.name));
            return add(TeamsUpdated(teams));
          });
  }

  Stream<TeamsState> _mapTeamsUpdateToState(TeamsUpdated event) async* {
    yield TeamsLoaded(event.teams);
  }

  Stream<TeamsState> _mapFormTeamsToState(FormTeams event) async* {
    _teamsRepository.formTeams(event.isBalanced, event.counterTeamMember!, defaultReplacementName: event.defaultReplacementName, defaultTeamName: event.defaultTeamName);
  }

  Stream<TeamsState> _mapAddTeamToState(AddTeam event) async* {
    _teamsRepository.addTeam(event.team);
  }

  Stream<TeamsState> _mapUpdateTeamToState(UpdateTeam event) async* {
    _teamsRepository.updateTeam(event.updatedTeam);
  }

  Stream<TeamsState> _mapDeleteTeamToState(DeleteTeam event) async* {
    _teamsRepository.deleteTeam(event.team);
  }

  Stream<TeamsState> _mapDeleteAllToState() async* {
    _teamsRepository.deleteAll();
  }

  @override
  Future<void> close() {
    _teamsSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}