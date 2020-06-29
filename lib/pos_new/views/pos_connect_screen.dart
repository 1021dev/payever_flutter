import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/pos_new/widgets/pos_top_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isPortrait;
bool _isTablet;


class PosConnectScreen extends StatefulWidget {

  PosScreenBloc screenBloc;
  GlobalStateModel globalStateModel;

  PosConnectScreen({
    this.screenBloc,
    this.globalStateModel,
  });

  @override
  createState() => _PosConnectScreenState();
}

class _PosConnectScreenState extends State<PosConnectScreen> {

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String wallpaper;
  String selectedState = '';

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, PosScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Switch terminal',
        onTap: () async {

        },
      ),
      OverflowMenuItem(
        title: 'Add new terminal',
        onTap: () async {

        },
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: () async {

        },
      ),
    ];
  }

  @override
  void initState() {
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
          return DashboardMenuView(
            innerDrawerKey: _innerDrawerKey,
            onLogout: () {
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, '');
                p.setString(GlobalUtils.EMAIL, '');
                p.setString(GlobalUtils.PASSWORD, '');
                p.setString(GlobalUtils.DEVICE_ID, '');
                p.setString(GlobalUtils.DB_TOKEN_ACC, '');
                p.setString(GlobalUtils.DB_TOKEN_RFS, '');
              });
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: LoginScreen(), type: PageTransitionType.fade));
            },
            onSwitchBusiness: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SwitcherScreen(), type: PageTransitionType.fade));
            },
            onPersonalInfo: () {

            },
            onAddBusiness: () {

            },
            onClose: () {
              _innerDrawerKey.currentState.toggle();
            },
            scaffold: _body(state),
          );
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
          Container(
            child: Center(
              child: Container(
                  child: SvgPicture.asset(
                    'assets/images/pos.svg',
                    color: Colors.white,
                    height: 16,
                    width: 24,
                  )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            'Point of Sale',
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
            Icons.person_pin,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {

          },
        ),
        IconButton(
          constraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
              minHeight: 32,
              minWidth: 32
          ),
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
            _innerDrawerKey.currentState.toggle();
          },
        ),
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
    switch(selectedState) {
      case '':
        return _connectWidget(state);
      case 'device_payment':
        return _connectWidget(state);
      case 'settings':
        return showCommunications(state);
      default:
        return Container();
    }
  }

  Widget _defaultConnectionWidget(PosScreenState state) {
    return Container();
  }

  Widget _connectWidget(PosScreenState state) {
    if (state.communications.length == 0) {
      widget.screenBloc.add(GetPosCommunications(businessId: widget.globalStateModel.currentBusiness.id));
    }
    List<Communication> communications = state.communications;
    return Container(
      margin: EdgeInsets.all(12),
      child: BlurEffectView(
        color: Color.fromRGBO(20, 20, 20, 0.2),
        blur: 15,
        radius: 12,
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: (communications.length * 50).toDouble(),
              child: BlurEffectView(
                color: Color.fromRGBO(20, 20, 20, 0.2),
                blur: 15,
                radius: 12,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              height: 50,
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Image.network(
                                          communications[index].integration.displayOptions.icon,
                                        ),
                                        Text(
                                          communications[index].integration.displayOptions.title,//displayOptions.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 20,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.black.withOpacity(0.4)
                                        ),
                                        child: Center(
                                          child: Text("Open",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 0,
                            thickness: 0.5,
                            color: Colors.white30,
                            endIndent: 0,
                            indent: 0,
                          );
                        },
                        itemCount: state.communications.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

  Widget showDevicePaymentSettings(PosScreenState state) {
    if (state.devicePaymentSettings == null) {
      widget.screenBloc.add(GetPosDevicePaymentSettings(businessId: widget.globalStateModel.currentBusiness.id));
    }

    return  Container();
  }

  void showIntegrations(PosScreenState state) {


  }

  Widget showCommunications(PosScreenState state) {
    if (state.communications.length == 0) {
      widget.screenBloc.add(GetPosCommunications(businessId: widget.globalStateModel.currentBusiness.id));
    }
    List<Communication> communications = state.communications;
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: BlurEffectView(
        color: Color.fromRGBO(20, 20, 20, 0.2),
        blur: 15,
        radius: 12,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                      height: 50,
                      child: Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              communications[index].integration.name,//displayOptions.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Switch(
                                  value: true,
                                  onChanged: (value) {
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    height: 20,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.4)
                                    ),
                                    child: Center(
                                      child: Text("Open",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 0,
                    thickness: 0.5,
                    color: Colors.white30,
                    endIndent: 0,
                    indent: 0,
                  );
                },
                itemCount: state.integrations.length,
              ),
            ),
            communications.length > 0 ? Divider(
              height: 0,
              thickness: 0.5,
              color: Colors.white30,
              endIndent: 0,
              indent: 0,
            ): Container(height: 0,),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: 50,
              child: InkWell(
                onTap: () {

                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 12,
                      ),
                      Padding(padding: EdgeInsets.only(left: 4),),
                      Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

