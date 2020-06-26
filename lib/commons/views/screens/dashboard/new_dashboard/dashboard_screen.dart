import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/blur_effect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_advertising_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_app_pos.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_business_apps_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_app_detail_cell.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_connect_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_products_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_settings_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_studio_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_transactions_view.dart';
import 'package:payever/commons/views/screens/dashboard/new_dashboard/sub_view/dashboard_tutorial_view.dart';
import 'package:payever/commons/views/screens/login/login_page.dart';
import 'package:payever/commons/views/screens/switcher/switcher_page.dart';
import 'package:payever/transactions/transactions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/env.dart';
import '../../../views.dart';

class DashboardScreen extends StatefulWidget {
  final String wallpaper;

  DashboardScreen({this.wallpaper});

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

  GlobalStateModel globalStateModel;
  @override
  void initState() {
    screenBloc = DashboardScreenBloc();
    screenBloc.add(DashboardScreenInitEvent());
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
    globalStateModel = Provider.of<GlobalStateModel>(context);
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
              imageUrl: widget.wallpaper,
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
  }

  Widget _body(DashboardScreenState state) {
    List<AppWidget> widgets = [];
    if (state.currentWidgets.length > 0) {
      widgets.addAll(state.currentWidgets);//.where((element) => element.order != null));
      widgets.sort((w1, w2) {
        if (w1.order == null) {
          return 1;
        }
        if (w2.order == null) {
          return 1;
        }
        return w2.order.compareTo(w1.order);
      });
    }
    List<Widget> dashboardWidgets = [];
    dashboardWidgets.add(_headerView(state));
    dashboardWidgets.add(_searchBar(state));

    for (int i = 0; i < widgets.length; i++) {
      AppWidget appWidget = widgets[i];
      if (appWidget.type == 'transactions') {
        dashboardWidgets.add(
            DashboardTransactionsView(
              appWidget: appWidget,
              onOpen: () {
                Provider.of<GlobalStateModel>(context,listen: false)
                    .setCurrentBusiness(state.activeBusiness);
                Provider.of<GlobalStateModel>(context,listen: false)
                    .setCurrentWallpaper(state.curWall);
                Navigator.push(
                  context,
                  PageTransition(
                    child: TransactionScreenInit(),
                    type: PageTransitionType.fade,
                  ),
                );
              },
            )
        );
      } else if (appWidget.type == 'apps') {
        dashboardWidgets.add(
            DashboardBusinessAppsView(
              businessApps: state.businessWidgets,
              onTapEdit: () {},
              onTapWidget: (BusinessApps aw) {
                if (aw.dashboardInfo.title.toLowerCase().contains('transactions')) {
                  Provider.of<GlobalStateModel>(context,listen: false)
                      .setCurrentBusiness(state.activeBusiness);
                  Provider.of<GlobalStateModel>(context,listen: false)
                      .setCurrentWallpaper(state.curWall);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: TransactionScreenInit(),
                      type: PageTransitionType.fade,
                    ),
                  );
                }
              },
            )
        );
      } else if (appWidget.type == 'shop') {
        dashboardWidgets.add(
            DashboardAppDetailCell(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'shipping') {
        dashboardWidgets.add(
            DashboardAppDetailCell(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'pos') {
        dashboardWidgets.add(
            DashboardAppPosView(
              appWidget: appWidget,
            )
//            POSCard('pos', NetworkImage(uiKit + appWidget.icon), appWidget.help)
        );
      } else if (appWidget.type == 'checkout') {
        dashboardWidgets.add(
            DashboardAppDetailCell(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'marketing') {
        dashboardWidgets.add(
            DashboardAppDetailCell(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'studio') {
        dashboardWidgets.add(
            DashboardStudioView(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'ads') {
        dashboardWidgets.add(
            DashboardAdvertisingView(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'contacts') {
        dashboardWidgets.add(
            DashboardAppDetailCell(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'products') {
        dashboardWidgets.add(
            DashboardProductsView(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'connect') {
        dashboardWidgets.add(
            DashboardConnectView(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'settings') {
        dashboardWidgets.add(
            DashboardSettingsView(
              appWidget: appWidget,
            )
        );
      } else if (appWidget.type == 'tutorial') {
        dashboardWidgets.add(
            DashboardTutorialView(
              appWidgets: state.currentWidgets,
              appWidget: appWidget,
            )
        );
      }
    }

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
          body: Column(
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
              )
            ],
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
      ],
    );
  }

  Widget _searchBar(DashboardScreenState state) {
    return BlurEffectView(
      radius: 13,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        height: 36,
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search'
                ),
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
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
        Padding(
          padding: EdgeInsets.only(right: 16),
        ),
      ],
    );
  }
}
