import 'package:payever/models/token.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class LoginScreenContract {

  void onLoginSuccess(Token token);
  void onLoginError(String errorTxt);

}

class LoginScreenPresenter {
  
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);
  void doLogin(String username, String password) {
    api.login(username, password,GlobalUtils.fingerprint).then((dynamic token) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(GlobalUtils.EMAIL,    username);
      prefs.setString(GlobalUtils.PASSWORD, password);
      prefs.setString(GlobalUtils.TOKEN, token.accesstoken);
      prefs.setString(GlobalUtils.REFRESHTOKEN, token.refreshtoken);
      prefs.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
      print("REFRESH TOKEN = ${token.refreshtoken}");
      _view.onLoginSuccess(token);
    }).catchError((e){
      print(e);
      _view.onLoginError('Please enter credentials');
    });
  }
}