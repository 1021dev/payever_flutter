import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/checkout/views/checkout_screen.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/connect/views/connect_screen.dart';
import 'package:payever/contacts/views/contacts_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/pos/views/pos_create_terminal_screen.dart';
import 'package:payever/pos/views/pos_screen.dart';
import 'package:payever/products/models/models.dart';
import 'package:payever/products/views/product_detail_screen.dart';
import 'package:payever/products/views/products_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/setting_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/shop/views/shop_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:payever/theme.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sub_view/dashboard_app_pos.dart';
import 'sub_view/dashboard_business_apps_view.dart';
import 'sub_view/dashboard_checkout_view.dart';
import 'sub_view/dashboard_connect_view.dart';
import 'sub_view/dashboard_contact_view.dart';
import 'sub_view/dashboard_menu_view.dart';
import 'sub_view/dashboard_products_view.dart';
import 'sub_view/dashboard_settings_view.dart';
import 'sub_view/dashboard_shop_view.dart';
import 'sub_view/dashboard_transactions_view.dart';
import 'sub_view/dashboard_tutorial_view.dart';

class DashboardScreenInit extends StatelessWidget {
  final bool refresh;
  final bool registered;

  DashboardScreenInit({this.refresh = false, this.registered = false});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel =
        Provider.of<GlobalStateModel>(context, listen: true);

