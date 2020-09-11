import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/login/login.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc();
  ApiService api = ApiService();
  final _storage = FlutterSecureStorage();

  @override
  LoginScreenState get initialState => LoginScreenState();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    if (event is FetchEnvEvent) {
      yield* getEnv();
    } else if (event is LoginEvent) {
      yield* login(event.email, event.password);
    } else if (event is FetchLoginCredentialsEvent) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      String email = await storage.read(key: GlobalUtils.EMAIL) ?? '';
      String password = await storage.read(key: GlobalUtils.PASSWORD) ?? '';
      yield state.copyWith(email: email, password: password);
      yield LoadedCredentialsState(username: email, password: password);
    }
  }

  Stream<LoginScreenState> getEnv() async* {
    yield state.copyWith(isLoading: true);
    try {
      var obj = await api.getEnv();
      Env.map(obj);
      yield state.copyWith(isLoading: false,);
    } catch (error){
      print(onError.toString());
      yield state.copyWith(isLoading: false,);
      yield LoginScreenFailure(error: error.toString());
    }
  }

  Stream<LoginScreenState> login(String email, String password) async* {
    yield state.copyWith(isLoading: true);
    try {
      var obj = await api.getEnv();
      Env.map(obj);

      print('email => $email');
      print('password => $password');
      dynamic loginObj = await api.login(email, password);
      Token tokenData = Token.map(loginObj);

      final preferences = await SharedPreferences.getInstance();
      preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
      print('REFRESH TOKEN = ${tokenData.refreshToken}');

      await _storage.write(key: GlobalUtils.EMAIL, value: email);
      await _storage.write(key: GlobalUtils.PASSWORD, value: password);
      await _storage.write(key: GlobalUtils.REFRESH_TOKEN, value: tokenData.refreshToken);
      await _storage.write(key: GlobalUtils.TOKEN, value: tokenData.accessToken);

      GlobalUtils.activeToken = tokenData;

      yield state.copyWith(isLoading: false);
      yield LoginScreenSuccess();
    } catch (error){
      print(onError.toString());
      yield state.copyWith(isLoading: false,);
      yield LoginScreenFailure(error: error.toString());
    }
  }

}