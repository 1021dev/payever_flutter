import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/pos_new/views/pos_connect_screen.dart';
import 'package:payever/pos_new/views/pos_create_terminal_screen.dart';
import 'package:payever/pos_new/views/pos_switch_terminals_screen.dart';
import 'package:payever/pos_new/widgets/pos_top_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pos_device_payment_settings.dart';

bool _isPortrait;
bool _isTablet;


class PosInitScreen extends StatelessWidget {

  List<Terminal> terminals;
  Terminal activeTerminal;

  PosInitScreen({
    this.terminals,
    this.activeTerminal,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return PosScreen(
      globalStateModel: globalStateModel,
      terminals: terminals,
      activeTerminal: activeTerminal,
    );
  }
}

class PosScreen extends StatefulWidget {

  GlobalStateModel globalStateModel;
  List<Terminal> terminals;
  Terminal activeTerminal;

  PosScreen({
    this.globalStateModel,
    this.terminals,
    this.activeTerminal,
  });

  @override
  createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  static const platform = const MethodChannel('payever.flutter.dev/tapthephone');

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PosScreenBloc screenBloc = PosScreenBloc();
  String wallpaper;
  int selectedIndex = 0;
  bool isShowCommunications = false;

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, PosScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Switch terminal',
        onTap: () async {
          Navigator.push(
            context,
            PageTransition(
              child: PosSwitchTerminalsScreen(
                businessId: widget.globalStateModel.currentBusiness.id,
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
      OverflowMenuItem(
        title: 'Add new terminal',
        onTap: () async {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                businessId: widget.globalStateModel.currentBusiness.id,
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: PosCreateTerminalScreen(
                businessId: widget.globalStateModel.currentBusiness.id,
                screenBloc: screenBloc,
                editTerminal: state.activeTerminal,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    screenBloc.add(
        PosScreenInitEvent(
          currentBusiness: widget.globalStateModel.currentBusiness,
          terminals: widget.terminals,
          activeTerminal: widget.activeTerminal,
        )
    );
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  Future<Null> _showNativeView() async {
    await platform.invokeMethod('showNativeView');
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
        bloc: screenBloc,
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
      child: Row(
        children: <Widget>[
          PosTopButton(
            title: state.activeTerminal.name,
            selectedIndex: selectedIndex,
            index: 0,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          PosTopButton(
            title: 'Connect',
            selectedIndex: selectedIndex,
            index: 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          PosTopButton(
            title: 'Settings',
            index: 2,
            selectedIndex: selectedIndex,
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          PosTopButton(
            title: 'Open',
            selectedIndex: selectedIndex,
            index: 3,
            onTap: () {
              if (Platform.isAndroid) {
                _showNativeView();
              }
            },
          ),
          PopupMenuButton<OverflowMenuItem>(
            icon: Icon(Icons.more_horiz),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.black87,
            itemBuilder: (BuildContext context) {
              return appBarPopUpActions(context, state)
                  .map((OverflowMenuItem item) {
                    return PopupMenuItem<OverflowMenuItem>(
                      value: item,
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    );
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  Widget _getBody(PosScreenState state) {
    switch(selectedIndex) {
      case 0:
        return _defaultTerminalWidget(state);
      case 1:
        return _connectWidget(state);
      case 2:
        return _settingsWidget(state);
      default:
        return Container();
    }
  }

  Widget _defaultTerminalWidget(PosScreenState state) {
    return Container();
  }

  Widget _connectWidget(PosScreenState state) {
    List<Communication> integrations = state.integrations;
    List<String> terminalIntegrations = state.terminalIntegrations;
    return Center(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          height: (state.integrations.length * 50).toDouble() + 50,
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
                                integrations[index].integration.name,//displayOptions.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                    CupertinoSwitch(
                                    value: terminalIntegrations.contains(integrations[index].integration.name),
                                    onChanged: (value) {
                                      screenBloc.add(value ? InstallTerminalDevicePaymentEvent(
                                        payment: integrations[index].integration.name,
                                        businessId: widget.globalStateModel.currentBusiness.id,
                                        terminalId: state.activeTerminal.id,
                                      ): UninstallTerminalDevicePaymentEvent(
                                        payment: integrations[index].integration.name,
                                        businessId: widget.globalStateModel.currentBusiness.id,
                                        terminalId: state.activeTerminal.id,
                                      ));
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (state.integrations[index].integration.name == 'device-payments') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosDevicePaymentSettings(
                                              businessId: widget.globalStateModel.currentBusiness.id,
                                              screenBloc: screenBloc,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      }

                                    },
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
                integrations.length > 0 ? Divider(
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
                      Navigator.push(
                        context,
                        PageTransition(
                          child: PosConnectScreen(
                            globalStateModel: widget.globalStateModel,
                            screenBloc: screenBloc,
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
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
        ),
      );
  }

  Widget _settingsWidget(PosScreenState state) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Terminal UUID',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              Expanded(
                child: AutoSizeText(
                  state.activeTerminal.id,
                  minFontSize: 12,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              MaterialButton(
                height: 32,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.black26,
                child: Text(
                  state.terminalCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyTerminalEvent(businessId: widget.globalStateModel.currentBusiness.id, terminal: state.activeTerminal));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showDevicePaymentSettings(PosScreenState state) {
    if (state.devicePaymentSettings == null) {
      screenBloc.add(GetPosDevicePaymentSettings(businessId: widget.globalStateModel.currentBusiness.id));
    }

    return  Container();
  }

  void showIntegrations(PosScreenState state) {
  }

  void showCommunications(PosScreenState state) {
    if (state.communications.length == 0) {
      screenBloc.add(GetPosCommunications(businessId: widget.globalStateModel.currentBusiness.id));
    }
    List<Communication> communications = state.communications;
    Container(
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
                                CupertinoSwitch(
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

