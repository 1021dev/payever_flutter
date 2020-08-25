import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/version.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/global_keys.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:page_transition/page_transition.dart';

import '../switcher/switcher_page.dart';

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

class _LoginState extends State<Login> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool _isInvalidInformation = false;

  String _password, _username;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginScreenBloc loginScreenBloc = LoginScreenBloc(); // ignore: close_sinks

  @override
  void initState() {
    super.initState();
    loginScreenBloc.add(FetchLoginCredentialsEvent());
    String fingerPrint = '${Platform.operatingSystem}  ${Platform.operatingSystemVersion}';
    GlobalUtils.fingerprint = fingerPrint;
    SharedPreferences.getInstance().then((p) {
      p.setString(GlobalUtils.FINGERPRINT, fingerPrint);
    });
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      loginScreenBloc.add(LoginEvent(email: _username, password: _password));
    }
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
    return BlocListener(
        bloc: loginScreenBloc,
        listener: (BuildContext context, LoginScreenState state) async {
          if (state is LoginScreenFailure) {
            _isInvalidInformation = true;
          } else if (state is LoginScreenVersionFailed) {
            showPopUp(state.version);
          } else if (state is LoginScreenSuccess) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: SwitcherScreen(),
                )
            );
          } else if (state is LoadedCredentialsState) {
            emailController.text = state.username;
            passwordController.text = state.password;
          }
        },
        child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
            bloc: loginScreenBloc,
            builder: (BuildContext context, LoginScreenState state) {
              return Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://payever.azureedge.net/images/commerceos-background.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: Measurements.width,
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BlurEffectView (
                              padding: EdgeInsets.fromLTRB(12, 55, 12, 55),
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
                                            'assets/images/logo-payever-white.png')),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: (Measurements.height *
                                          (_isTablet
                                              ? _heightFactorTablet
                                              : _heightFactorPhone)
                                      ) / 1.5,
                                    ),
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
                                              'Your account information was entered incorrectly.',
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
                                                    topRight: Radius.circular(8.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: _paddingText,
                                                      right: _paddingText),
                                                  child: TextFormField(
                                                    controller: emailController,
                                                    enabled: !state.isLoading,
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
                                                      labelText: 'E-Mail Address',
                                                      labelStyle: TextStyle(
                                                        color: Colors.white70,
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding: _isTablet
                                                          ? EdgeInsets.all(
                                                          Measurements.height * 0.007,
                                                      )
                                                          : null,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                    keyboardType:
                                                    TextInputType.emailAddress,
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
                                                          controller: passwordController,
                                                          enabled: !state.isLoading,
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
                                                            labelText: 'Password',
                                                            labelStyle: TextStyle(
                                                              color: Colors.white70,
                                                            ),
                                                            border: InputBorder.none,
                                                            contentPadding: _isTablet
                                                                ? EdgeInsets.all(
                                                                Measurements.height *
                                                                    0.007,
                                                            )
                                                                : null,
                                                          ),
                                                          obscureText: true,
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
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
                                              bottomRight: Radius.circular(8.0),
                                            ),
                                          ),
                                          child: !state.isLoading
                                              ? InkWell(
                                            key: GlobalKeys.loginButton,
                                            child: Center(
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              print('login');
                                              _submit();
                                            },
                                          )
                                              : Center(
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ),
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
                                        'Forgot your password?',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 14,
                                          color: Color.fromRGBO(255, 255, 255, 0.6),
                                        ),
                                      ),
                                      onTap: () {
                                        _launchURL(GlobalUtils.FORGOT_PASS);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Container(
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
                                value: 'EN',
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
                                items: <String>['EN', 'DE', 'NR', 'PL', 'UK'].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
    );
  }

  showPopUp(Version _version ){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                  borderRadius:BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8,sigmaY: 16),
                    child: Container(
                      height: 200,
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Your App version is no longer supported."),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: Colors.white.withOpacity(0.15),
                                child: Text("Close"),
                                onPressed: (){
                                  exit(0);
                                },
                              ),
                              RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                color: Colors.white.withOpacity(0.2),
                                child: Text("Update"),
                                onPressed: (){
                                  _launchURL(_version.storeLink(Platform.operatingSystem.contains("ios")));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
              ),
            ),
          );
        }
        );
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
      resizeToAvoidBottomPadding: !_isPortrait,
    );
  }
}
