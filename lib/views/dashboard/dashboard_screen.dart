import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:payever/models/appwidgets.dart';
import 'package:payever/models/business.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/models/pos.dart';
import 'package:payever/models/token.dart';
import 'package:payever/models/user.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/env.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/views/dashboard/dashboard_screen_controller.dart';
import 'dart:convert';
import 'package:payever/views/dashboard/dashboard_screen_navigation.dart';
import 'package:payever/views/dashboard/poscard.dart';
import 'package:payever/views/dashboard/productscard.dart';
import 'package:payever/views/dashboard/searchcard.dart';
import 'package:payever/views/dashboard/settingsCard.dart';
import 'package:payever/views/dashboard/transactioncard.dart';
import 'package:payever/views/login/login_page.dart';
import 'package:payever/views/pos/native_pos_screen.dart';
import 'package:payever/views/products/product_screen.dart';
import 'package:payever/views/settings/employees/employees_screen.dart';
import 'package:payever/views/settings/settings_screen.dart';

import 'package:payever/views/switcher/switcher_page.dart';
import 'package:payever/views/transactions/transactions_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DashboardMidScreen extends StatefulWidget {
  SharedPreferences prefs;
  String wallpaper;

  DashboardMidScreen(this.wallpaper) {
    SharedPreferences.getInstance().then((p) {
      prefs = p;
    });
  }

  @override
  _DashboardMidScreenState createState() => _DashboardMidScreenState();
}

