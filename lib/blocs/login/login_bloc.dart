import 'package:bloc/bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/login/login.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';

import '../bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc();
  ApiService api = ApiService();

  @override
  LoginScreenState get initialState => LoginScreenState();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    if (event is LoginEvent) {
      yield* login(event.email, event.password);
    }
  }

  Stream<LoginScreenState> login(String search, String password) async* {
    yield state.copyWith(isLoading: true);
    try {
      var obj = await api.getEnv();
      Env.map(obj);
      yield state.copyWith(isLoading: false);
      yield LoginScreenSuccess();
    } catch (error){
      print(onError.toString());
      yield state.copyWith(isLoading: false,);
      yield LoginScreenFailure(error: error.toString());
    }
  }

}