import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/pos/widgets/pos_top_button.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/create_shop_screen.dart';
import 'package:payever/shop/views/enable_password_screen.dart';
import 'package:payever/shop/views/external_domain_screen.dart';
import 'package:payever/shop/views/local_domain_screen.dart';
import 'package:payever/shop/views/switch_shop_screen.dart';
import 'package:payever/shop/views/themes/theme_screen.dart';
import 'package:payever/shop/widgets/shop_top_button.dart';
import 'package:payever/theme.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/login/login_screen.dart';

bool _isPortrait;
bool _isTablet;

class ShopInitScreen extends StatelessWidget {

  final List<ShopModel> shopModels;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;

  ShopInitScreen({
    this.shopModels,
    this.activeShop,
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ShopScreen(
      globalStateModel: globalStateModel,
      shopModels: shopModels,
      activeShop: activeShop,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class ShopScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final List<ShopModel> shopModels;
  final ShopModel activeShop;
  final DashboardScreenBloc dashboardScreenBloc;

  ShopScreen({
    this.globalStateModel,
    this.shopModels,
    this.activeShop,
    this.dashboardScreenBloc,
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

  ShopScreenBloc screenBloc;
  int selectedIndex = 0;

  List<OverflowMenuItem> appBarPopUpActions(BuildContext context, ShopScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Switch Shop',
        onTap: () async {
          final result = await Navigator.push(
            context,
            PageTransition(
              child: SwitchShopScreen(
                businessId: widget.globalStateModel.currentBusiness.id,
                screenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
          if (result == 'refresh') {
            screenBloc.add(
                ShopScreenInitEvent(
                  currentBusinessId: widget.globalStateModel.currentBusiness.id,
                )
            );
          }
        },
      ),
      OverflowMenuItem(
        title: 'Add new Shop',
        onTap: () async {
          final result = await Navigator.push(
            context,
            PageTransition(
              child: CreateShopScreen(
                businessId: widget.globalStateModel.currentBusiness.id,
                screenBloc: screenBloc,
                fromDashBoard: true,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
          if (result == 'refresh') {
            screenBloc.add(
                ShopScreenInitEvent(
                  currentBusinessId: widget.globalStateModel.currentBusiness.id,
                )
            );
          }
        },
      ),
    ];
  }

  List<OverflowMenuItem> dashboardPopup(BuildContext context, ShopScreenState state) {
    return [
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
    screenBloc = ShopScreenBloc(
      dashboardScreenBloc: widget.dashboardScreenBloc,
    )..add(ShopScreenInitEvent(
        currentBusinessId: widget.globalStateModel.currentBusiness.id,
      ));
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
            dashboardScreenBloc: widget.dashboardScreenBloc,
            activeBusiness: widget.dashboardScreenBloc.state.activeBusiness,
            onClose: () {
              _innerDrawerKey.currentState.toggle();
            },
            scaffold: _body(state),
          );
        },
      ),
    );
  }

  Widget _body(ShopScreenState state) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: Language.getWidgetStrings('widgets.store.title'),
        icon: SvgPicture.asset(
          'assets/images/shopicon.svg',
          height: 20,
          width: 20,
        ),
        innerDrawerKey: _innerDrawerKey,
      ),
      body: SafeArea(
        bottom: false,
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
      height: 50,
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
          // ShopTopButton(
          //   title: Language.getSettingsStrings('Edit'),
          //   selectedIndex: selectedIndex,
          //   index: 3,
          //   onTap: () {
          //     setState(() {
          //       selectedIndex = 3;
          //     });
          //   },
          // ),
          PopupMenuButton<OverflowMenuItem>(
            icon: Icon(Icons.more_horiz, color: Colors.white,),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: overlayFilterViewBackground(),
            itemBuilder: (BuildContext context) {
              return appBarPopUpActions(context, state)
                  .map((OverflowMenuItem item) {
                return PopupMenuItem<OverflowMenuItem>(
                  value: item,
                  child: Text(
                    item.title,
                    style: TextStyle(
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
      case 0:
        return _dashboardWidget(state);
      case 1:
        // return _templatesView(state);
        return ThemesScreen(
          dashboardScreenBloc: widget.dashboardScreenBloc,
          screenBloc: screenBloc,
          globalStateModel: widget.globalStateModel,
          activeShop: widget.activeShop,
        );
      case 2:
        return _settings(state);
      default:
        return Container();
    }
  }

  Widget _settings(ShopScreenState state) {
    if (state.activeShop == null) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Center(
        child: BlurEffectView(
          child: Wrap(
            children: <Widget>[
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Language.getWidgetStrings('widgets.store.live-status'),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: state.activeShop.accessConfig.isLive,
                        onChanged: (value) {
                          AccessConfig config = state.activeShop.accessConfig;
                          config.isLive = value;
                          screenBloc.add(
                            UpdateShopSettings(
                              businessId: widget.globalStateModel.currentBusiness.id,
                              shopId: state.activeShop.id,
                              config: config,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Payever Domain'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${state.activeShop.accessConfig.internalDomain}.new.payever.shop',
                            ),
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: LocalDomainScreen(
                                    screenBloc: screenBloc,
                                    businessId: Provider.of<GlobalStateModel>(context, listen: false).currentBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Own Domain'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            state.activeShop.accessConfig.ownDomain != null
                                ? '${state.activeShop.accessConfig.ownDomain}.new.payever.shop'
                                : '',
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: ExternalDomainScreen(
                                    screenBloc: screenBloc,
                                    businessId: Provider.of<GlobalStateModel>(context, listen: false).currentBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, thickness: 0.5, color: Colors.white54,),
              Container(
                height: 50,
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      flex: 2,
                      child: Text(
                        Language.getWidgetStrings('Password'),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            state.activeShop.accessConfig.isLocked ? 'Enabled': 'Disabled',
                          ),
                          MaterialButton(
                            minWidth: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EnablePasswordScreen(
                                    screenBloc: screenBloc,
                                    businessId: Provider.of<GlobalStateModel>(context, listen: false).currentBusiness.id,
                                    detailModel: state.activeShop,
                                  ),
                                  type: PageTransitionType.fade,
                                ),
                              );
                            },
                            child: Text(
                                Language.getSettingsStrings('actions.edit')
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboardWidget(ShopScreenState state) {
    if (state.activeShop == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            color: Color(0xFF222222),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Your Shop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        if (state.activeShop != null) {
                          _launchURL('https://${state.activeShop.accessConfig.internalDomain}.new.payever.shop/');
                        }
                      },
                      height: 32,
                      color: overlayBackground().withOpacity(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 8),
                    // ),
                    // PopupMenuButton<OverflowMenuItem>(
                    //   child: Material(
                    //     color: overlayBackground().withOpacity(1),
                    //     shape: CircleBorder(),
                    //     child: Icon(
                    //       Icons.more_horiz,
                    //       size: 32,
                    //     ),
                    //   ),
                    //   offset: Offset(0, 100),
                    //   onSelected: (OverflowMenuItem item) => item.onTap(),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8),
                    //   ),
                    //   color: overlayBackground().withOpacity(1),
                    //   itemBuilder: (BuildContext context) {
                    //     return dashboardPopup(context, state)
                    //         .map((OverflowMenuItem item) {
                    //       return PopupMenuItem<OverflowMenuItem>(
                    //         value: item,
                    //         child: Text(
                    //           item.title,
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             fontWeight: FontWeight.w300,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList();
                    //   },
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.all(0.0),
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()
          ),
          Expanded(
            child: InAppWebView(
              initialUrl: 'https://${state.activeShop.accessConfig.internalDomain}.new.payever.shop/',
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