class _DashboardMidScreenState extends State<DashboardMidScreen> {
  final _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p){

      Language.LANGUAGE = widget.prefs.getString(GlobalUtils.LANGUAGE);
      Language(context);

    SharedPreferences.getInstance().then((p) {
      Language.LANGUAGE = widget.prefs.getString(GlobalUtils.LANGUAGE);
      Language(context);
    });

    _loadUserData();
  });
  }

  void _loadUserData() async {
    var dataLoaded = await loadData();

    if (dataLoaded != null) {
      //print("dataLoaded: $dataLoaded");
      var data = json.decode(dataLoaded);
      var responseMsg = data['responseMsg'];

      print("responseMsg: $responseMsg");
      switch (responseMsg) {
        case "refreshToken":
          return _fetchUserData(data['token'], false);
          break;
        case "refreshTokenLogin":
          return _fetchUserData(data['token'], true);
          break;
        case "error":
          return Future.delayed(Duration(milliseconds: 1500))
              .then((_) => _loadUserData());
          break;
        case "goToLogin":
          return _redirectUser();
          break;
        default:
          break;
      }
    }
  }

  void _redirectUser() {
    Navigator.pushReplacement(_formKey.currentContext,
        PageTransition(child: LoginScreen(), type: PageTransitionType.fade));
  }

  void _fetchUserData(dynamic token, bool renew) async {
    List<AppWidget> wids = List();
    Business activeBusiness;
    var _token = !renew ? Token.map(token) : token;
    GlobalUtils.ActiveToken = _token;
    SharedPreferences.getInstance().then((prefs) {
      if (!renew)
        GlobalUtils.ActiveToken.refreshToken =
            prefs.getString(GlobalUtils.REFRESHTOKEN);
      prefs.setString(GlobalUtils.TOKEN, GlobalUtils.ActiveToken.accessToken);
      prefs.setString(
          GlobalUtils.REFRESHTOKEN, GlobalUtils.ActiveToken.refreshToken);
      prefs.setString(GlobalUtils.LAST_OPEN, DateTime.now().toString());
      RestDatasource()
          .getUser(GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
          .then((user) {
        User tempUser = User.map(user);
        if (tempUser.language != prefs.getString(GlobalUtils.LANGUAGE)) {
          Language.LANGUAGE = tempUser.language;
          Language(_formKey.currentContext);
        }
        Measurements.loadImages(_formKey.currentContext);
      });
      RestDatasource()
          .getWidgets(prefs.getString(GlobalUtils.BUSINESS),
              GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
          .then((obj) {
        obj.forEach((item) {
          wids.add(AppWidget.map(item));
        });
        RestDatasource()
            .getBusinesses(
                GlobalUtils.ActiveToken.accessToken, _formKey.currentContext)
            .then((result) {
          result.forEach((item) {
            parts.businesses.add(Business.map(item));
          });
          if (parts.businesses != null) {
            parts.businesses.forEach((b) {
              if (b.id == prefs.getString(GlobalUtils.BUSINESS)) {
                activeBusiness = b;
              }
            });
          }

          RestDatasource()
              .getWallpaper(activeBusiness.id,
                  GlobalUtils.ActiveToken.accessToken, context)
              .then((wall) {
            String wallpaper = wall[GlobalUtils.CURRENT_WALLPAPER];
            prefs.setString(GlobalUtils.WALLPAPER, WALLPAPER_BASE + wallpaper);

            Navigator.pushReplacement(
                _formKey.currentContext,
                PageTransition(
                    child: DashboardScreen(
                        GlobalUtils.ActiveToken,
                        prefs.getString(GlobalUtils.WALLPAPER),
                        activeBusiness,
                        wids,
                        null),
                    type: PageTransitionType.fade,duration: Duration(milliseconds: 300)));
          });
        });
      }).catchError((onError) {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    print("Language - ${myLocale.languageCode}");
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    bool isTablet = MediaQuery.of(context).size.width > 600;

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
              key: _formKey,
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

  Future<dynamic> loadData() async {
    RestDatasource api = RestDatasource();
    var prefs = await SharedPreferences.getInstance();
    widget.prefs = prefs;
    var environment = await api.getEnv();
    Env.map(environment);
    if (DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(
                Measurements.parseJwt(
                        prefs.getString(GlobalUtils.REFRESHTOKEN))["exp"] *
                    1000))
            .inHours <
        0) {
      try {
        var refreshToken = await api.refreshToken(
            prefs.getString(GlobalUtils.REFRESHTOKEN),
            prefs.getString(GlobalUtils.FINGERPRINT),
            context);
        if (refreshToken != null) {
          return json.encode({
            "responseMsg": "refreshToken",
            "token": refreshToken,
            "renew": false,
          });
        } else {
          return json.encode({
            "responseMsg": "error",
            "token": "",
            "renew": false,
          });
        }
      } catch (e) {
        if (e.toString().contains("SocketException")) {
          return _loadUserData();
        } else {
          return json.encode({
            "responseMsg": "goToLogin",
            "token": "",
            "renew": false,
          });
        }
      }
    } else {
      if (DateTime.now()
              .difference(
                  DateTime.parse(prefs.getString(GlobalUtils.LAST_OPEN)))
              .inHours <
          720) {
        try {
          var refreshTokenLogin = await RestDatasource().login(
              prefs.getString(GlobalUtils.EMAIL),
              prefs.getString(GlobalUtils.PASSWORD),
              prefs.getString(GlobalUtils.fingerprint));
          if (refreshTokenLogin != null) {
            return json.encode({
              "responseMsg": "refreshTokenLogin",
              "token": refreshTokenLogin,
              "renew": false,
            });
          } else {
            return json.encode({
              "responseMsg": "error",
              "token": "",
              "renew": false,
            });
          }
        } catch (e) {
          if (e.toString().contains("SocketException")) {
            return _loadUserData();
          } else {
            return json.encode({
              "responseMsg": "goToLogin",
              "token": "",
              "renew": false,
            });
          }
        }
      }
    }
  }
}

class DashboardScreen extends StatefulWidget {
  Token _token;
  User _logUser;
  String _wallpaper;
  Business _business;
  List<AppWidget> _appWids;
  bool _isBusiness;

  DashboardScreen(this._token, this._wallpaper, this._business, this._appWids,
      this._logUser) {
    CardParts._currentToken = this._token;
    CardParts._currentBusiness = this._business;
    CardParts._currentWidgets = this._appWids;
    CardParts.wallpaper = this._wallpaper;
    CardParts._currentUser = this._logUser;
    _isBusiness = _logUser == null;
    CardParts._isBusiness = _isBusiness;
  }

  @override
  _DashboardScreenState createState() => _DashboardScreenState(_isBusiness);
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin
    implements DashboardStateListener {
  GlobalStateModel globalStateModel;

  final Dashboard _dashboard = Dashboard();
  final Apps _apps = Apps();
  final Menu _menu = Menu();
  final Notifications _notifications = Notifications();
  final List<Widget> _screens = List();
  bool _isBusiness;

  TabController _controller;
  AppBar _appbar = new AppBar();

  bool _isLoading = true;
  List<NavigationIconView> _navigationViews;
  int _currentIndex = 0;

  bool _isSearching = false;
  bool _waitingForSearch = false;
  final TextEditingController _filter = new TextEditingController();
  var _searchText = ValueNotifier("");

  _DashboardScreenState(this._isBusiness) {
    _isSearching = false;
    var listen = DashboardStateProvider();
    listen.subscribe(this);
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState((){
          _searchText.value = "";
        });
      } else {
        setState(() {
          _searchText.value = _filter.text;
          _searchText.notifyListeners();
        });
      }
    });
  }

  Future<void> uiBuild() async {
    CardParts._activeWid = List();
    for (int i = 0; i < CardParts._currentWidgets.length; i++) {
      var wid = CardParts._currentWidgets[i];

      switch (wid.type) {
        case "transactions":
          CardParts.indexes.add(i);
          CardParts._activeWid.add(CardParts._transtioncard = TransactionCard(
              wid.type,
              NetworkImage(CardParts.UI_KIT + wid.icon),
              //CardParts._currentBusiness,
              _isBusiness,
              //CardParts.wallpaper
              ));
          break;
        case "pos":
          CardParts.indexes.add(i);
          CardParts._activeWid.add(CardParts._poscard = POSCard(
              wid.type,
              NetworkImage(CardParts.UI_KIT + wid.icon),
              //CardParts._currentBusiness,
              //CardParts.wallpaper,
              wid.help));
          break;
        case "products":
          CardParts.indexes.add(i);
          CardParts._activeWid.add(CardParts._productsCard = ProductsCard(
              wid.type,
              NetworkImage(CardParts.UI_KIT + wid.icon),
              // CardParts._currentBusiness,
              // CardParts.wallpaper,
              wid.help));
          break;
        case "settings":
          CardParts.indexes.add(i);
          CardParts._activeWid.add(CardParts._settingsCard = SettingsCard(
              wid.type,
              NetworkImage(CardParts.UI_KIT + wid.icon),
              // CardParts._currentBusiness,
              // CardParts.wallpaper,
              wid.help));
          break;
        default:
      }
    }

    GlobalUtils.IS_DASHBOARD_LOADED = true;
    var authStateProvider = DashboardStateProvider();
    authStateProvider.notify(LoadState.LOADED).then((bool r) {
      var authStateProvider = DashboardStateProvider();
      authStateProvider.dispose(this);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller =
        TabController(length: 3, vsync: this); //NOTIFICATIONS OUT LENGTH CHECK
    super.initState();
    uiBuild();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/dashboardicon.svg",
                color: Colors.white.withOpacity(0.3),
                height: Measurements.height *
                    (CardParts._isTablet ? 0.012 : 0.02))),
        activeIcon: Container(
            child: SvgPicture.asset("images/dashboardicon.svg",
                color: Colors.white,
                height: Measurements.height *
                    (CardParts._isTablet ? 0.015 : 0.02))),
        title: Language.getCustomStrings("dashboard.navigation.overview"),
        vsync: this,
        tablet: CardParts._isTablet,
      ),
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/appsicon.svg",
                color: Colors.white.withOpacity(0.3),
                height: Measurements.height *
                    (CardParts._isTablet ? 0.012 : 0.02))),
        activeIcon: Container(
            child: SvgPicture.asset("images/appsicon.svg",
                color: Colors.white,
                height: Measurements.height *
                    (CardParts._isTablet ? 0.015 : 0.02))),
        title: Language.getCustomStrings("dashboard.navigation.apps"),
        vsync: this,
        tablet: CardParts._isTablet,
      ),
      // NavigationIconView(
      //   icon: Container(child: SvgPicture.asset("images/notificationicon.svg",color: Colors.white.withOpacity(0.3),height: Measurements.height *(CardParts._isTablet?0.012: 0.02))),
      //   activeIcon: Container(child: SvgPicture.asset("images/notificationicon.svg",color: Colors.white,height: Measurements.height *(CardParts._isTablet?0.015: 0.02))),
      //   title: 'Notifications',
      //   vsync: this,
      //   tablet: CardParts._isTablet,
      // ),
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/hamburger.svg",
                color: Colors.white.withOpacity(0.3),
                height: Measurements.height *
                    (CardParts._isTablet ? 0.012 : 0.02))),
        activeIcon: Container(
            child: SvgPicture.asset("images/hamburger.svg",
                color: Colors.white,
                height: Measurements.height *
                    (CardParts._isTablet ? 0.015 : 0.02))),
        title: Language.getCustomStrings("dashboard.navigation.menu"),
        tablet: CardParts._isTablet,
        vsync: this,
      ),
    ];
    _navigationViews[_currentIndex].controller.value = 1.0;

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _updateWallPaperBusinessAndAppsWidgets());
  }

  void _updateWallPaperBusinessAndAppsWidgets() {

    globalStateModel.updateWallpaperBusinessAndAppsWidgets(
        widget._wallpaper, widget._business, widget._appWids);

  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = <FadeTransition>[];
    for (NavigationIconView view in _navigationViews)
      transitions.add(view.transition(BottomNavigationBarType.fixed, context));

    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);

    BottomNavigationBar botNavBar;
    botNavBar = BottomNavigationBar(
      items: _navigationViews
          .map<BottomNavigationBarItem>(
              (NavigationIconView navigationView) => navigationView.item)
          .toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.3),
      onTap: (int index) {
        setState(() {
          _navigationViews[_currentIndex].controller.reverse();
          _currentIndex = index;
          _navigationViews[_currentIndex].controller.forward();
          _controller.animateTo(_currentIndex, curve: Curves.linear);
        });
      },
    );
    CardParts._isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (CardParts._isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (CardParts._isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    CardParts._isTablet = Measurements.width < 600 ? false : true;

    Widget inkSearch = InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width:
                      Measurements.width * (CardParts._isTablet ? 0.1 : 0.15),
                  padding: EdgeInsets.all(15),
                  //child: Icon(IconData(58829, fontFamily: 'MaterialIcons')),
                  child: SvgPicture.asset("images/searchicon.svg",
                      color: Colors.white, height: Measurements.height * 0.02)),
              Container(
                  child: Text(
                "Search",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.w300,
                    fontSize: 17),
              ))
            ],
          ),
        ],
      ),
      onTap: () {
        setState(() {
          _isSearching = true;
        });
      },
    );

    Widget searchBar = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              child: Container(
                  width:
                      Measurements.width * (CardParts._isTablet ? 0.1 : 0.15),
                  padding: EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    "images/closeicon.svg",
                    color: Colors.white,
                    height: Measurements.height * 0.015,
                  )),
              onTap: () {
                setState(() {
                  _isSearching = false;
                  _filter.text = "";
                });
              },
            ),
            Container(
              width: (CardParts._isTablet
                      ? Measurements.width * 0.7
                      : Measurements.width *
                          (CardParts._isPortrait ? 0.95 : 1.3)) *
                  0.7,
              child: TextField(
                controller: _filter,
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w300,
                        fontSize: 17)),
              ),
            ),
            Container(
              child:
                  _waitingForSearch ? CircularProgressIndicator() : Container(),
            ),
          ],
        ),
      ],
    );

    _appbar = AppBar(
      toolbarOpacity: 0.0,
      title: Center(
          child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
            child: Container(
              height: CardParts._isTablet
                  ? Measurements.width * 0.06
                  : Measurements.height * (CardParts._isPortrait ? 0.06 : 0.06),
              width: CardParts._isTablet
                  ? Measurements.width * 0.7
                  : Measurements.width * (CardParts._isPortrait ? 0.95 : 1.3),
              color: Colors.black.withOpacity(0.1),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  child: !_isSearching ? inkSearch : searchBar),
            )),
      )),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );

    return Stack(
      overflow: Overflow.visible,
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          top: 0.0,
          child: CachedNetworkImage(
            imageUrl: CardParts.wallpaper,
            placeholder: (context, url) => Container(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: _currentIndex == 0
              ? Colors.transparent
              : _currentIndex == 1
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.6),
          height: Measurements.height,
          width: Measurements.width,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: _currentIndex != 0 ? 25 : 0.1,
              sigmaY: _currentIndex != 0 ? 40 : 0.1,
            ),
            child: Container(
              height: Measurements.height,
              width: Measurements.width,
              child: Scaffold(
                  //appBar: _isLoading || _currentIndex != 0? null : _appbar,
                  bottomNavigationBar: botNavBar,
                  backgroundColor: Colors.transparent,
                  body: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: <Widget>[
                      !_isSearching
                          ? _dashboard
                          : SearchCard(_searchText, widget._business.id),
                      _apps,
                      //Text(""),
                      _menu,
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }

  void backToSwitch() {
    Navigator.pushReplacement(context,
        PageTransition(child: SwitcherScreen(), type: PageTransitionType.fade,duration: Duration(milliseconds: 300)));
  }

  @override
  void onLoadStateChanged(LoadState state) {
    setState(() => _isLoading = false);
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: CardParts._activeWid,
    );
  }
}

class Apps extends StatefulWidget {
  @override
  _AppsState createState() => _AppsState();
}

class _AppsState extends State<Apps> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: Measurements.height * 0.02),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
          child: Container(
              padding: EdgeInsets.only(left: Measurements.width * 0.05),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: CardParts._isBusiness ? 4 : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return AppView(index);
                  })),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  int index;

  AppView(this.index);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
                    child: Container(
                        width: CardParts._isTablet
                            ? Measurements.width * 0.10
                            : Measurements.width * 0.18,
                        height: CardParts._isTablet
                            ? Measurements.width * 0.10
                            : Measurements.width * 0.18,
                        color: Colors.grey.withOpacity(0.3),
                        child: Image.network(
                          CardParts.UI_KIT +
                              CardParts
                                  ._currentWidgets[
                                      CardParts.indexes[widget.index]]
                                  .icon,
                          scale: 1.8,
                        )),
                  )),
              _isLoading ? CircularProgressIndicator() : Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom:
                    Measurements.width * (CardParts._isTablet ? 0.01 : 0.01)),
          ),
          Text(
            Language.getWidgetStrings(
                "widgets.${CardParts._currentWidgets[CardParts.indexes[widget.index]].type}.title"),
            style: TextStyle(fontSize: CardParts._isTablet ? 13 : 12),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          _isLoading = true;
        });
        switch (
            CardParts._currentWidgets[CardParts.indexes[widget.index]].type) {
          case "transactions":
            loadTransactions(context).then((_) {});
            break;
          case "pos":
            loadPOS().then((_) {
              setState(() {
                _isLoading = false;
              });
            });
            break;
          case "products":
            loadProducts();
            setState(() {
              _isLoading = false;
            });
            break;
          case "settings":
            loadSettings();
            setState(() {
              _isLoading = false;
            });
            print("Seetings loaded");
            break;
          default:
        }
      },
    );
  }

  Future<void> loadTransactions(BuildContext context) {
    setState(() {
      _isLoading = false;
    });
    return Navigator.push(
        context,
        PageTransition(
            child: TrasactionScreen(),
            type: PageTransitionType.fade,duration: Duration(milliseconds: 300)));
  }

  void loadProducts() {
    Navigator.push(
        context,
        PageTransition(
            child: ProductScreen(
              business: CardParts._currentBusiness,
              wallpaper: CardParts.wallpaper,
              posCall: false,
            ),
            type: PageTransitionType.fade,duration: Duration(milliseconds: 50)));
  }

  Future<void> loadPOS() {
    setState(() {
      _isLoading = false;
    });
    return Navigator.push(
        context,
        PageTransition(
            child: NativePosScreen(
                terminal: CardParts.currentTerminal,
                business: CardParts._currentBusiness),
            type: PageTransitionType.fade,duration: Duration(milliseconds: 50)));
  }

  void loadSettings() {
    setState(() {
      _isLoading = false;
    });

    Navigator.push(
        context,
        PageTransition(
//          child: SettingsScreen(),
          child: EmployeesScreen(),
          type: PageTransitionType.fade,
        ));
  }
}

