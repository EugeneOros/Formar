import 'package:bloc/bloc.dart';
import 'package:form_it/logic/services/auth.dart';
import 'package:meta/meta.dart';

import 'settings_event.dart';
import 'settings_state.dart';

class LoginBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthService _authService;

  LoginBloc({@required AuthService authService})
      : assert(AuthService != null),
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