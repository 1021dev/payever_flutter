import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/models/version.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/global_keys.dart';
import 'package:payever/dashboard/fake_dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info/device_info.dart';
import 'package:page_transition/page_transition.dart';

import '../switcher/switcher_page.dart';

class RegisterInitScreen extends StatelessWidget {
  final LoginScreenBloc logInScreenBloc;

  const RegisterInitScreen({this.logInScreenBloc});

  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      loginScreenBloc: this.logInScreenBloc,
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final LoginScreenBloc loginScreenBloc;

  const RegisterScreen({this.loginScreenBloc});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final double _heightFactorTablet = 0.05;
  final double _heightFactorPhone = 0.07;
  final double _widthFactorTablet = 1.1;
  final double _widthFactorPhone = 1.1;

  double _paddingText = 16.0;

  bool _isTablet = false;
  bool _isPortrait = true;

  final formKey = new GlobalKey<FormState>();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool _isInvalidInformation = false;
  String _password, _username;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // ignore: close_sinks

  @override
  void initState() {
    super.initState();
  }

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
    if (_isTablet) Measurements.width = Measurements.width * 0.5;

    return BlocListener(
      bloc: widget.loginScreenBloc,
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
                child: SwitcherScreen(true),
              ));
        } else if (state is LoadedCredentialsState) {
          emailController.text = state.username;
          passwordController.text = state.password;
        }
      },
      child: BlocBuilder<LoginScreenBloc, LoginScreenState>(
          bloc: widget.loginScreenBloc,
          builder: (BuildContext context, LoginScreenState state) {
            return _getBody(state);
          }),
    );
  }

  Widget _getBody(LoginScreenState state) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _background(state),
            _loginBody(state),
            _selectLanguageBody(state),
          ],
        ),
      ),
    );
  }

  Widget _background(LoginScreenState state) {
    return Container(
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
      child: Stack(
        children: <Widget>[
          state.isLoading ? Container() : FakeDashboardScreen(),
        ],
      ),
    );
  }

  Widget _loginBody(LoginScreenState state) {
    return Container(
      width: Measurements.width /
          (_isTablet ? _widthFactorPhone : _widthFactorPhone),
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    width: Measurements.width /
                        ((_isTablet ? _widthFactorTablet : 1.5) * 2),
                    child: Image.asset(
                        'assets/images/logo-payever-${GlobalUtils.theme == 'light' ? 'black' : 'white'}.png')),
                Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 28),
                  child: Text(
                    'Setup your business',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 1.0),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GlobalUtils.theme == 'light'
                                ? Colors.white
                                : Colors.black.withOpacity(0.7),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: _paddingText, right: _paddingText),
                            child: TextFormField(
                              controller: firstNameController,
                              enabled: !state.isLogIn,
                              onSaved: (val) => _username = val,
                              onChanged: (val) {
                                setState(() {
                                  _isInvalidInformation = false;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Name is required!';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                labelText: 'First Name',
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                        Measurements.height * 0.007,
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        width: Measurements.width /
                            (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GlobalUtils.theme == 'light'
                                ? Colors.white
                                : Colors.black.withOpacity(0.7),
                            shape: BoxShape.rectangle,
                          ),
                          child: Container(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: _paddingText, right: _paddingText),
                                  child: TextFormField(
                                    controller: passwordController,
                                    enabled: !state.isLogIn,
                                    onSaved: (val) => _password = val,
                                    onChanged: (val) {
                                      setState(() {
                                        _isInvalidInformation = false;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Name is required';
                                      }
                                      return null;
                                    },
                                    decoration: new InputDecoration(
                                      labelText: 'Last Name',
                                      border: InputBorder.none,
                                      contentPadding: _isTablet
                                          ? EdgeInsets.all(
                                              Measurements.height * 0.007,
                                            )
                                          : null,
                                    ),
                                    obscureText: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1.0),
                        height: 55,
                        child: Container(
                          color: GlobalUtils.theme == 'light'
                              ? Colors.white
                              : Colors.black.withOpacity(0.7),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: _paddingText, right: _paddingText),
                            child: TextFormField(
                              controller: emailController,
                              enabled: !state.isLogIn,
                              onSaved: (val) => _username = val,
                              onChanged: (val) {
                                setState(() {
                                  _isInvalidInformation = false;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email is required!';
                                }
                                if (!value.contains('@')) {
                                  return 'Enter valid email address';
                                }
                                return null;
                              },
                              decoration: new InputDecoration(
                                labelText: 'Email',
                                border: InputBorder.none,
                                contentPadding: _isTablet
                                    ? EdgeInsets.all(
                                        Measurements.height * 0.007,
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 1),
                        width: Measurements.width /
                            (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GlobalUtils.theme == 'light'
                                ? Colors.white
                                : Colors.black.withOpacity(0.7),
                            shape: BoxShape.rectangle,
                          ),
                          child: Container(
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: _paddingText, right: _paddingText),
                                  child: TextFormField(
                                    controller: passwordController,
                                    enabled: !state.isLogIn,
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
                                      border: InputBorder.none,
                                      contentPadding: _isTablet
                                          ? EdgeInsets.all(
                                              Measurements.height * 0.007,
                                            )
                                          : null,
                                    ),
                                    obscureText: true,
                                    style: TextStyle(
                                      fontSize: 16,
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
                        (_isTablet ? _widthFactorPhone : _widthFactorPhone),
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(47, 47, 47, 1),
                            Color.fromRGBO(0, 0, 0, 1)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      child: InkWell(
                        key: GlobalKeys.loginButton,
                        child: Center(
                          child: Text(
                            'Next Step',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 19, bottom: 16),
                  height: 104,
                  decoration: BoxDecoration(
                    color: GlobalUtils.theme == 'light'
                        ? Colors.white
                        : Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.0),
                  child: Text(
                    'By registering you agree to payever Terms of Service and have read the Privacy Policy',
                    style: TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectLanguageBody(LoginScreenState state) {
    return Container(
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
                style:
                    TextStyle(color: Colors.white.withAlpha(160), fontSize: 12),
                underline: Container(),
                onChanged: (val) {},
                items: <String>['EN', 'DE', 'NR', 'PL', 'UK']
                    .map<DropdownMenuItem<String>>((String value) {
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
    );
  }

  showPopUp(Version _version) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              backgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 16),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.white.withOpacity(0.15),
                              child: Text("Close"),
                              onPressed: () {
                                exit(0);
                              },
                            ),
                            RaisedButton(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              color: Colors.white.withOpacity(0.2),
                              child: Text("Update"),
                              onPressed: () {
                                _launchURL(_version.storeLink(
                                    Platform.operatingSystem.contains("ios")));
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
        });
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      widget.loginScreenBloc
          .add(LoginEvent(email: _username, password: _password));
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
