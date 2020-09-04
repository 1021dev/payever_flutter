import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/checkout/models/models.dart';
import 'package:payever/commons/models/user.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/general/password_screen.dart';
import 'package:payever/settings/views/general/personal_information_screen.dart';
import 'package:payever/settings/views/general/shipping_addresses_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/theme.dart';
import 'package:provider/provider.dart';

class PersonalSettingInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  PersonalSettingInitScreen({
    this.dashboardScreenBloc,
  });

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return PersonalSettingScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class PersonalSettingScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;
  final List<Checkout> checkouts;
  final Checkout defaultCheckout;

  PersonalSettingScreen({
    this.globalStateModel,
    this.dashboardScreenBloc,
    this.checkouts = const [],
    this.defaultCheckout,
  });

  @override
  State<StatefulWidget> createState() {
    return _PersonalSettingScreenState();
  }
}

class _PersonalSettingScreenState extends State<PersonalSettingScreen> {
  bool _isPortrait;
  bool _isTablet;

  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double iconSize;
  double margin;

  int selectedIndex = 0;
  SettingScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = SettingScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel)
      ..add(SettingScreenInitEvent(
        business: widget.globalStateModel.currentBusiness.id,
        user: widget.dashboardScreenBloc.state.user,
      ));
    super.initState();
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
      listener: (BuildContext context, SettingScreenState state) async {
        if (state is CheckoutScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<SettingScreenBloc, SettingScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, SettingScreenState state) {
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

  Widget _appBar(SettingScreenState state) {
    User user = widget.dashboardScreenBloc.state.user;
    String name, logo;
    if (user != null) {
      name = user.fullName ?? '';
      if (user.logo != null)
        logo =
            'https://payeverproduction.blob.core.windows.net/images/${user.logo}';
    }

    return AppBar(
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      bottom: TabBar(
        isScrollable: true,
        indicatorColor: Colors.white70,
        onTap: (index) {
          if (index == 1) {
          } else if (index == 2) {
          } else if (index == 3) {
          } else if (index == 4) {}
        },
        tabs: <Widget>[
          Tab(
            text: 'Personal information',
          ),
          Tab(
            text: 'Language',
          ),
          Tab(
            text: 'Shipping address',
          ),
          Tab(
            text: 'Password',
          ),
          Tab(
            text: 'Email notification',
          ),
          Tab(
            text: 'Wallpapers',
          ),
        ],
      ),
      title: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                child: SvgPicture.asset(
                  'assets/images/setting.svg',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
          ),
          Text(
            Language.getCommerceOSStrings('dashboard.apps.settings'),
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
                BusinessLogo(
                  url: logo,
                ),
                _isTablet || !_isPortrait
                    ? Padding(
                        padding: EdgeInsets.only(left: 4, right: 4),
                        child: Text(
                          name,
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
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    businessId:
                        widget.dashboardScreenBloc.state.activeBusiness.id,
                    searchQuery: '',
                    appWidgets: widget.dashboardScreenBloc.state.currentWidgets,
                    activeBusiness:
                        widget.dashboardScreenBloc.state.activeBusiness,
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
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentBusiness(
                      widget.dashboardScreenBloc.state.activeBusiness);
              Provider.of<GlobalStateModel>(context, listen: false)
                  .setCurrentWallpaper(
                      widget.dashboardScreenBloc.state.curWall);

              await showGeneralDialog(
                barrierColor: null,
                transitionBuilder: (context, a1, a2, wg) {
                  final curvedValue = Curves.ease.transform(a1.value) - 1.0;
                  return Transform(
                    transform:
                        Matrix4.translationValues(-curvedValue * 200, 0.0, 0),
                    child: NotificationsScreen(
                      business: widget.dashboardScreenBloc.state.activeBusiness,
                      businessApps:
                          widget.dashboardScreenBloc.state.businessWidgets,
                      dashboardScreenBloc: widget.dashboardScreenBloc,
                      type: 'transactions',
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

  Widget _body(SettingScreenState state) {
    iconSize = _isTablet ? 120 : 80;
    margin = _isTablet ? 24 : 16;
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: overlayBackground(),
        resizeToAvoidBottomPadding: false,
        appBar: _appBar(state),
        body: SafeArea(
          bottom: false,
          child: BackgroundBase(
            true,
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                _getBody(state, 0),
                _getBody(state, 1),
                _getBody(state, 2),
                _getBody(state, 3),
                _getBody(state, 4),
                _getBody(state, 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody(SettingScreenState state, int index) {
    switch (index) {
      case 0:
        return state.user != null
            ? PersonalInformationScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 1:
        return state.user != null
            ? LanguageScreen(
                globalStateModel: widget.globalStateModel,
                settingBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 2:
        return state.user != null
            ? ShippingAddressesScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 3:
        return state.user != null
            ? PasswordScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
      case 4:
        return Container();
      case 5:
        return state.user != null
            ? WallpaperScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: screenBloc,
                isDashboard: false,
              )
            : Container();
    }
    return Container();
  }
}
