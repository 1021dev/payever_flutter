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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/pos_new/views/pos_connect_screen.dart';
import 'package:payever/pos_new/views/pos_create_terminal_screen.dart';
import 'package:payever/pos_new/views/pos_switch_terminals_screen.dart';
import 'package:payever/pos_new/widgets/pos_top_button.dart';
import 'package:payever/shop/widgets/shop_top_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool _isPortrait;
bool _isTablet;


class ShopInitScreen extends StatelessWidget {

  List<Terminal> terminals;
  Terminal activeTerminal;

  ShopInitScreen({
    this.terminals,
    this.activeTerminal,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ShopScreen(
      globalStateModel: globalStateModel,
      terminals: terminals,
      activeTerminal: activeTerminal,
    );
  }
}

class ShopScreen extends StatefulWidget {

  GlobalStateModel globalStateModel;
  List<Terminal> terminals;
  Terminal activeTerminal;

  ShopScreen({
    this.globalStateModel,
    this.terminals,
    this.activeTerminal,
  });

  @override
  createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {

  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  InAppWebViewController webView;
  double progress = 0;
  String url = '';

  ShopScreenBloc screenBloc = ShopScreenBloc();
  String wallpaper;
  int selectedIndex = 0;
  bool isShowCommunications = false;

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, ShopScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Switch Shop',
        onTap: () async {
        },
      ),
      OverflowMenuItem(
        title: 'Add new Shop',
        onTap: () async {
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    screenBloc.add(
        ShopScreenInitEvent(
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
      listener: (BuildContext context, ShopScreenState state) async {
        if (state is ShopScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<ShopScreenBloc, ShopScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, ShopScreenState state) {
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

  Widget _appBar(ShopScreenState state) {
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
                    'assets/images/shopicon.svg',
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
            Language.getWidgetStrings('widgets.store.title'),
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

  Widget _body(ShopScreenState state) {
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

  Widget _toolBar(ShopScreenState state) {
    return Container(
      height: 44,
      color: Colors.black87,
      child: Row(
        children: <Widget>[
          ShopTopButton(
            title: Language.getCommerceOSStrings('dashboard_docker.items.dashboard'),
            selectedIndex: selectedIndex,
            index: 0,
            onTap: () {
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          ShopTopButton(
            title: Language.getPosStrings('info_boxes.terminal.panels.themes.title'),
            selectedIndex: selectedIndex,
            index: 1,
            onTap: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),
          ShopTopButton(
            title: Language.getPosStrings('info_boxes.terminal.panels.settings.title'),
            index: 2,
            selectedIndex: selectedIndex,
            onTap: () {
              setState(() {
                selectedIndex = 2;
              });
            },
          ),
          ShopTopButton(
            title: Language.getSettingsStrings('edit'),
            selectedIndex: selectedIndex,
            index: 3,
            onTap: () {
              setState(() {
                selectedIndex = 3;
              });
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

  Widget _getBody(ShopScreenState state) {
    switch(selectedIndex) {
//      case 0:
//        return _defaultTerminalWidget(state);
//      case 1:
//        return _connectWidget(state);
//      case 2:
//        return _settingsWidget(state);
      default:
        return Container();
    }
  }

  Widget _defaultTerminalWidget(ShopScreenState state) {
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

  Widget _connectWidget(ShopScreenState state) {
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
                                  CupertinoSwitch(
                                    value: terminalIntegrations.contains(integrations[index].integration.name),
                                    onChanged: (value) {},
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                  ),
                                  InkWell(
                                    onTap: () {
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

  Widget _settingsWidget(ShopScreenState state) {
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
//                  screenBloc.add(CopyBusinessEvent(businessId: widget.globalStateModel.currentBusiness.id));
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
//                  screenBloc.add(CopyTerminalEvent(businessId: widget.globalStateModel.currentBusiness.id, terminal: state.activeTerminal));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