class Menu extends StatelessWidget {
  var style = TextStyle(
    fontSize: CardParts._isTablet ? 18 : 15,
  );
  var hei = (CardParts._isTablet
      ? Measurements.width * 0.02
      : Measurements.width * 0.06);

  @override
  Widget build(BuildContext context) {
    hei = (CardParts._isTablet
        ? Measurements.width * 0.02
        : Measurements.width * 0.06);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.only(top: Measurements.height * 0.02),
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: Measurements.height * 0.08,
                    child: Center(
                        child: Text(
                      "Menu",
                      style: TextStyle(fontSize: CardParts._isTablet ? 18 : 16),
                    )),
                  )
                ],
              )),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                SvgPicture.asset(
                  "images/switch.svg",
                  height:
                      Measurements.width * (CardParts._isTablet ? 0.025 : 0.05),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Measurements.width *
                          (CardParts._isTablet ? 0.03 : 0.05)),
                ),
                Text(
                  Language.getCommerceOSStrings(
                      "dashboard.profile_menu.switch_profile"),
                  style: style,
                )
              ],
            ),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: SwitcherScreen(), type: PageTransitionType.fade));
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                SvgPicture.asset("images/logout.svg",
                    height: Measurements.width *
                        (CardParts._isTablet ? 0.025 : 0.05)),
                Padding(
                  padding: EdgeInsets.only(
                      left: Measurements.width *
                          (CardParts._isTablet ? 0.03 : 0.05)),
                ),
                Text(
                  Language.getCommerceOSStrings(
                      "dashboard.profile_menu.log_out"),
                  style: style,
                )
              ],
            ),
            onTap: () {
              SharedPreferences.getInstance().then((p) {
                p.setString(GlobalUtils.BUSINESS, "");
                p.setString(GlobalUtils.EMAIL, "");
                p.setString(GlobalUtils.PASSWORD, "");
                p.setString(GlobalUtils.DEVICEID, "");
                p.setString(GlobalUtils.DB_TOKEN_ACC, "");
                p.setString(GlobalUtils.DB_TOKEN_RFS, "");
              });
              Navigator.pushReplacement(
                  context,
                  PageTransition(
                      child: LoginScreen(), type: PageTransitionType.fade));
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                SvgPicture.asset("images/contact.svg",
                    height: Measurements.width *
                        (CardParts._isTablet ? 0.02 : 0.04)),
                Padding(
                  padding: EdgeInsets.only(
                      left: Measurements.width *
                          (CardParts._isTablet ? 0.03 : 0.05)),
                ),
                Text(
                  Language.getCommerceOSStrings(
                      "dashboard.profile_menu.contact"),
                  style: style,
                )
              ],
            ),
            onTap: () {
              //Navigator.pushReplacement(context, PageTransition(child: LoginScreen(), type: PageTransitionType.fade) );
              _launchURL("service@payever.de", "Contact payever", "");
            },
          ),
          Divider(),
          ListTile(
            title: Row(
              children: <Widget>[
                SvgPicture.asset("images/feedback.svg",
                    height: Measurements.width *
                        (CardParts._isTablet ? 0.025 : 0.05)),
                Padding(
                  padding: EdgeInsets.only(
                      left: Measurements.width *
                          (CardParts._isTablet ? 0.03 : 0.05)),
                ),
                Text(
                  Language.getCommerceOSStrings(
                      "dashboard.profile_menu.feedback"),
                  style: style,
                )
              ],
            ),
            onTap: () {
              //Navigator.pushReplacement(context, PageTransition(child: LoginScreen(), type: PageTransitionType.fade) );
              _launchURL(
                  "service@payever.de", "Feedback for the payever-Team", "");
            },
          ),
          Divider(),
        ],
      )),
    );
  }

  _launchURL(String toMailId, String subject, String body) async {
    var url = Uri.encodeFull('mailto:$toMailId?subject=$subject&body=$body');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 40),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Text("  "),
        ),
      ),
    );
  }
}

class DashBoardList extends StatefulWidget {
  @override
  _DashBoardListState createState() => _DashBoardListState();
}

class _DashBoardListState extends State<DashBoardList> {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class CardParts {
  static bool _isTablet = false;
  static bool _isPortrait = true;

  static Widget _transtioncard;
  static Widget _transtioncard2;
  static List<Widget> _activeWid = List();
  static POSCard _poscard;
  static ProductsCard _productsCard;
  static SettingsCard _settingsCard;
  static String UI_KIT = Env.Commerceos + "/assets/ui-kit/icons-png/";

  static double _appBarSize;

  static Token _currentToken;
  static String wallpaper;
  static Business _currentBusiness;
  static User _currentUser;
  static Terminal currentTerminal = null;
  static List<AppWidget> _currentWidgets;
  static bool _isBusiness;
  static List<int> indexes = List();
}

class DrawHorizontalLine extends CustomPainter {
  Paint _paint;
  bool reverse;

  DrawHorizontalLine() {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 0.1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(-Measurements.width, 0.0),
        Offset(Measurements.width, 0.0), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
