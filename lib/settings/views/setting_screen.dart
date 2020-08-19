import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/blocs/dashboard/dashboard_bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/commons/utils/translations.dart';
import 'package:payever/commons/view_models/global_state_model.dart';
import 'package:payever/commons/views/custom_elements/wallpaper.dart';
import 'package:payever/dashboard/sub_view/dashboard_menu_view.dart';
import 'package:payever/login/login_screen.dart';
import 'package:payever/notifications/notifications_screen.dart';
import 'package:payever/search/views/search_screen.dart';
import 'package:payever/settings/models/models.dart';
import 'package:payever/settings/views/business_info_screen.dart';
import 'package:payever/settings/views/wallpaper/wallpaper_screen.dart';
import 'package:payever/switcher/switcher_page.dart';
import 'package:provider/provider.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_details/business_details_screen.dart';

class SettingInitScreen extends StatelessWidget {

  final DashboardScreenBloc dashboardScreenBloc;

  const SettingInitScreen({this.dashboardScreenBloc});

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    return SettingScreen(
      globalStateModel: globalStateModel,
      dashboardScreenBloc: dashboardScreenBloc,
    );
  }
}

class SettingScreen extends StatefulWidget {

  final GlobalStateModel globalStateModel;
  final DashboardScreenBloc dashboardScreenBloc;

  const SettingScreen({this.globalStateModel, this.dashboardScreenBloc});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  bool _isPortrait;
  bool _isTablet;
  double iconSize;
  double margin;
  List<Country> countryList;
  final GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  SettingScreenBloc screenBloc;

  @override
  void initState() {
    screenBloc = SettingScreenBloc(dashboardScreenBloc: widget.dashboardScreenBloc, globalStateModel: widget.globalStateModel);
    screenBloc.add(SettingScreenInitEvent(
      business: widget.globalStateModel.currentBusiness.id,
    ));
    prepareDefaultCountries().then((value) =>countryList = value);
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
        if (state is SettingScreenStateFailure) {
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
                  child: LoginScreen(), type: PageTransitionType.fade,
                ),
              );
            },
            onSwitchBusiness: () async {
              final result = await Navigator.pushReplacement(
                context,
                PageTransition(
                  child: SwitcherScreen(),
                  type: PageTransitionType.fade,
                ),
              );
              if (result == 'refresh') {
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

  Widget _appBar(SettingScreenState state) {
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
    String avatarName = '';
    if (widget.globalStateModel.currentBusiness != null) {
      String name = widget.globalStateModel.currentBusiness.name;
      if (name.contains(' ')) {
        avatarName = name.substring(0, 1);
        avatarName = avatarName + name.split(' ')[1].substring(0, 1);
      } else {
        avatarName = name.substring(0, 1) + name.substring(name.length - 1);
        avatarName = avatarName.toUpperCase();
      }
    } else {
      return Container();
    }
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomPadding: false,
        appBar: _appBar(state),
        body: SafeArea(
          child: BackgroundBase(
            true,
            backgroudColor: Color.fromRGBO(20, 20, 0, 0.4),
            body: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        widget.globalStateModel.currentBusiness.logo != null ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffa0a7aa),
                            image: DecorationImage(
                              image: NetworkImage('$imageBase${widget.globalStateModel.currentBusiness.logo}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ):
                        Container(
                          width: 100,
                          height: 100,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffa0a7aa),
                            child: Text(
                              avatarName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          widget.globalStateModel.currentBusiness.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                    GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) =>
                            _itemBuilder(state, index),
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 4 / 4, crossAxisCount: (_isTablet || !_isPortrait) ? 3 : 2),
                        itemCount: 7,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(SettingScreenState state, int index) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => _onTileClicked(index),
          child: Container(
            padding: EdgeInsets.all(16),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: SvgPicture.asset(
              settingItems[index].image,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(settingItems[index].name)
      ],
    );
  }

  void _onTileClicked(int index) {
    Widget _target;

    switch (index) {
      case 0:
        _target = BusinessInfoScreen(globalStateModel: widget.globalStateModel, setScreenBloc: screenBloc,);
        break;
      case 1:
        _target = BusinessDetailsScreen(globalStateModel: widget.globalStateModel, setScreenBloc: screenBloc, countryList: countryList,);
        break;
      case 2:
        _target = WallpaperScreen(globalStateModel: widget.globalStateModel, setScreenBloc: screenBloc,);
        break;
      default:
        _target = WallpaperScreen(globalStateModel: widget.globalStateModel, setScreenBloc: screenBloc,);
        break;
    }
    if (_target == null) return;
    Navigator.push(
      context,
      PageTransition(
        child: _target,
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 50),
      ),
    );
    debugPrint("You tapped on item $index");
  }
}
