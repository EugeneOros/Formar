import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'dart:async';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userReposetory;

  AuthenticationBloc({required UserRepository authService})
      : _userReposetory = authService,
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
      final isSignedIn = _userReposetory.isSignedIn();
      if (isSignedIn) {
        final name = _userReposetory.getUser();
        yield AuthenticationStateAuthenticated(name);
      } else {
        yield AuthenticationStateUnauthenticated();
      }
    } catch (_) {
      yield AuthenticationStateUnauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield AuthenticationStateAuthenticated(_userReposetory.getUser());
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
