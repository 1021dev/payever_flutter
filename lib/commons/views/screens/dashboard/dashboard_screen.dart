import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/payever_app_bar.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:payever/commons/views/screens/switcher/switcher_page.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_screen.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/product_detail_screen.dart';
import 'package:payever/products/views/products_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/shop/views/shop_screen.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import '../../views.dart';
import '../../custom_elements/blur_effect_view.dart';
import 'sub_view/dashboard_advertising_view.dart';
import 'sub_view/dashboard_app_pos.dart';
import 'sub_view/dashboard_business_apps_view.dart';
import 'sub_view/dashboard_checkout_view.dart';
import 'sub_view/dashboard_connect_view.dart';
import 'sub_view/dashboard_contact_view.dart';
import 'sub_view/dashboard_mail_view.dart';
import 'sub_view/dashboard_menu_view.dart';
import 'sub_view/dashboard_products_view.dart';
import 'sub_view/dashboard_settings_view.dart';
import 'sub_view/dashboard_shop_view.dart';
import 'sub_view/dashboard_studio_view.dart';
import 'sub_view/dashboard_transactions_view.dart';
import 'sub_view/dashboard_tutorial_view.dart';

class DashboardScreenInit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);

    return DashboardScreen(wallpaper: globalStateModel.currentWallpaper, refresh: globalStateModel.refresh,);
  }
}


class DashboardScreen extends StatefulWidget {
  final String wallpaper;
  final bool refresh;

  DashboardScreen({this.wallpaper, this.refresh});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DashboardScreenBloc screenBloc;
  bool isTablet = false;
  bool isLoaded = false;
  String searchString = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  GlobalStateModel globalStateModel;

  @override
  void initState() {
    screenBloc = DashboardScreenBloc();
    screenBloc.add(DashboardScreenInitEvent(wallpaper: widget.wallpaper));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);
    SharedPreferences.getInstance().then((p) {
      Language.language = p.getString(GlobalUtils.LANGUAGE);
      Language(context);
      SharedPreferences.getInstance().then((p) {
        Language.language = p.getString(GlobalUtils.LANGUAGE);
        Language(context);
      });
    });
    Locale myLocale = Localizations.localeOf(context);
    print('Language - ${myLocale.languageCode}');
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    isTablet = MediaQuery.of(context).size.width > 600;
    Measurements.loadImages(context);
    if (globalStateModel.refresh) {
      screenBloc.add(DashboardScreenInitEvent(wallpaper: widget.wallpaper));
      globalStateModel.setRefresh(false);
    }

