import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/blur_effect_view.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/business_logo.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/dashboard/sub_view/dashboard_settings_view.dart';
import 'package:payever/dashboard/sub_view/dashboard_transactions_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/views/general/language_screen.dart';
import 'package:payever/settings/views/setting_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';

import 'package:payever/theme.dart';
import 'package:payever/transactions/views/transactions_screen.dart';
import 'package:payever/welcome/welcome_screen.dart';
import 'package:payever/widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:payever/blocs/bloc.dart';

class PersonalInitScreen extends StatelessWidget {
  final DashboardScreenBloc dashboardScreenBloc;

  const PersonalInitScreen({this.dashboardScreenBloc});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    return PersonalScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class PersonalScreen extends StatefulWidget {
  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  PersonalScreen({this.globalStateModel, this.dashboardScreenBloc});

  @override
  _PersonalScreenState createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;

  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PersonalScreenBloc screenBloc;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String searchString = '';
  Business activeBusiness;
  String currentWallpaper;

  @override
  void initState() {
    screenBloc = PersonalScreenBloc(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        globalStateModel: widget.globalStateModel);
    screenBloc.add(PersonalScreenInitEvent(
      business: widget.globalStateModel.currentBusiness.id,
      user: widget.dashboardScreenBloc.state.user,
    ));

    activeBusiness = widget.globalStateModel.currentBusiness;
    currentWallpaper = widget.dashboardScreenBloc.state.curWall;

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
      listener: (BuildContext context, PersonalScreenState state) async {
        if (state is PersonalScreenStateFailure) {
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LoginScreen(),
              type: PageTransitionType.fade,
            ),
          );
        }
      },
      child: BlocBuilder<PersonalScreenBloc, PersonalScreenState>(
        bloc: screenBloc,
        builder: (BuildContext context, PersonalScreenState state) {
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

  Widget _body(PersonalScreenState state) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: MainAppbar(
        dashboardScreenBloc: widget.dashboardScreenBloc,
        dashboardScreenState: widget.dashboardScreenBloc.state,
        title: 'Personal',
        icon: SvgPicture.asset(
          'assets/images/payeverlogo.svg',
          height: 16,
          width: 24,
        ),
        innerDrawerKey: _innerDrawerKey,
        isDashboard: false,
      ),
      body: SafeArea(
        child: BackgroundBase(
          false,
          backgroundColor: Colors.transparent,
          wallPaper: currentWallpaper,
          body: state.isLoading || state.user == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                alignment: Alignment.topCenter,
                child: Container(
                    width: Measurements.width,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _headerView(state),
                          _searchBar(state),
                          SizedBox(height: 16),
                          _transactionView(state),
                          SizedBox(height: 16),
                          _settingsView(state),
                        ],
                      ),
                    ),
                  ),
              ),
        ),
      ),
    );
  }

  Widget _headerView(PersonalScreenState state) {
    return Column(
      children: [
        SizedBox(height: 60),
        Text(
          'Welcome ${state.user.firstName ?? 'undefined'},',
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

  Widget _searchBar(PersonalScreenState state) {
    return BlurEffectView(
      radius: 12,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      isDashboard: true,
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
//                        final result = await Navigator.push(
//                          context,
//                          PageTransition(
//                            child: SearchScreen(
//                              dashboardScreenBloc: screenBloc,
//                              businessId: state.activeBusiness.id,
//                              searchQuery: searchController.text,
//                              appWidgets: state.currentWidgets,
//                              activeBusiness: state.activeBusiness,
//                              currentWall: state.curWall,
//                            ),
//                            type: PageTransitionType.fade,
//                            duration: Duration(milliseconds: 500),
//                          ),
//                        );
//                        if ((result != null) && (result == 'changed')) {
//                          setState(() {
//                            searchString = '';
//                            searchController.text = searchString;
//                            FocusScope.of(context).unfocus();
//                          });
//                          screenBloc.add(DashboardScreenInitEvent(
//                              wallpaper: globalStateModel.currentWallpaper));
//                        } else {
//                          setState(() {
//                            searchString = '';
//                            searchController.text = searchString;
//                            FocusScope.of(context).unfocus();
//                          });
//                        }
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
//                      FocusScope.of(context).unfocus();
//                      final result = await Navigator.push(
//                        context,
//                        PageTransition(
//                          child: SearchScreen(
//                            dashboardScreenBloc: screenBloc,
//                            businessId: state.activeBusiness.id,
//                            searchQuery: searchController.text,
//                            appWidgets: state.currentWidgets,
//                            activeBusiness: state.activeBusiness,
//                            currentWall: state.curWall,
//                          ),
//                          type: PageTransitionType.fade,
//                          duration: Duration(milliseconds: 500),
//                        ),
//                      );
//                      if ((result != null) && (result == 'changed')) {
//                        setState(() {
//                          searchString = '';
//                          searchController.text = searchString;
//                          FocusScope.of(context).unfocus();
//                        });
//                        screenBloc.add(DashboardScreenInitEvent(
//                            wallpaper:
//                            globalStateModel.currentWallpaper));
//                      } else {
//                        setState(() {
//                          searchString = '';
//                          searchController.text = searchString;
//                          FocusScope.of(context).unfocus();
//                        });
//                      }
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

  Widget _transactionView(PersonalScreenState state) {
    AppWidget appWidget = state.personalWidgets
        .where((element) => element.type.contains('transactions'))
        .first;
    BusinessApps businessApps = state.personalApps
        .where((element) => element.code.contains('transactions'))
        .first;
    return appWidget != null
        ? DashboardTransactionsView(
            appWidget: appWidget,
            businessApps: businessApps,
            onTapContinueSetup: (app) {
              _navigateAppsScreen(
                  state,
                  WelcomeScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    business: activeBusiness,
                    businessApps: app,
                  ));
            },
            onTapGetStarted: (app) {
              _navigateAppsScreen(
                  state,
                  WelcomeScreen(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                    business: activeBusiness,
                    businessApps: app,
                  ));
            },
            onOpen: () {
              _navigateAppsScreen(
                  state,
                  TransactionScreenInit(
                    dashboardScreenBloc: widget.dashboardScreenBloc,
                  ));
            })
        : Container();
  }

  Widget _settingsView(PersonalScreenState state) {
    AppWidget appWidget = state.personalWidgets
        .where((element) => element.type.contains('settings'))
        .first;
    BusinessApps personalApps = state.personalApps
        .where((element) => element.code.contains('settings'))
        .first;
    return DashboardSettingsView(
        businessApps: personalApps,
        appWidget: appWidget,
        openNotification: (NotificationModel model) {},
        onTapOpen: () {
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentBusiness(activeBusiness);
          Provider.of<GlobalStateModel>(context, listen: false)
              .setCurrentWallpaper(currentWallpaper);
          Navigator.push(
            context,
            PageTransition(
              child: SettingInitScreen(
                dashboardScreenBloc: widget.dashboardScreenBloc,
                isDashboard: false,
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
        onTapOpenWallpaper: () async {
          Navigator.push(
            context,
            PageTransition(
              child: WallpaperScreen(
                globalStateModel: widget.globalStateModel,
                setScreenBloc: SettingScreenBloc(
                  dashboardScreenBloc: widget.dashboardScreenBloc,
                  globalStateModel: widget.globalStateModel,
                )..add(SettingScreenInitEvent(
                    business: state.business,
                  )),
                fromDashboard: true,
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
        onTapOpenLanguage: () {
          Navigator.push(
            context,
            PageTransition(
              child: LanguageScreen(
                globalStateModel: widget.globalStateModel,
                settingBloc: SettingScreenBloc(
                  dashboardScreenBloc: widget.dashboardScreenBloc,
                  globalStateModel: widget.globalStateModel,
                )..add(SettingScreenInitEvent(
                    business: state.business,
                    user: state.user,
                  )),
                fromDashboard: true,
              ),
              type: PageTransitionType.fade,
            ),
          );
        });
  }

  _navigateAppsScreen(PersonalScreenState state, Widget target,
      {bool isDuration = false}) {
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentBusiness(activeBusiness);
    Provider.of<GlobalStateModel>(context, listen: false)
        .setCurrentWallpaper(currentWallpaper);
    Navigator.push(
      context,
      PageTransition(
        child: target,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: isDuration ? 500 : 300),
      ),
    );
  }
}
