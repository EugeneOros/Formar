import 'package:bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:meta/meta.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class LoginBloc extends Bloc<SettingsEvent, SettingsState> {
  final UserRepository _authService;

  LoginBloc({@required UserRepository authService})
      : assert(UserRepository != null),
        _authService = authService,
        super(LogOutInitialState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if(event is LogOutButtonPressedEvent){
      await _authService.signOut();
      yield LogOutSuccessfulState();
    }
  }
}