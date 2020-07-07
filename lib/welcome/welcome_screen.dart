import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/welcome/welcome_bloc.dart';
import 'package:payever/blocs/welcome/welcome_state.dart';
import 'package:payever/commons/commons.dart';
import 'package:provider/provider.dart';

bool _isPortrait;
bool _isTablet;

class WelcomeScreen extends StatefulWidget {
  final BusinessApps businessApps;
  final Business business;

  WelcomeScreen({this.business, this.businessApps,});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();

}

class _WelcomeScreenState extends State<WelcomeScreen> {

  WelcomeScreenBloc screenBloc = WelcomeScreenBloc();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
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

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, WelcomeScreenState state) async {
        if (state is WelcomeScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        } else if (state is WelcomeScreenStateSuccess) {
//          Provider.of<GlobalStateModel>(context,listen: false)
//              .setCurrentBusiness(state.business);
//          Provider.of<GlobalStateModel>(context,listen: false)
//              .setCurrentWallpaper('$wallpaperBase${state.wallpaper.currentWallpaper.wallpaper}');
//          Navigator.pop(context, 'changed');
        }
      },
      child: BlocBuilder<WelcomeScreenBloc, WelcomeScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, WelcomeScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(WelcomeScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: Container(
            child: Column(
              children: <Widget>[
                
              ],
            ),
          ),
        ),
      ),
    );
  }

}