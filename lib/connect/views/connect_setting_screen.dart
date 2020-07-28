import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/connect/models/connect.dart';

bool _isPortrait;
bool _isTablet;

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class ConnectSettingScreen extends StatefulWidget {

  final ConnectScreenBloc screenBloc;
  final ConnectIntegration connectIntegration;

  ConnectSettingScreen({
    this.screenBloc,
    this.connectIntegration,
  });

  @override
  createState() => _ConnectSettingScreenState();
}

class _ConnectSettingScreenState extends State<ConnectSettingScreen> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ConnectSettingsDetailScreenBloc screenBloc;
  String wallpaper;
  String selectedState = '';
  int isOpened = 0;

  var imageData;

  @override
  void initState() {
    screenBloc = ConnectSettingsDetailScreenBloc(connectScreenBloc: widget.screenBloc);

    super.initState();
  }

  @override
  void dispose() {
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
      listener: (BuildContext context, ConnectSettingsDetailScreenState state) async {
        if (state is ConnectSettingsDetailScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ConnectSettingsDetailScreenBloc, ConnectSettingsDetailScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ConnectSettingsDetailScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(ConnectSettingsDetailScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Twilio',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.close,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _body(ConnectSettingsDetailScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      body: SafeArea(
        child: BackgroundBase(
          true,
          body: state.isLoading ?
          Center(
            child: CircularProgressIndicator(),
          ): Column(
            children: <Widget>[
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(ConnectSettingsDetailScreenState state) {
    return Container();
  }
}

