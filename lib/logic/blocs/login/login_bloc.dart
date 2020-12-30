import 'package:bloc/bloc.dart';
import 'package:form_it/logic/services/auth.dart';
import 'package:meta/meta.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({@required AuthService authService})
      : assert(AuthService != null),
        _authService = authService,
        super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if(event is LoginButtonPressedEvent){
      try {
        yield LoginLoadingState();
        var user = await _authService.signInWithEmailAndPassword( event.email, event.password);
        yield LoginSuccessfulState(user: user);
      } catch (e) {
        yield LoginFailureState(massage: e.toString());
      }
    }
  }
}
