import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:page_transition/page_transition.dart';

import '../../../models/models.dart';
import '../../../network/network.dart';
import '../../../utils/utils.dart';
import '../../custom_elements/custom_elements.dart';
import '../switcher/switcher_page.dart';
import 'login_page_controller.dart';

final double _heightFactorTablet = 0.05;
final double _heightFactorPhone = 0.07;
final double _widthFactorTablet = 2.0;
final double _widthFactorPhone = 1.1;

const double _paddingText = 16.0;

bool _isTablet = false;
bool _isPortrait = true;

final scaffoldKey = new GlobalKey<ScaffoldState>();
final formKey = new GlobalKey<FormState>();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login>
    implements LoginScreenContract, AuthStateListener {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  SharedPreferences _preferences;
  BuildContext _ctx;
  bool _isLoading = false;
  bool _isInvalidInformation = false;

  String _password, _username;
  LoginScreenPresenter _presenter;
  String password = GlobalUtils.pass;
  String email = GlobalUtils.mail;

  // VideoPlayerController _controller;
  // VideoPlayerController pl;
  // VideoPlayerController pp;
  // VideoPlayerController tl;
  // VideoPlayerController tp;
  _LoginState() {
    _presenter = LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _preferences = p;
      print(_preferences);
      String fingerPrint =
          "${Platform.operatingSystem}  ${Platform.operatingSystemVersion}";
      p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      // if(Platform.isAndroid){
      //     deviceInfo.androidInfo.then((info){
      //     fingerPrint = "Android (${info.version.release}) ${info.fingerprint} ${info.model}";
      //     p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      //   });
      // }else if(Platform.isIOS){
      //   deviceInfo.iosInfo.then((info){
      //     fingerPrint = "IOS (${info.systemVersion}) ${info.identifierForVendor} ${info.model}";
      //     p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      //     print("Fingerprint = $fingerPrint");
      //   });
      // }else if(Platform.isFuchsia){
      //   fingerPrint = "Fuchsia";
      //   p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      // }else if(Platform.isWindows){
      //   fingerPrint = "Windows";
      //   p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      // }else if(Platform.isMacOS){
      //   fingerPrint = "MacOS";
      //   p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      // }else if(Platform.isLinux){
      //   fingerPrint = "Linux";
      //   p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
      // }
    });

    // tp = VideoPlayerController.asset(
    //    'videos/tablet_portrait.mp4')
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     setState(() {
    //       tp.play();
    //     });
    //   });
    // tl = VideoPlayerController.asset(
    //     'videos/tablet_landscape.mp4')
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     setState(() {
    //       tl.play();
    //     });
    //   });
    // pp = VideoPlayerController.asset(
    //     'videos/phone_portrait.mp4')
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     setState(() {
    //       pp.play();
    //     });
    //   });

    //   pl = VideoPlayerController.asset(
    //    'videos/phone_landscape.mp4')
    //   ..setLooping(true)
    //   ..initialize().then((_) {
    //     setState(() {
    //       pl.play();
    //     });
    //   });
  }

  void _submit() {
    setState(() => _isLoading = true);
    final form = formKey.currentState;
    RestDataSource api = new RestDataSource();

    if (form.validate()) {
      form.save();
      api.getEnv().then((dynamic result) {
        Env.map(result);
        VersionController().checkVersion(context, () {
          _presenter.doLogin(_username, _password);
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "${Env.cdn}/images/commerceos-background.jpg"),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            top: (MediaQuery.of(context).size.height - 387) / 2,
            left: 7,
            width: MediaQuery.of(context).size.width - 14,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.fromLTRB(12, 55, 12, 55),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromRGBO(0, 0, 0, 0.4)),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                            width: Measurements.width /
                                ((_isTablet
                                    ? _widthFactorTablet
                                    : _widthFactorPhone) *
                                    2),
                            child: Image.asset(
                                "assets/images/logo-payever-white.png")),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: (Measurements.height *
                                (_isTablet
                                    ? _heightFactorTablet
                                    : _heightFactorPhone)) /
                                1.5),
                      ),
                      if (_isInvalidInformation)
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 8, 10),
                          decoration: BoxDecoration(
                            color: Color(0xffff644e),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  "Your account information was entered incorrectly.",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (_isInvalidInformation)
                        SizedBox(
                          height: 6,
                        ),
                      Form(
                        key: formKey,
                        child: Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 1.0),
                                  width: Measurements.width /
                                      (_isTablet
                                          ? _widthFactorTablet
                                          : _widthFactorPhone),
                                  height: 55,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.25),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8.0),
                                            topRight: Radius.circular(8.0))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: _paddingText,
                                          right: _paddingText),
                                      child: TextFormField(
                                        enabled: !_isLoading,
                                        onSaved: (val) => _username = val,
                                        onChanged: (val) {
                                          setState(() {
                                            _isInvalidInformation = false;
                                          });
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Username or email is required!';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Enter valid email address';
                                          }
                                          return null;
                                        },
                                        decoration: new InputDecoration(
                                          labelText: "E-Mail Address",
                                          border: InputBorder.none,
                                          contentPadding: _isTablet
                                              ? EdgeInsets.all(
                                              Measurements.height * 0.007)
                                              : null,
                                        ),
                                        style: TextStyle(fontSize: 16),
                                        keyboardType:
                                        TextInputType.emailAddress,
                                        initialValue: kDebugMode ? "testcases@payever.de" : email,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 1),
                                  width: Measurements.width /
                                      (_isTablet
                                          ? _widthFactorTablet
                                          : _widthFactorPhone),
                                  height: 55,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Container(
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: _paddingText,
                                                right: _paddingText),
                                            child: TextFormField(
                                              enabled: !_isLoading,
                                              onSaved: (val) => _password = val,
                                              onChanged: (val) {
                                                setState(() {
                                                  _isInvalidInformation = false;
                                                });
                                              },
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Password is required';
                                                }
                                                return null;
                                              },
                                              decoration: new InputDecoration(
                                                labelText: "Password",
                                                border: InputBorder.none,
                                                contentPadding: _isTablet
                                                    ? EdgeInsets.all(
                                                    Measurements.height *
                                                        0.007)
                                                    : null,
                                              ),
                                              obscureText: true,
                                              style: TextStyle(fontSize: 16),
                                              initialValue: kDebugMode ? "Payever123!" : password,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 1),
                            width: Measurements.width /
                                (_isTablet
                                    ? _widthFactorTablet
                                    : _widthFactorPhone),
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0))),
                              child: !_isLoading
                                  ? InkWell(
                                key: GlobalKeys.loginButton,
                                child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 16),
                                    )),
                                onTap: () {
                                  print("login");
                                  _submit();
                                },
                              )
                                  : Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            top: (Measurements.height *
                                (_isTablet
                                    ? _heightFactorTablet
                                    : _heightFactorPhone)) /
                                2),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(right: Measurements.width * 0.02),
                        child: InkWell(
                          child: Text(
                            "Forgot your password?",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                                color: Color.fromRGBO(255, 255, 255, 0.6)),
                          ),
                          onTap: () {
                            _launchURL(GlobalUtils.FORGOT_PASS);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 40,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Container(
              height: 30,
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: "EN",
                    isDense: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withAlpha(160),
                      size: 18,
                    ),
                    elevation: 4,
                    style: TextStyle(
                        color: Colors.white.withAlpha(160),
                        fontSize: 12
                    ),
                    underline: Container(),
                    onChanged: (val) {

                    },
                    items: <String>["EN", "DE", "NR", "PL", "UK"].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
//    _showSnackBar(errorTxt);
    setState(() {
      _isLoading = false;
      _isInvalidInformation = true;
    });
  }

  @override
  void onLoginSuccess(Token token) {
    setState(() => _isLoading = false);
    print("Success");
    var authStateProvider = AuthStateProvider();
    GlobalUtils.activeToken = token;
    authStateProvider.notify(AuthState.LOGGED_IN).then((bool r) {
      var authStateProvider = AuthStateProvider();
      authStateProvider.dispose(this);
    });
  }

  @override
  void onAuthStateChanged(AuthState state) {
    print("state");
    print(state);
    if (state == AuthState.LOGGED_IN) {
      //VersionController().checkVersion(context, (){
      Navigator.pushReplacement(
          _ctx,
          PageTransition(
              type: PageTransitionType.fade, child: SwitcherScreen()));
      //});
    }
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width < 600 ? false : true;
    return Scaffold(
      key: scaffoldKey,
      body: Login(),
      resizeToAvoidBottomPadding: false,
    );
  }
}