    return DashboardScreen(
      wallpaper: globalStateModel.currentWallpaper,
      refresh: globalStateModel.refresh,
      registered: registered,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final String wallpaper;
  final bool refresh;
  final bool registered;

  DashboardScreen({this.wallpaper, this.refresh, this.registered = false});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String uiKit = '${Env.commerceOs}/assets/ui-kit/icons-png/';
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DashboardScreenBloc screenBloc;
  bool isLoaded = false;
  String searchString = '';
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  GlobalStateModel globalStateModel;
  bool _isPortrait;
  bool _isTablet;

  @override
  void initState() {
    screenBloc = DashboardScreenBloc();
    screenBloc.add(DashboardScreenInitEvent(
        wallpaper: widget.wallpaper, isRefresh: widget.refresh));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    screenBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context, listen: true);
    SharedPreferences.getInstance().then((p) {
      Language.language = p.getString(GlobalUtils.LANGUAGE);
      Language(context);
    });
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = MediaQuery.of(context).size.width > 600;
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
                child: LoginScreen(),
                type: PageTransitionType.fade,
              ),
            );
          } else if (state is DashboardScreenSwitch) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                  child: SwitcherScreen(false),
                  type: PageTransitionType.fade,
                ));
          }
        },
        child: BlocBuilder<DashboardScreenBloc, DashboardScreenState>(
          bloc: screenBloc,
          builder: (BuildContext context, DashboardScreenState state) {
            return state.isInitialScreen
                ? _showLoading(state)
                : _showMain(context, state);
          },
        ));
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
              imageUrl:
                  state.curWall != null ? state.curWall : widget.wallpaper,
              placeholder: (context, url) => Center(
                child: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
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
                  height: Measurements.width * (_isTablet ? 0.05 : 0.1),
                  width: Measurements.width * (_isTablet ? 0.05 : 0.1),
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
    String businessLogo = '';
    if (state.activeBusiness != null) {
      businessLogo = 'https://payeverproduction.blob.core.windows.net/images/${state.activeBusiness.logo}' ?? '';
    }
    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                  child: SvgPicture.asset(
                'assets/images/payeverlogo.svg',
                height: 16,
                width: 24,
              )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            'Business',
            style: TextStyle(
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
                _isTablet || !_isPortrait
                    ? Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          state.activeBusiness.name,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            onTap: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.all(6),
          child: InkWell(
            child: SvgPicture.asset(
              'assets/images/searchicon.svg',
              width: 20,
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  child: SearchScreen(
                    dashboardScreenBloc: screenBloc,
                    businessId: state.activeBusiness.id,
                    searchQuery: '',
                    appWidgets: state.currentWidgets,
                    activeBusiness: state.activeBusiness,
                    currentWall: state.curWall,
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
            child: SvgPicture.asset('assets/images/notificationicon.svg',
                width: 20),
            onTap: () async {
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(state.curWall);

              await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, widget) {
                  final curvedValue = Curves.ease.transform(a1.value) - 1.0;
                  return Transform(
                    transform:
                    Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
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
          padding: EdgeInsets.only(right: 8),
        ),
      ],
    );
  }

  Widget _showMain(BuildContext context, DashboardScreenState state) {
    if (state.language != null) {
      Language.language = state.language;
      Language(context);
    }
    return DashboardMenuView(
      innerDrawerKey: _innerDrawerKey,
      dashboardScreenBloc: screenBloc,
      activeBusiness: state.activeBusiness,
      onPersonalInfo: () {},
      onAddBusiness: () {},
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
    } else {
//      return Container();
    }
    List<Widget> dashboardWidgets = [];
    // HEADER
    dashboardWidgets.add(_headerView(state));
    // SEARCH BAR
    dashboardWidgets.add(_searchBar(state));

    // TRANSACTIONS
    List<AppWidget> appWidgets =
        widgets.where((element) => element.type == 'transactions').toList();
    AppWidget appWidget;
    if (appWidgets.length > 0) {
      appWidget = appWidgets[0];
    }
    List bapps = businessApps
        .where((element) => element.code == 'transactions')
        .toList();
    BusinessApps businessApp;
    if (bapps.length > 0) {
      businessApp = bapps.first;
    }
    if (appWidget != null) {
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('transactions')) {
        notifications = state.notifications['transactions'];
      }
      dashboardWidgets.add(DashboardTransactionsView(
        appWidget: appWidget,
        businessApps: businessApp,
        isLoading: state.isInitialScreen,
        total: state.total,
        lastMonth: state.lastMonth,
        lastYear: state.lastYear,
        monthlySum: state.monthlySum,
        onOpen: () {
          _navigateAppsScreen(
              state,
              TransactionScreenInit(
                dashboardScreenBloc: screenBloc,
              )
          );
        },
        onTapContinueSetup: (app) {
          _navigateAppsScreen(
              state,
              WelcomeScreen(
                dashboardScreenBloc: screenBloc,
                business: state.activeBusiness,
                businessApps: app,
              ));
        },
        onTapGetStarted: () {},
        onTapLearnMore: () {},
        notifications: notifications,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
      ));
    }
    // Business Apps
    dashboardWidgets.add(DashboardBusinessAppsView(
      businessApps: state.businessWidgets,
      appWidgets: state.currentWidgets,
      onTapEdit: () {},
      onTapWidget: (BusinessApps aw) {
        Provider.of<GlobalStateModel>(context, listen: false)
            .setCurrentBusiness(state.activeBusiness);
        Provider.of<GlobalStateModel>(context, listen: false)
            .setCurrentWallpaper(state.curWall);
        if (aw.code.contains('transactions')) {
          Navigator.push(
            context,
            PageTransition(
              child: TransactionScreenInit(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
            ),
          );
        } else if (aw.code.contains('pos')) {
          Navigator.push(
            context,
            PageTransition(
              child: PosInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('shop')) {
          Navigator.push(
            context,
            PageTransition(
              child: ShopInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('products')) {
          Navigator.push(
            context,
            PageTransition(
              child: ProductsInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('connect')) {
          Navigator.push(
            context,
            PageTransition(
              child: ConnectInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('contact')) {
          Navigator.push(
            context,
            PageTransition(
              child: ContactsInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('checkout')) {
          Navigator.push(
            context,
            PageTransition(
              child: CheckoutInitScreen(
                dashboardScreenBloc: screenBloc,
                checkouts: state.checkouts,
                defaultCheckout: state.defaultCheckout,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        } else if (aw.code.contains('settings')) {
          Navigator.push(
            context,
            PageTransition(
              child: SettingInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
            ),
          );
        }
      },
    ));

    // Shop
    if (widgets.where((element) => element.type == 'shop').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'shop').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'shop')
          .toList()
          .first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('shops')) {
        notifications = state.notifications['shops'];
      }
      dashboardWidgets.add(
        DashboardShopView(
          businessApps: businessApp,
          appWidget: appWidget,
          shops: state.shops,
          shopModel: state.activeShop,
          isLoading: state.isLoading,
          onOpen: () {
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            Navigator.push(
              context,
              PageTransition(
                child: ShopInitScreen(
                  dashboardScreenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          onTapEditShop: () {
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            Navigator.push(
              context,
              PageTransition(
                child: ShopInitScreen(
                  dashboardScreenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
          notifications: notifications,
          openNotification: (NotificationModel model) {
            if (model.app == 'products-aware' &&
                model.message.contains('newProduct')) {
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: ProductsInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 500),
                ),
              );
            }
          },
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
          onTapGetStarted: () {},
          onTapContinueSetup: () {},
          onTapLearnMore: (url) {
            _launchURL(url);
          },
        ),
      );
    }

    // Point of Sale
    if (widgets.where((element) => element.type == 'pos').toList().length > 0) {
      appWidget =
          widgets.where((element) => element.type == 'pos').toList().first;
      businessApp =
          businessApps.where((element) => element.code == 'pos').toList().first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('pos')) {
        notifications = state.notifications['pos'];
      }
      dashboardWidgets.add(DashboardAppPosView(
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
          if ((result != null) && (result == 'Terminal Updated')) {
            screenBloc.add(FetchPosEvent(business: state.activeBusiness));
          }
        },
        onTapOpen: () {
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentBusiness(state.activeBusiness);
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentWallpaper(state.curWall);
          Navigator.push(
            context,
            PageTransition(
              child: PosInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
        notifications: notifications,
        openNotification: (NotificationModel model) {
          if (model.app == 'products-aware' &&
              model.message.contains('newProduct')) {
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            Navigator.push(
              context,
              PageTransition(
                child: ProductsInitScreen(
                  dashboardScreenBloc: screenBloc,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        },
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
        openLearnMore: (url) {
          _launchURL(url);
        },
      ));
    }

    // Checkout
    if (widgets.where((element) => element.type == 'checkout').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'checkout').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'checkout')
          .toList()
          .first;
      if (appWidget != null) {
        List<NotificationModel> notifications = [];
        if (state.notifications.containsKey('checkout')) {
          notifications = state.notifications['checkout'];
        }
        dashboardWidgets.add(DashboardCheckoutView(
          businessApps: businessApp,
          appWidget: appWidget,
          notifications: notifications,
          checkouts: state.checkouts,
          defaultCheckout: state.defaultCheckout,
          openNotification: (NotificationModel model) {},
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
          onOpen: () {
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            Navigator.push(
              context,
              PageTransition(
                child: CheckoutInitScreen(
                  dashboardScreenBloc: screenBloc,
                  checkouts: state.checkouts,
                  defaultCheckout: state.defaultCheckout,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
          },
        ));
      }
    }

    // Mail
//    if (widgets.where((element) => element.type == 'marketing' ).toList().length > 0) {
//      appWidget = widgets.where((element) => element.type == 'marketing' ).toList().first;
//      businessApp = businessApps.where((element) => element.code == 'marketing' ).toList().first;
//      List<NotificationModel> notifications = [];
//      if (state.notifications.containsKey('marketing')){
//        notifications = state.notifications['marketing'];
//      }
//      dashboardWidgets.add(
//          DashboardMailView(
//            businessApps: businessApp,
//            appWidget: appWidget,
//            notifications: notifications,
//            openNotification: (NotificationModel model) {
//            },
//            deleteNotification: (NotificationModel model) {
//              screenBloc.add(DeleteNotification(notificationId: model.id));
//            },
//          )
//      );
//    }

    // Studio
//    if (widgets.where((element) => element.type == 'studio' ).toList().length > 0) {
//      appWidget = widgets.where((element) => element.type == 'studio' ).toList().first;
//      businessApp = businessApps.where((element) => element.code == 'studio' ).toList().length > 0
//          ? businessApps.where((element) => element.code == 'studio' ).toList().first : null;
//      List<NotificationModel> notifications = [];
//      if (state.notifications.containsKey('studio')){
//        notifications = state.notifications['studio'];
//      }
//      dashboardWidgets.add(
//          DashboardStudioView(
//            businessApps: businessApp,
//            appWidget: appWidget,
//            notifications: notifications,
//            openNotification: (NotificationModel model) {
//            },
//            deleteNotification: (NotificationModel model) {
//              screenBloc.add(DeleteNotification(notificationId: model.id));
//            },
//          )
//      );
//    }

    // Ads
//    if (widgets.where((element) => element.type == 'ads' ).toList().length > 0) {
//      appWidget = widgets.where((element) => element.type == 'ads' ).toList().first;
//      businessApp = businessApps.where((element) => element.code == 'ads' ).toList().length > 0
//          ? businessApps.where((element) => element.code == 'ads' ).toList().first : null;
//      List<NotificationModel> notifications = [];
//      if (state.notifications.containsKey('ads')){
//        notifications = state.notifications['ads'];
//      }
//      dashboardWidgets.add(
//          DashboardAdvertisingView(
//            businessApps: businessApp,
//            appWidget: appWidget,
//            notifications: notifications,
//            openNotification: (NotificationModel model) {
//            },
//            deleteNotification: (NotificationModel model) {
//              screenBloc.add(DeleteNotification(notificationId: model.id));
//            },
//          )
//      );
//    }

    // Contacts
    if (widgets.where((element) => element.type == 'contacts').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'contacts').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'contacts')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'contacts')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('contacts')) {
        notifications = state.notifications['contacts'];
      }
      dashboardWidgets.add(DashboardContactView(
        businessApps: businessApp,
        appWidget: appWidget,
        notifications: notifications,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
      ));
    }

    // Products
    if (widgets.where((element) => element.type == 'products').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'products').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'products')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'products')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.keys.toList().contains('products')) {
        notifications = state.notifications['products'];
      }
      dashboardWidgets.add(
        DashboardProductsView(
          businessApps: businessApp,
          appWidget: appWidget,
          lastSales: state.lastSalesRandom,
          business: state.activeBusiness,
          onOpen: () async {
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            Navigator.push(
              context,
              PageTransition(
                child: ProductsInitScreen(
                  dashboardScreenBloc: screenBloc,
                ),
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

            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentBusiness(state.activeBusiness);
            Provider.of<GlobalStateModel>(context, listen: false)
                .setCurrentWallpaper(state.curWall);
            final result = await Navigator.push(
              context,
              PageTransition(
                child: ProductDetailScreen(
                  productsModel: productsModel,
                  businessId: globalStateModel.currentBusiness.id,
                  fromDashBoard: true,
                  screenBloc:
                      ProductsScreenBloc(dashboardScreenBloc: screenBloc),
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 500),
              ),
            );
            if ((result != null) && (result == 'Products Updated')) {}
          },
          notifications: notifications,
          openNotification: (NotificationModel model) {
            if (model.message.contains('missing')) {
              String productId = '';
              if (model.data != null) {
                if (model.data['productId'] != null) {
                  productId = model.data['productId'];
                }
              }
              if (productId != '') {
                Provider.of<GlobalStateModel>(context, listen: false)
                    .setCurrentBusiness(state.activeBusiness);
                Provider.of<GlobalStateModel>(context, listen: false)
                    .setCurrentWallpaper(state.curWall);
                Navigator.push(
                  context,
                  PageTransition(
                    child: ProductDetailScreen(
                      productsModel: ProductsModel(id: productId),
                      businessId: globalStateModel.currentBusiness.id,
                      fromDashBoard: true,
                      screenBloc:
                          ProductsScreenBloc(dashboardScreenBloc: screenBloc),
                    ),
                    type: PageTransitionType.fade,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              }
            }
          },
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
        ),
      );
    }

    // Connects
    if (widgets.where((element) => element.type == 'connect').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'connect').toList().first;
      businessApp = businessApps
                  .where((element) => element.code == 'connect')
                  .toList()
                  .length >
              0
          ? businessApps
              .where((element) => element.code == 'connect')
              .toList()
              .first
          : null;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('connect')) {
        notifications = state.notifications['connect'];
      }
      dashboardWidgets.add(DashboardConnectView(
        businessApps: businessApp,
        appWidget: appWidget,
        notifications: notifications,
        connects: state.connects,
        openNotification: (NotificationModel model) {},
        deleteNotification: (NotificationModel model) {
          screenBloc.add(DeleteNotification(notificationId: model.id));
        },
        tapOpen: () {
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentBusiness(state.activeBusiness);
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentWallpaper(state.curWall);
          Navigator.push(
            context,
            PageTransition(
              child: ConnectInitScreen(
                dashboardScreenBloc: screenBloc,
              ),
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 500),
            ),
          );
        },
      ));
    }

    // Settings
    if (widgets.where((element) => element.type == 'settings').toList().length >
        0) {
      appWidget =
          widgets.where((element) => element.type == 'settings').toList().first;
      businessApp = businessApps
          .where((element) => element.code == 'settings')
          .toList()
          .first;
      List<NotificationModel> notifications = [];
      if (state.notifications.containsKey('settings')) {
        notifications = state.notifications['settings'];
      }
      dashboardWidgets.add(DashboardSettingsView(
          businessApps: businessApp,
          appWidget: appWidget,
          notifications: notifications,
          openNotification: (NotificationModel model) {},
          deleteNotification: (NotificationModel model) {
            screenBloc.add(DeleteNotification(notificationId: model.id));
          },
          onTapOpen: () {
            print(businessApp.setupStatus);
            if (businessApp.setupStatus == 'notStarted') {
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: WelcomeScreen(
                    dashboardScreenBloc: screenBloc,
                    business: state.activeBusiness,
                    businessApps: businessApp,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 50),
                ),
              );
            } else {
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(state.activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(state.curWall);
              Navigator.push(
                context,
                PageTransition(
                  child: SettingInitScreen(
                    dashboardScreenBloc: screenBloc,
                  ),
                  type: PageTransitionType.fade,
                  duration: Duration(milliseconds: 300),
                ),
              );
            }
          },
          onTapOpenWallpaper: () async {
            Navigator.push(
              context,
              PageTransition(
                child: WallpaperScreen(
                  globalStateModel: globalStateModel,
                  setScreenBloc: SettingScreenBloc(
                    dashboardScreenBloc: screenBloc,
                    globalStateModel: globalStateModel,
                  )..add(SettingScreenInitEvent(
                    business: state.activeBusiness.id,
                  )),
                  fromDashboard: true,
                ),
                type: PageTransitionType.fade,
                duration: Duration(milliseconds: 300),
              ),
            );
          },
          onTapOpenLanguage: () {
            Navigator.push(
              context,
              PageTransition(
                child: LanguageScreen(
                  globalStateModel: globalStateModel,
                  settingBloc: SettingScreenBloc(
                    dashboardScreenBloc: screenBloc,
                    globalStateModel: globalStateModel,
                  )..add(SettingScreenInitEvent(
                    business: state.activeBusiness.id,
                    user: state.user,
                  )),
                  fromDashboard: true,
                ),
                type: PageTransitionType.fade,
              ),
            );
          }));
    }

    // Tutorials
    dashboardWidgets.add(DashboardTutorialView(
      tutorials: state.tutorials,
      onWatchTutorial: (Tutorial tutorial) {
        if (tutorial.urls.length > 0) {
          String lang = state.activeBusiness.defaultLanguage;
          List<Urls> urls = tutorial.urls
              .where((element) => element.language == lang)
              .toList();
          if (urls.length > 0) {
            _launchURL(urls.first.url);
          } else {
            _launchURL(tutorial.url);
          }
        } else {
          _launchURL(tutorial.url);
        }
      },
    ));

    // Paddings
    dashboardWidgets.add(Padding(
      padding: EdgeInsets.only(top: 24),
    ));

    return Scaffold(
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
          fillColor: overlayColor(),
          child: SvgPicture.asset(
            'assets/images/help.svg',
            width: 24,
            color: iconColor(),
          ),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        top: true,
        child: BackgroundBase(
          false,
          backgroundColor: Colors.transparent,
          wallPaper: state.curWall,
          body: Container(
            alignment: Alignment.center,
            child: Container(
              width: Measurements.width,
              child: RefreshIndicator(
                onRefresh: () {
                  screenBloc
                      .add(DashboardScreenInitEvent(wallpaper: state.curWall));
                  return Future.delayed(Duration(seconds: 3));
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'grow your business',
          style: TextStyle(
            fontSize: 18,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3,
                color: Colors.black45,
              ),
            ],
            color: Colors.white,
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
            SvgPicture.asset(
              'assets/images/search_place_holder.svg',
              color: iconColor(),
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
                      ),
                      style: TextStyle(
                        fontSize: 14,
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
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                        if ((result != null) && (result == 'changed')) {
                          setState(() {
                            searchString = '';
                            searchController.text = searchString;
                            FocusScope.of(context).unfocus();
                          });
                          screenBloc.add(DashboardScreenInitEvent(
                              wallpaper: globalStateModel.currentWallpaper));
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
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
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
                          color: overlayBackground(),
                          elevation: 0,
                          height: 20,
                          minWidth: 20,
                          child: SvgPicture.asset(
                            'assets/images/closeicon.svg',
                            width: 8,
                            color: iconColor(),
                          ),
                        ),
                  searchController.text.isEmpty
                      ? Container()
                      : MaterialButton(
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
                                duration: Duration(milliseconds: 500),
                              ),
                            );
                            if ((result != null) && (result == 'changed')) {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                              screenBloc.add(DashboardScreenInitEvent(
                                  wallpaper:
                                      globalStateModel.currentWallpaper));
                            } else {
                              setState(() {
                                searchString = '';
                                searchController.text = searchString;
                                FocusScope.of(context).unfocus();
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: overlayBackground(),
                          elevation: 0,
                          minWidth: 0,
                          height: 20,
                          child: Text(
                            'Search',
                            style: TextStyle(
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

  _navigateAppsScreen(DashboardScreenState state, Widget widget) {
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentBusiness(state.activeBusiness);
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentWallpaper(state.curWall);
    Navigator.push(
      context,
      PageTransition(
        child: widget,
        type: PageTransitionType.fade,
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
