import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/pos/views/pos_connect_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_qr_app.dart';
import 'package:payever/pos/views/pos_switch_terminals_screen.dart';
import 'package:payever/pos/views/pos_twillo_settings.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pos_device_payment_settings.dart';

bool _isPortrait;
bool _isTablet;


class PosInitScreen extends StatelessWidget {

  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final DashboardScreenBloc dashboardScreenBloc;

  PosInitScreen({
    this.terminals,
    this.activeTerminal,
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return PosScreen(
      dashboardScreenBloc: dashboardScreenBloc,
      globalStateModel: globalStateModel,
      terminals: terminals,
      activeTerminal: activeTerminal,
    );
  }
}

class PosScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final List<Terminal> terminals;
  final Terminal activeTerminal;
  final DashboardScreenBloc dashboardScreenBloc;

  PosScreen({
    this.globalStateModel,
    this.terminals,
    this.activeTerminal,
    this.dashboardScreenBloc,
  });

  @override
  createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  static const platform = const MethodChannel('payever.flutter.dev/tapthephone');

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  PosScreenBloc screenBloc;
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
    screenBloc = PosScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    );
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
            onLogout: () async {
              FlutterSecureStorage storage = FlutterSecureStorage();
              await storage.delete(key: GlobalUtils.TOKEN);
              await storage.delete(key: GlobalUtils.BUSINESS);
              await storage.delete(key: GlobalUtils.REFRESH_TOKEN);
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, '');
                p.setString(GlobalUtils.DEVICE_ID, '');
              });
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: LoginScreen(),
                    type: PageTransitionType.fade,
                  )
              );
            },
            onSwitchBusiness: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SwitcherScreen(),
                      type: PageTransitionType.fade,
                  )
              );
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
            Language.getWidgetStrings('widgets.pos.title'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/images/business_person.svg',
                  width: 20,
                ),
                _isTablet || !_isPortrait ? Padding(
                  padding: EdgeInsets.only(left: 4, right: 4),
                  child: Text(
                    widget.dashboardScreenBloc.state.activeBusiness.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ): Container(),
              ],
            ),
            onTap: () {
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset('assets/images/searchicon.svg', width: 20,),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SearchScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    businessId: widget.dashboardScreenBloc.state.activeBusiness.id,
                    searchQuery: '',
                    appWidgets: widget.dashboardScreenBloc.state.currentWidgets,
                    activeBusiness: widget.dashboardScreenBloc.state.activeBusiness,
                    currentWall: widget.dashboardScreenBloc.state.curWall,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/notificationicon.svg',
              width: 20,
            ),
            onTap: ()async{
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(widget.dashboardScreenBloc.state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(widget.dashboardScreenBloc.state.curWall);

              await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, wg) {
                  final curvedValue = Curves.ease.transform(a1.value) -   1.0;
                  return Transform(
                    transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                    child: NotificationsScreen(
                      business: widget.dashboardScreenBloc.state.activeBusiness,
                      businessApps: widget.dashboardScreenBloc.state.businessWidgets,
                      dashboardScreenBloc: widget.dashboardScreenBloc,
                      type: 'pos',
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {
                  return null;
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/list.svg',
              width: 20,
            ),
            onTap: () {
              _innerDrawerKey.currentState.toggle();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/closeicon.svg',
              width: 16,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8),
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
          ): Center(
            child: Column(
              children: <Widget>[
                _toolBar(state),
                Expanded(
                  child: _getBody(state),
                ),
              ],
            ),
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
            title: state.activeTerminal != null ? state.activeTerminal.name : '',
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
    if (state.activeTerminal == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(0.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
          ),
          Expanded(
            child: InAppWebView(
              initialUrl: "https://${state.activeTerminal.id}.payever.business",
              initialHeaders: {},
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                  )
              ),
              onWebViewCreated: (InAppWebViewController controller) {
                webView = controller;
              },
              onLoadStart: (InAppWebViewController controller, String url) {
                setState(() {
                  this.url = url;
                });
              },
              onLoadStop: (InAppWebViewController controller, String url) async {
                setState(() {
                  this.url = url;
                });
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectWidget(PosScreenState state) {
    List<Communication> integrations = state.integrations;
    List<String> terminalIntegrations = state.terminalIntegrations;
    return Center(
      child: Container(
        width: Measurements.width,
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
                                Language.getPosConnectStrings(integrations[index].integration.displayOptions.title),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
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
                                      } else if (state.integrations[index].integration.name == 'qr') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosQRAppScreen(
                                              businessId: widget.globalStateModel.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.globalStateModel.currentBusiness.name,
                                            ),
                                            type: PageTransitionType.fade,
                                            duration: Duration(milliseconds: 500),
                                          ),
                                        );
                                      } else if (state.integrations[index].integration.name == 'twilio') {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PosTwilioScreen(
                                              businessId: widget.globalStateModel.currentBusiness.id,
                                              screenBloc: screenBloc,
                                              businessName: widget.globalStateModel.currentBusiness.name,
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
                                        child: Text(
                                          Language.getCommerceOSStrings('actions.open'),
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
      width: Measurements.width,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Business UUID',
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
                  widget.globalStateModel.currentBusiness.id,
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
                  state.businessCopied ? 'Copied': 'Copy',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                onPressed: () {
                  screenBloc.add(CopyBusinessEvent(businessId: widget.globalStateModel.currentBusiness.id));
                },
              ),
            ],
          ),
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
}

