import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/pos_new/widgets/pos_top_button.dart';

bool _isPortrait;
bool _isTablet;

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class PosDevicePaymentSettings extends StatefulWidget {

  PosScreenBloc screenBloc;
  String businessId;

  PosDevicePaymentSettings({
    this.screenBloc,
    this.businessId,
  });

  @override
  createState() => _PosDevicePaymentSettingsState();
}

class _PosDevicePaymentSettingsState extends State<PosDevicePaymentSettings> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';
  bool isOpened = true;

  @override
  void initState() {
    widget.screenBloc.add(GetPosDevicePaymentSettings(businessId: widget.businessId));
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
      bloc: widget.screenBloc,
      listener: (BuildContext context, PosScreenState state) async {
        if (state is PosScreenFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PosScreenBloc, PosScreenState>(
        bloc: widget.screenBloc,
        builder: (BuildContext context, PosScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _appBar(PosScreenState state) {
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black87,
      title: Row(
        children: <Widget>[
          Text(
            'Device Payment',
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

  Widget _body(PosScreenState state) {
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
              _toolBar(state),
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolBar(PosScreenState state) {
    return Container(
      height: 44,
      color: Colors.black87,
      child: Container(),
    );
  }

  Widget _getBody(PosScreenState state) {
    if (state.devicePaymentSettings == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    List<Communication> communications = state.communications;
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: isOpened ? 64 * 5.0: 64.0,
        child: BlurEffectView(
          color: Color.fromRGBO(20, 20, 20, 0.2),
          blur: 15,
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: <Widget>[
              Container(
                height: 64,
                color: Color(0xFF424141),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        isOpened = !isOpened;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.settings,
                              size: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                            ),
                            Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        Icon(
                          isOpened ? Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Two Factor Authentication',//displayOptions.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        CupertinoSwitch(
                          value: state.devicePaymentSettings.secondFactor,
                          onChanged: (value) {
                            DevicePaymentSettings settings = state.devicePaymentSettings;
                            settings.secondFactor = value;
                            widget.screenBloc.add(UpdateDevicePaymentSettings(settings: settings));
                          },
                        ),
                      ],
                    ),
                  )
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Autoresponder',//displayOptions.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        CupertinoSwitch(
                          value: state.devicePaymentSettings.autoresponderEnabled,
                          onChanged: (value) {
                            DevicePaymentSettings settings = state.devicePaymentSettings;
                            settings.autoresponderEnabled = value;
                            widget.screenBloc.add(UpdateDevicePaymentSettings(settings: settings));
                          },
                        ),
                      ],
                    ),
                  )
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                  height: 64,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                        ),
                        Text(
                          'verify type:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            icon: Container(),
                            underline: Container(),
                            isExpanded: true,
                            value: dropdownItems[state.devicePaymentSettings.verificationType],
                            onChanged: (value) {
                              DevicePaymentSettings settings = state.devicePaymentSettings;
                              settings.verificationType = dropdownItems.indexOf(value, 0);
                              widget.screenBloc.add(UpdateDevicePaymentSettings(settings: settings));
                            },
                            items: dropdownItems.map((label) => DropdownMenuItem(
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              value: label,
                            ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
              ): Container(),
              isOpened ? Divider(
                color: Colors.white30,
                height: 0,
                thickness: 0.5,
              ): Container(),
              isOpened ? Container(
                height: 64,
                color: Color(0xFF424141),
                child: SizedBox.expand(
                  child: MaterialButton(
                    onPressed: () {
                      DevicePaymentSettings settings = state.devicePaymentSettings;
                      widget.screenBloc.add(SaveDevicePaymentSettings(
                        businessId: widget.businessId,
                        autoresponderEnabled: settings.autoresponderEnabled,
                        secondFactor: settings.secondFactor,
                        verificationType: settings.verificationType,
                      ));
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}

