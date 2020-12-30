import 'package:bloc/bloc.dart';
import 'package:form_it/logic/blocs/signup/signup_event.dart';
import 'package:form_it/logic/blocs/signup/signup_state.dart';
import 'package:form_it/logic/services/auth.dart';
import 'package:meta/meta.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthService _authService;

  SignUpBloc({@required AuthService authService})
      : assert(AuthService != null),
        _authService = authService,
        super(SignUpInitialState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if(event is SignUpButtonPressedEvent){
      try {
        yield SignUpLoadingState();
        var user = await _authService.signUpWithEmailAndPassword( event.email, event.password);
        yield SignUpSuccessfulState(user: user);
      } catch (e) {
        yield SignUpFailureState(massage: e.toString());
      }
    }
  }
}
