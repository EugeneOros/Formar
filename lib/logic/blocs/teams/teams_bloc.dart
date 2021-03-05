import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:meta/meta.dart';
import 'package:form_it/logic/blocs/people/bloc.dart';
import 'package:people_repository/people_repository.dart';

import 'bloc.dart';

class TeamsBloc extends Bloc<TeamsEvent, TeamsState> {
  final TeamRepository _teamsRepository;
  StreamSubscription _teamsSubscription;
  StreamSubscription _authenticationSubscription;
  final AuthenticationBloc _authenticationBloc;


  TeamsBloc(
      {@required TeamRepository teamsRepository, @required AuthenticationBloc authenticationBloc})
      : assert(teamsRepository != null),
        _authenticationBloc = authenticationBloc,
        _teamsRepository = teamsRepository,
        super(TeamsLoading()) {
    _authenticationSubscription = authenticationBloc.listen((state) {
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
    }
  }

  Stream<TeamsState> _mapLoadTeamsToState() async* {
    _teamsSubscription?.cancel();
    _teamsSubscription = _teamsRepository.teams().listen(
          (teams) => add(TeamsUpdated(teams)),
    );
  }

  Stream<TeamsState> _mapTeamsUpdateToState(TeamsUpdated event) async* {
    yield TeamsLoaded(event.teams);
  }

  Stream<TeamsState> _mapFormTeamsToState(FormTeams event) async* {
    _teamsRepository.formTeams(event.isBalanced, event.counterTeamMember);
  }

  @override
  Future<void> close() {
    _teamsSubscription?.cancel();
    _authenticationSubscription?.cancel();
    return super.close();
  }
}