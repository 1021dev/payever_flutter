import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/register/register.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc.dart';

class RegisterScreenBloc extends Bloc<RegisterScreenEvent, RegisterScreenState> {
  RegisterScreenBloc();
  ApiService api = ApiService();
  final _storage = FlutterSecureStorage();

  @override
  RegisterScreenState get initialState => RegisterScreenState();

  @override
  Stream<RegisterScreenState> mapEventToState(RegisterScreenEvent event) async* {
    if (event is RegisterEvent) {
      yield* register(event.firstName, event.lastName, event.email, event.password);
    } else if (event is FetchLoginCredentialsEvent) {
      FlutterSecureStorage storage = FlutterSecureStorage();
      String email = await storage.read(key: GlobalUtils.EMAIL) ?? '';
      String password = await storage.read(key: GlobalUtils.PASSWORD) ?? '';
      yield state.copyWith(email: email, password: password);
      // yield LoadedCredentialsState(username: email, password: password);
    }
  }


  Stream<RegisterScreenState> register(String firstName, String lastName, String email, String password) async* {
    yield state.copyWith(isRegister: true);
    try {
      print('firstName => $firstName');
      print('lastName => $lastName');
      print('email => $email');
      print('password => $password');
      dynamic registerObj = await api.registerUser(firstName,lastName, email, password);
      if (registerObj is DioError) {
        print(registerObj.toString());
        yield state.copyWith(isRegister: false,);
        yield RegisterScreenFailure(error: registerObj.message);
      } else {
        Token tokenData = Token.map(registerObj);

        final preferences = await SharedPreferences.getInstance();
        preferences.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
        print('REFRESH TOKEN = ${tokenData.refreshToken}');

        await _storage.write(key: GlobalUtils.EMAIL, value: email);
        await _storage.write(key: GlobalUtils.PASSWORD, value: password);
        await _storage.write(key: GlobalUtils.REFRESH_TOKEN, value: tokenData.refreshToken);
        await _storage.write(key: GlobalUtils.TOKEN, value: tokenData.accessToken);

        GlobalUtils.activeToken = tokenData;
        dynamic userObj = await api.postUser(tokenData.accessToken);
        User user = User.map(userObj);
        await _storage.write(key: GlobalUtils.USER_ID, value: user.id);
        yield state.copyWith(isRegister: false, isRegistered: true, user: user);
        yield RegisterScreenSuccess();
      }
    } catch (error){
      print(onError.toString());
      yield state.copyWith(isRegister: false,);
      yield RegisterScreenFailure(error: error.toString());
    }
  }

}