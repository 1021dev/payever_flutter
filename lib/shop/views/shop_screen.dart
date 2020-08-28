import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
import 'package:payever/shop/widgets/shop_top_button.dart';
import 'package:payever/shop/widgets/template_cell.dart';
import 'package:payever/shop/widgets/theme_filter_content_view.dart';
import 'package:payever/shop/widgets/theme_own_cell.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String wallpaper;
  int selectedIndex = 0;
  bool isShowCommunications = false;
  List<FilterItem> filterTypes = [];
  int selectedTypes = 0;

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
    );
    filterTypes.add(FilterItem(disPlayName: 'All themes', value: 'All themes'));
    filterTypes.add(FilterItem(disPlayName: 'Own themes', value: 'Own themes'));
    screenBloc.add(
        ShopScreenInitEvent(
          currentBusinessId: widget.globalStateModel.currentBusiness.id,
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
            dashboardScreenBloc: widget.dashboardScreenBloc,
            activeBusiness: widget.dashboardScreenBloc.state.activeBusiness,
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
    String businessLogo = '';
    if (widget.dashboardScreenBloc.state.activeBusiness != null) {
      businessLogo = 'https://payeverproduction.blob.core.windows.net/images/${widget.dashboardScreenBloc.state.activeBusiness.logo}' ?? '';
    }
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
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: Row(
              children: <Widget>[
                BusinessLogo(url: businessLogo,),
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
            onTap: () async {
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
                      type: 'shops',
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
            title: Language.getSettingsStrings('Edit'),
            selectedIndex: selectedIndex,
            index: 3,
            onTap: () {
              setState(() {
                selectedIndex = 3;
              });
            },
          ),
          PopupMenuButton<OverflowMenuItem>(
            icon: Icon(Icons.more_horiz, color: Colors.white,),
            offset: Offset(0, 100),
            onSelected: (OverflowMenuItem item) => item.onTap(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: overlayBackground().withOpacity(1),
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
        return _templatesView(state);
      case 2:
        return _settings(state);
      default:
        return Container();
    }
  }

  Widget _templatesView(ShopScreenState state) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 64,
            color: Color(0xFF222222),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (builder) {
                          return ThemeFilterContentView(
                            selectedIndex: selectedTypes ,
                            onSelected: (val) {
                              Navigator.pop(context);
                              setState(() {
                                selectedTypes = val;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.filter_list, color: Colors.white,),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  selectedTypes == 0
                      ? '${state.templates.length} Templates'
                      : '${state.ownThemes.length} Themes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ((selectedTypes == 0 && state.templates.length > 0) || (selectedTypes == 1 && state.ownThemes.length > 0)) ? GridView.count(
              padding: EdgeInsets.only(left: 36, right: 36, top: 16, bottom: 16),
              children: selectedTypes == 0
                  ? state.templates.map((templateModel) {
                return TemplateCell(
                  templateModel: templateModel,
                  onTapInstall: (template) {
                    if (state.activeShop != null) {
                      screenBloc.add(
                          InstallTemplateEvent(
                            businessId: widget.globalStateModel.currentBusiness.id,
                            templateId: template.id,
                            shopId: state.activeShop.id,
                          )
                      );
                    }
                  },
                );
              }).toList()
                  : state.ownThemes.map((theme) {
                return ThemeOwnCell(
                  themeModel: theme,
                  onTapInstall: (theme) {
                    if (state.activeShop != null) {
                      screenBloc.add(
                          InstallTemplateEvent(
                            businessId: widget.globalStateModel.currentBusiness.id,
                            templateId: theme.id,
                            shopId: state.activeShop.id,
                          )
                      );
                    }
                  },
                  onTapDelete: (theme) {
                    if (state.activeShop != null) {
                      screenBloc.add(
                          DeleteThemeEvent(
                            businessId: widget.globalStateModel.currentBusiness.id,
                            themeId: theme.id,
                            shopId: state.activeShop.id,
                          )
                      );
                    }
                  },
                  onTapDuplicate: (theme) {
                    if (state.activeShop != null) {
                      screenBloc.add(
                          DuplicateThemeEvent(
                            businessId: widget.globalStateModel.currentBusiness.id,
                            themeId: theme.id,
                            shopId: state.activeShop.id,
                          )
                      );
                    }
                  },
                  onTapEdit: (theme) {

                  },
                );
              }).toList(),
              crossAxisCount: _isPortrait ? 1: 3,
              mainAxisSpacing: 36,
              crossAxisSpacing: 36,
              childAspectRatio: 0.6,
            ): Container(),
          ),
        ],
      ),
    );
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
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    PopupMenuButton<OverflowMenuItem>(
                      child: Material(
                        color: overlayBackground().withOpacity(1),
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.more_horiz,
                          size: 32,
                        ),
                      ),
                      offset: Offset(0, 100),
                      onSelected: (OverflowMenuItem item) => item.onTap(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: overlayBackground().withOpacity(1),
                      itemBuilder: (BuildContext context) {
                        return dashboardPopup(context, state)
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