    return BlocListener(
      bloc: screenBloc,
      listener: (BuildContext context, DashboardScreenState state) {
        if (state is DashboardScreenLogout) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LoginScreen(), type: PageTransitionType.fade));
        } else if (state is DashboardScreenSwitch) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: SwitcherScreen(), type: PageTransitionType.fade));
        }
      },
      child: BlocBuilder<DashboardScreenBloc, DashboardScreenState> (
        bloc: screenBloc,
        builder: (BuildContext context, DashboardScreenState state) {
          return state.isInitialScreen ? _showLoading(state) : _showMain(state);
        },
      )
    );
  }

  Widget _showLoading(DashboardScreenState state) {
    print('wallpaper => ${widget.wallpaper}');
    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: Container(
            child: CachedNetworkImage(
              imageUrl: state.curWall != null ? state.curWall: widget.wallpaper,
              placeholder: (context, url) => Container(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: Measurements.height,
          width: Measurements.width,
          child: Container(
            child: Scaffold(
              key: formKey,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Container(
                  height: Measurements.width * (isTablet ? 0.05 : 0.1),
                  width: Measurements.width * (isTablet ? 0.05 : 0.1),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _appBar(DashboardScreenState state) {
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
                    'assets/images/payeverlogo.svg',
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
            'Business',
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
          onPressed: () async {
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentWallpaper(state.curWall);

            await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue = Curves.ease.transform(a1.value) -   1.0;
                  return Transform(
                    transform: Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                    child: NotificationsScreen(
                      business: state.activeBusiness,
                      businessApps: state.businessWidgets,
                      dashboardScreenBloc: screenBloc,
                    ),
                  );
                },
                transitionDuration: Duration(milliseconds: 200),
                barrierDismissible: true,
                barrierLabel: '',
                context: context,
                pageBuilder: (context, animation1, animation2) {});
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
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }

  Widget _showMain(DashboardScreenState state) {
    if (state.language != null) {
      Language.language = state.language;
      Language(formKey.currentContext);
    }
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
            child: LoginScreen(),
            type: PageTransitionType.fade,
          ),
        );
      },
      onSwitchBusiness: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: SwitcherScreen(),
            type: PageTransitionType.fade,
          ),
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
  }

  Widget _body(DashboardScreenState state) {
    List<AppWidget> widgets = [];
    List<BusinessApps> businessApps = [];
    if (state.businessWidgets.length > 0) {
      widgets.addAll(state.currentWidgets);
      businessApps.addAll(state.businessWidgets);
      widgets.reversed.toList();
    }
    List<Widget> dashboardWidgets = [];
    // HEADER
    dashboardWidgets.add(_headerView(state));
    // SEARCH BAR
    dashboardWidgets.add(_searchBar(state));

    // TRANSACTIONS
    List<AppWidget> appWidgets = widgets.where((element) => element.type == 'transactions').toList();
    AppWidget appWidget;
    if (appWidgets.length > 0) {
      appWidget = appWidgets[0];
    }
    BusinessApps businessApp = businessApps.where((element) => element.code == 'transactions').toList().first;
    if (appWidget != null) {
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('transactions')){
        notifications = state.notifications['transactions'];
        print('transactions- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardTransactionsView(
            appWidget: appWidget,
            businessApps: businessApp,
            isLoading: state.isInitialScreen,
            total: state.total,
            lastMonth: state.lastMonth,
            lastYear: state.lastYear,
            monthlySum: state.monthlySum,
            onOpen: () {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: TransactionScreenInit(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            onTapContinueSetup: (app) {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: WelcomeScreen(
                    dashboardScreenBloc: screenBloc,
                    business: state.activeBusiness,
                    businessApps: app,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            },
            onTapGetStarted: () {},
            onTapLearnMore: () {},
            notifications: notifications,
          )
      );
    }
    // Business Apps
    dashboardWidgets.add(
        DashboardBusinessAppsView(
          businessApps: state.businessWidgets,
          appWidgets: state.currentWidgets,
          onTapEdit: () {},
          onTapWidget: (AppWidget aw) {
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context,listen: false)
                .setCurrentWallpaper(state.curWall);
            if (aw.type.contains('transactions')) {
              Navigator.push(
                context,
                PageTransition(
                  child: TransactionScreenInit(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                ),
              );
            } else if (aw.type.contains('pos')) {
              Navigator.push(
                context,
                PageTransition(
                  child: PosInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            } else if (aw.type.contains('shop')) {
              Navigator.push(
                context,
                PageTransition(
                  child: ShopInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            } else if (aw.type.contains('products')) {
              Navigator.push(
                context,
                PageTransition(
                  child: ProductsInitScreen(),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            }
          },
        )
    );

    // Shop
    if (widgets.where((element) => element.type == 'shop' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'shop' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'shop' ).toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('shops')){
        notifications = state.notifications['shops'];
        print('shops- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardShopView(
            businessApps: businessApp,
            appWidget: appWidget,
            shops: state.shops,
            shopModel: state.activeShop,
            isLoading: state.isLoading,
            onOpen: () {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: ShopInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            },
            onTapEditShop: () {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: ShopInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            },
            notifications: notifications,
          ),
      );
    }

    // Point of Sale
    if (widgets.where((element) => element.type == 'pos' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'pos' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'pos' ).toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('pos')){
        notifications = state.notifications['pos'];
        print('pos- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardAppPosView(
            isLoading: state.isPosLoading,
            businessApps: businessApp,
            appWidget: appWidget,
            terminals: state.terminalList,
            activeTerminal: state.activeTerminal,
            onTapEditTerminal: () async {
              final result = await Navigator.push(
                context,
                PageTransition(
                  child: PosCreateTerminalScreen(
                    fromDashBoard: true,
                    businessId: globalStateModel.currentBusiness.id,
                    screenBloc: PosScreenBloc(
                      dashboardScreenBloc: screenBloc,
                    ),
                    editTerminal: state.activeTerminal,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
              print('Terminal Update Result => $result');
              if ((result != null) && (result == 'Terminal Updated')) {
                screenBloc.add(FetchPosEvent(business: state.activeBusiness));
              }
            },
            onTapOpen: () {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: PosInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            },
            notifications: notifications,
          )
      );
    }

    // Checkout
    if (widgets.where((element) => element.type == 'checkout' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'checkout' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'checkout' ).toList().first;
      if (appWidget != null) {
        List<NotificationModel> notifications = [];
        if (state.notifications.containsKey('checkout')){
          notifications = state.notifications['checkout'];
          print('checkout- notifications => $notifications');
        }
        dashboardWidgets.add(
            DashboardCheckoutView(
              businessApps: businessApp,
              appWidget: appWidget,
              notifications: notifications,
            )
        );
      }
    }

    // Mail
    if (widgets.where((element) => element.type == 'marketing' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'marketing' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'marketing' ).toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('marketing')){
        notifications = state.notifications['marketing'];
        print('marketing- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardMailView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Studio
    if (widgets.where((element) => element.type == 'studio' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'studio' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'studio' ).toList().length > 0
          ? businessApps.where((element) => element.code == 'studio' ).toList().first : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('studio')){
        notifications = state.notifications['studio'];
        print('studio- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardStudioView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Ads
    if (widgets.where((element) => element.type == 'ads' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'ads' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'ads' ).toList().length > 0
          ? businessApps.where((element) => element.code == 'ads' ).toList().first : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('ads')){
        notifications = state.notifications['ads'];
        print('ads- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardAdvertisingView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Contacts
    if (widgets.where((element) => element.type == 'contacts' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'contacts' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'contacts' ).toList().length > 0
          ? businessApps.where((element) => element.code == 'contacts' ).toList().first : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('contacts')){
        notifications = state.notifications['contacts'];
        print('contacts- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardContactView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Products
    if (widgets.where((element) => element.type == 'products' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'products' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'products' ).toList().length > 0
          ? businessApps.where((element) => element.code == 'products' ).toList().first : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.keys.toList().contains('products')){
        notifications = state.notifications['products'];
        print('products- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardProductsView(
            businessApps: businessApp,
            appWidget: appWidget,
            lastSales: state.lastSalesRandom,
            business: state.activeBusiness,
            onOpen: () async {
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: ProductsInitScreen(),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            onSelect: (Products product) async {
              ProductsModel productsModel = new ProductsModel();
              productsModel.id = product.id;
              productsModel.title = product.name;
              List<String> images = [];
              if (product.thumbnail != null) {
                images.add(product.thumbnail);
              }
              productsModel.images = images;
              productsModel.businessUuid = product.business;
              productsModel.price = product.price;
              productsModel.salePrice = product.salePrice;
              productsModel.uuid = product.uuid;

              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context,listen: false)
                  .setCurrentWallpaper(state.curWall);
              final result = await Navigator.push(
                context,
                PageTransition(
                  child: ProductDetailScreen(
                    productsModel: productsModel,
                    businessId: globalStateModel.currentBusiness.id,
                    fromDashBoard: true,
                    screenBloc: ProductsScreenBloc(dashboardScreenBloc: screenBloc),
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
              print('Products Update Result => $result');
              if ((result != null) && (result == 'Products Updated')) {
              }
            },
            notifications: notifications,
          ),
      );
    }

    // Connects
    if (widgets.where((element) => element.type == 'connect' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'connect' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'connect' ).toList().length > 0
          ? businessApps.where((element) => element.code == 'connect' ).toList().first : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('connect')){
        notifications = state.notifications['connect'];
        print('connect- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardConnectView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Settings
    if (widgets.where((element) => element.type == 'settings' ).toList().length > 0) {
      appWidget = widgets.where((element) => element.type == 'settings' ).toList().first;
      businessApp = businessApps.where((element) => element.code == 'settings' ).toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('settings')){
        notifications = state.notifications['settings'];
        print('settings- notifications => $notifications');
      }
      dashboardWidgets.add(
          DashboardSettingsView(
            businessApps: businessApp,
            appWidget: appWidget,
            notifications: notifications,
          )
      );
    }

    // Tutorials
    dashboardWidgets.add(
        DashboardTutorialView(
          tutorials: state.tutorials,
        )
    );

    // Paddings
    dashboardWidgets.add(
        Padding(
          padding: EdgeInsets.only(top: 24),
        )
    );

    return Scaffold(
      backgroundColor: Colors.black87,
      resizeToAvoidBottomPadding: false,
      appBar: _appBar(state),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.only(bottom: 44),
        alignment: Alignment.bottomLeft,
        child: RawMaterialButton(
          shape: CircleBorder(),
          elevation: 4,
          fillColor: Color(0xFF222222),
          child:Icon(
            Icons.help_outline,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {
          },
        ),
      ),
      body: SafeArea(
        top: true,
        child: BackgroundBase(
          false,
          wallPaper: state.curWall,
          body: Container(
            alignment: Alignment.center,
            child: Container(
              width: Measurements.width,
              child: RefreshIndicator(
                onRefresh: ()  {
                  screenBloc.add(DashboardScreenInitEvent(wallpaper: state.curWall));
                  return  Future.delayed(Duration(seconds: 3));
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        itemCount: dashboardWidgets.length,
                        itemBuilder: (context, index) {
                          return dashboardWidgets[index];
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 8,
                            thickness: 8,
                            color: Colors.transparent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _headerView(DashboardScreenState state) {
    return Column(
      children: [
        SizedBox(height: 60),
        Text(
          'Welcome ${state.user.firstName},',
          style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3,
                    color: Colors.black.withAlpha(50)
                )
              ]
          ),
        ),
        SizedBox(height: 4),
        Text(
          'grow your business',
          style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              shadows: [
                Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3,
                    color: Colors.black.withAlpha(50)
                )
              ]
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 64),
        ),
      ],
    );
  }

  Widget _searchBar(DashboardScreenState state) {
    return BlurEffectView(
      radius: 12,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        height: 40,
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocus,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.white
                        ),
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white
                      ),
                      onChanged: (val) {
                        if (val.length > 0) {
                          if (searchString.length > 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        } else {
                          if (searchString.length == 0) {
                            searchString = val;
                          } else {
                            setState(() {
                              searchString = val;
                            });
                          }
                        }
                      },
                      onSubmitted: (val) async {
                        FocusScope.of(context).unfocus();
                        if (val.length == 0) {
                          return;
                        }
                        final result = await Navigator.push(
                          context,
                          PageTransition(
                            child: SearchScreen(
                              dashboardScreenBloc: screenBloc,
                              businessId: state.activeBusiness.id,
                              searchQuery: searchController.text,
                              appWidgets: state.currentWidgets,
                              activeBusiness: state.activeBusiness,
                              currentWall: state.curWall,
                            ),
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 50),
                          ),
                        );
                        if ((result != null) && (result == 'changed')) {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                          screenBloc.add(DashboardScreenInitEvent(wallpaper: globalStateModel.currentWallpaper));
                        } else {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                    ),
                  ),
                  searchController.text.isEmpty ? Container() : MaterialButton(
                    onPressed: () {
                      setState(() {
                        searchString = '';
                        searchController.text = searchString;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    shape: CircleBorder(
                      side: BorderSide.none,
                    ),
                    color: Colors.white54.withOpacity(0.2),
                    elevation: 0,
                    height: 20,
                    minWidth: 20,
                    child: Icon(
                      Icons.close,
                      size: 12,
                    ),
                  ),
                  searchController.text.isEmpty ? Container() : MaterialButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      final result = await Navigator.push(
                        context,
                        PageTransition(
                          child: SearchScreen(
                            dashboardScreenBloc: screenBloc,
                            businessId: state.activeBusiness.id,
                            searchQuery: searchController.text,
                            appWidgets: state.currentWidgets,
                            activeBusiness: state.activeBusiness,
                            currentWall: state.curWall,
                          ),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 50),
                        ),
                      );
                      if ((result != null) && (result == 'changed')) {
                        setState(() {
                          searchString = '';
                          searchController.text = searchString;
                          FocusScope.of(context).unfocus();
                        });
                        screenBloc.add(DashboardScreenInitEvent(wallpaper: globalStateModel.currentWallpaper));
                      } else {
                        setState(() {
                          searchString = '';
                          searchController.text = searchString;
                          FocusScope.of(context).unfocus();
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.white54.withOpacity(0.2),
                    elevation: 0,
                    minWidth: 0,
                    height: 20,
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
