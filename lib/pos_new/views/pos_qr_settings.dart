import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
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
import 'package:http/http.dart' as http;

bool _isPortrait;
bool _isTablet;

List<String> dropdownItems = [
  'Verify by code',
  'Verify by ID',
];
class PosQRSettings extends StatefulWidget {

  PosScreenBloc screenBloc;
  String businessId;
  String businessName;

  PosQRSettings({
    this.screenBloc,
    this.businessId,
    this.businessName,
  });

  @override
  createState() => _PosQRSettingsState();
}

class _PosQRSettingsState extends State<PosQRSettings> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';
  bool isOpened = true;

  var imageData;

  @override
  void initState() {
    widget.screenBloc.add(
      GenerateQRCodeEvent(
        businessId: widget.businessId,
        businessName: widget.businessName,
        avatarUrl: '$imageBase${widget.screenBloc.state.activeTerminal.logo}',
        id: widget.screenBloc.state.activeTerminal.id,
        url: '${Env.checkout}/pay/create-flow-from-qr/channel-set-id/${widget.screenBloc.state.activeTerminal.channelSet}',
      ),
    );
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
            'QR Generator',
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
              Expanded(
                child: _getBody(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    dynamic response = state.qrForm;
    List<Widget> widgets = [];
    widgets.add(
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
                    SvgPicture.asset(
                      'assets/images/qr.svg',
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Text(
                      'QR Generator',
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
    );

    if (response != null) {
      if (response['form'] != null) {
        dynamic form = response['form'];
        String contentType = form['contentType'] != null ? form['contentType'] : '';
        dynamic content = form['content'] != null ? form['content']: null;
        if (content != null) {
          dynamic data = content[contentType][0];
          if (data['data'] != null) {
            List<dynamic> list = data['data'];
            for(dynamic w in list) {
              if (w[0]['type'] == 'image') {
                if (imageData == null) {
                  getBlob(w);
                }
                Widget imageWidget = isOpened ? Container(
                  height: 300,
                  color: Colors.white,
                  child: imageData != null ? Image.memory(imageData, fit: BoxFit.fitHeight,) :Container()
                ): Container();
                widgets.add(imageWidget);
              } else if (w[0]['type'] == 'text') {
                Widget textWidget = isOpened ? Container(
                  height: 64,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        w[0]['value']
                      ),
                      MaterialButton(
                        minWidth: 0,
                        onPressed: () {
                        },
                        height: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.black26,
                        child: Text(
                          w[1]['action'],
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ): Container();
                widgets.add(textWidget);

              }
            }
          }
        }
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        height: isOpened ? 300.0 + 64.0 * 3.0: 64.0,
        child: BlurEffectView(
          color: Color.fromRGBO(20, 20, 20, 0.2),
          blur: 15,
          radius: 12,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets.map((e) => e).toList(),
          ),
        ),
      ),
    );
  }

  Future getBlob(dynamic w) async {
    var headers = {
      HttpHeaders.authorizationHeader: 'Bearer ${GlobalUtils.activeToken.accessToken}',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.userAgentHeader: GlobalUtils.fingerprint
    };

    http.get(w[0]['value'],
        headers:  headers
    ).then((http.Response response) {
      print(response);
      setState(() {
        imageData = response.bodyBytes;
      });
    });
  }
}

