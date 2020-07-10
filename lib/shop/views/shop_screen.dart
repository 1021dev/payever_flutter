import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/shop/shop.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/pos_new/widgets/pos_top_button.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/create_shop_screen.dart';
import 'package:payever/shop/views/enable_password_screen.dart';
import 'package:payever/shop/views/external_domain_screen.dart';
import 'package:payever/shop/views/local_domain_screen.dart';
import 'package:payever/shop/views/switch_shop_screen.dart';
import 'package:payever/shop/widgets/shop_top_button.dart';
import 'package:payever/shop/widgets/theme_filter_content_view.dart';
import 'package:payever/transactions/views/filter_content_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


bool _isPortrait;
bool _isTablet;


class ShopInitScreen extends StatelessWidget {

  List<ShopModel> shopModels;
  ShopModel activeShop;

  ShopInitScreen({
    this.shopModels,
    this.activeShop,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return ShopScreen(
      globalStateModel: globalStateModel,
      shopModels: shopModels,
      activeShop: activeShop,
    );
  }
}

class ShopScreen extends StatefulWidget {

  GlobalStateModel globalStateModel;
  List<ShopModel> shopModels;
  ShopModel activeShop;

  ShopScreen({
    this.globalStateModel,
    this.shopModels,
    this.activeShop,
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

  List<OverflowMenuItem> templatePopup(BuildContext context, ShopScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Install',
        onTap: (TemplateModel template) async {
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
      ),
    ];
  }

  List<OverflowMenuItem> themePopup(BuildContext context, ShopScreenState state) {
    return [
      OverflowMenuItem(
        title: 'Install',
        onTap: (theme) async {
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
      ),
      OverflowMenuItem(
        title: 'Duplicate',
        onTap: (theme) async {
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
      ),
      OverflowMenuItem(
        title: 'Edit',
        onTap: (theme) async {
        },
      ),
      OverflowMenuItem(
        title: 'Delete',
        onTap: (theme) async {
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
    filterTypes.add(FilterItem(disPlayName: 'All themes', value: 'All themes'));
    filterTypes.add(FilterItem(disPlayName: 'Own themes', value: 'Own themes'));
    screenBloc.add(
        ShopScreenInitEvent(
          currentBusinessId: widget.globalStateModel.currentBusiness.id,
//          terminals: widget.shopModels,
//          activeTerminal: widget.activeShop,
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
            onSwitchBusiness: () async {
              final result = await Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SwitcherScreen(), type: PageTransitionType.fade));
              if (result == 'refresh') {
                screenBloc.add(
                    ShopScreenInitEvent(
                      currentBusinessId: widget.globalStateModel.currentBusiness.id,
                    )
                );
              }

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
                        Icon(Icons.filter_list),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          'Filter',
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
                return Container(
                  width: Measurements.width - 72,
                  height: (Measurements.width - 72) * 1.8,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                          '${Env.storage}${templateModel.picture}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        color: Colors.black87,
                        height: (Measurements.width - 72) * 0.38,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'new',
                                  style: TextStyle(
                                    color: Color(0xffff9000),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  templateModel.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<OverflowMenuItem>(
                                icon: Icon(Icons.more_horiz),
                                offset: Offset(0, 0),
                                onSelected: (OverflowMenuItem item) => item.onTap(templateModel),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.black87,
                                itemBuilder: (BuildContext context) {
                                  return templatePopup(context, state)
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()
                  : state.ownThemes.map((theme) {
                return Container(
                  width: Measurements.width - 72,
                  height: (Measurements.width - 72) * 1.8,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: theme.picture != null ? Image.network(
                          '${Env.storage}${theme.picture}',
                          fit: BoxFit.cover,
                        ) : SvgPicture.asset('assets/images/images_routes.json'),
                      ),
                      Container(
                        color: Colors.black87,
                        height: (Measurements.width - 72) * 0.38,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'new',
                                  style: TextStyle(
                                    color: Color(0xffff9000),
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  theme.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<OverflowMenuItem>(
                                icon: Icon(Icons.more_horiz),
                                offset: Offset(0, 0),
                                onSelected: (OverflowMenuItem item) => item.onTap(theme),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.black87,
                                itemBuilder: (BuildContext context) {
                                  return themePopup(context, state)
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
          blur: 15,
          color: Color.fromRGBO(50, 50, 50, 0.2),
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
                    CupertinoSwitch(
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
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
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.black,
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
                        color: Colors.white,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                      offset: Offset(0, 100),
                      onSelected: (OverflowMenuItem item) => item.onTap(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.black87,
                      itemBuilder: (BuildContext context) {
                        return dashboardPopup(context, state)
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

