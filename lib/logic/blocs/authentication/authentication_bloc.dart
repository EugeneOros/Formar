import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_it/logic/blocs/authentication/authentication_event.dart';
import 'package:form_it/logic/blocs/authentication/authentication_state.dart';
import 'package:user_repository/user_repository.dart';
import 'dart:async';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userReposetory;

  AuthenticationBloc({required UserRepository authService})
      : assert(UserRepository != null),
        _userReposetory = authService,
        super(AuthenticationStateInitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      yield AuthenticationStateInitialized();
      final isSignedIn = await _userReposetory.isSignedIn();
      if (isSignedIn) {
        final name = await _userReposetory.getUser();
        yield AuthenticationStateAuthenticated(name);
      } else {
        yield AuthenticationStateUnauthenticated();
      }
    } catch (_) {
      yield AuthenticationStateUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticationStateAuthenticated(await _userReposetory.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield AuthenticationStateUnauthenticated();
    _userReposetory.signOut();
  }

}



// Stream<AuthenticationState> _mapLoggedInToState() async* {
//   // yield Authenticated(await _authService.getUser());
// }
//
// Stream<AuthenticationState> _mapLoggedOutToState() async* {
//   yield UnauthenticatedState();
//   _authService.signOut();
// }
//
// Stream<AuthenticationState>  _mapAppStartedToState() async* {
//   yield UnauthenticatedState();
//   _authService.signOut();
// }
// }
