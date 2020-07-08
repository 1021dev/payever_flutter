import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:http/http.dart' as http;
import 'package:payever/pos_new/models/models.dart';

bool _isPortrait;
bool _isTablet;

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
      GenerateQRSettingsEvent(
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
            Language.getPosTpmStrings('tpm.communications.qr.title'),
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

    if (response != null) {
      if (response is Map) {
        dynamic form = response['form'];
        String contentType = form['contentType'] != null ? form['contentType'] : '';
        dynamic content = form['content'] != null ? form['content']: null;
        if (content != null) {
          List<dynamic> contentData = content[contentType];
          for (int i = 0; i < contentData.length; i++) {
            dynamic data = content[contentType][i];
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
                            Padding(
                              padding: EdgeInsets.only(left: 16),
                            ),
                            Text(
                              data['title'] ?? '',
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
                      child: imageData != null ? Image.memory(
                        imageData, fit: BoxFit.fitHeight,) : Container()
                  ) : Container();
                  widgets.add(imageWidget);
                }
              }
            } else if (data['fieldset'] != null) {
              List<dynamic> fieldset = data['fieldset'];
              fieldset.forEach((element) {
                if (element['type'] != 'hidden') {
                  if (element['type'] == 'select') {
                    String name = element['name'];
                    dynamic fieldSettings = element['fieldSettings'];
                    dynamic selectSettings = element['selectSettings'];
                    List<CountryDropdownItem> dropdownItems = [];
                    if (selectSettings['options'] != null) {
                      List<dynamic> list = selectSettings['options'];
                      list.forEach((ele) {
                        dropdownItems.add(CountryDropdownItem.fromMap(ele));
                      });
                    }
                    Widget selectWidget = Container(
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
                              fieldSettings['label'],
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
                                value: dropdownItems.firstWhere((element) => element.label == state.fieldSetData[name]).value,
                                onChanged: (value) {
                                  dynamic settings = state.fieldSetData;
                                  settings[name] = value;
                                  widget.screenBloc.add(UpdateQRCodeSettings(settings: settings));
                                },
                                items: dropdownItems.map((label) => DropdownMenuItem(
                                  child: Text(
                                    label.label,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  value: label.value,
                                ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                    widgets.add(selectWidget);
                  }
                }
              });
            }
          }
        }
      }
    }
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Wrap(
          children: <Widget>[
            Expanded(
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
            )
          ],
        )
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

