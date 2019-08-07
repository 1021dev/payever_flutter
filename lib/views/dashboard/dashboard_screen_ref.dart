import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/utils/translations.dart';
import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/dashboard_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/wallpaper.dart';
import 'package:payever/views/dashboard/dashboard_apps.dart';
import 'package:payever/views/dashboard/dashboard_menu.dart';
import 'package:payever/views/dashboard/dashboard_overview.dart';
import 'package:payever/views/dashboard/dashboard_screen_navigation.dart';
import 'package:provider/provider.dart';

bool _isTablet;
class DashboardScreen extends StatelessWidget {
  var appWidgets;
  DashboardScreen({this.appWidgets});
  DashboardStateModel dashboardStateModel = DashboardStateModel();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DashboardStateModel>(builder: (BuildContext context) {
          dashboardStateModel.setCurrentWidget(appWidgets);
          return dashboardStateModel;
        }),
      ],
      child: DashboardScreenWidget(),
    );
  }
}

class DashboardScreenWidget extends StatefulWidget {
  @override
  _DashboardScreenWidgetState createState() => _DashboardScreenWidgetState();
}

class _DashboardScreenWidgetState extends State<DashboardScreenWidget> with TickerProviderStateMixin {
  List<NavigationIconView> _navigationViews;
  int _currentIndex = 0;
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/dashboardicon.svg",
                color: Colors.white.withOpacity(0.3),
                height: 18)),
        activeIcon: Container(
            child: SvgPicture.asset("images/dashboardicon.svg",
                color: Colors.white,
                height: 19)),
        title: Language.getCustomStrings("dashboard.navigation.overview"),
        vsync: this,
        tablet: _isTablet,
      ),
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/appsicon.svg",
                color: Colors.white.withOpacity(0.3),
                height: 18)),
        activeIcon: Container(
            child: SvgPicture.asset("images/appsicon.svg",
                color: Colors.white,
                height: 19)),
        title: Language.getCustomStrings("dashboard.navigation.apps"),
        vsync: this,
        tablet: _isTablet,
      ),
      NavigationIconView(
        icon: Container(
            child: SvgPicture.asset("images/hamburger.svg",
                color: Colors.white.withOpacity(0.3),
                height:18)),
        activeIcon: Container(
            child: SvgPicture.asset("images/hamburger.svg",
                color: Colors.white,
                 height: 19)),
        title: Language.getCustomStrings("dashboard.navigation.menu"),
        tablet: _isTablet,
        vsync: this,
      ),
    ];
    //NavigationBar items
  }
  buildUi(){
    _controller = TabController(length: 3, vsync: this);
    _navigationViews[_currentIndex].controller.value = 1.0;
  }
  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);
    bool _isPortrait =
        Orientation.portrait == MediaQuery.of(context).orientation;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);
    _isTablet = Measurements.width > 600;
    Widget scaffoldBody;
    switch (_currentIndex) {
      case 0:
        scaffoldBody = DashboardOverview();
        break;
      case 1:
        scaffoldBody = DashboardApps();
        break;
      case 2:
        scaffoldBody = DashboardMenu();
        break;
      default:
    }
    buildUi();
    return BackgroundBase(
      _currentIndex!=0,
      body: scaffoldBody,
      bottomNav: BottomNavigationBar(
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
            _currentIndex = index;
            _controller.index = _currentIndex;
          });
        },
      ),
    );
    // return Stack(
    //   overflow: Overflow.visible,
    //   fit: StackFit.expand,
    //   children: <Widget>[
    //     Positioned(
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       top: 0.0,
    //       child: Container(
    //         child: CachedNetworkImage(
    //           imageUrl: globalStateModel.currentWallpaper,
    //           placeholder: (context, url) => Container(),
    //           errorWidget: (context, url, error) => Icon(Icons.error),
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     Container(
    //       height: Measurements.height,
    //       width: Measurements.width,
    //       child: Container(
    //         child: Scaffold(
    //           bottomNavigationBar: ClipRect(
    //             child: Container(
    //               child: BackdropFilter(
    //                 filter: ImageFilter.blur(sigmaX: _currentIndex!=0?25:0.01, sigmaY: _currentIndex!=0?40:0.01),
    //                 child: BottomNavigationBar(
    //                   items: _navigationViews
    //                       .map<BottomNavigationBarItem>(
    //                           (NavigationIconView navigationView) => navigationView.item)
    //                       .toList(),
    //                   currentIndex: _currentIndex,
    //                   type: BottomNavigationBarType.fixed,
    //                   elevation: 0,
    //                   backgroundColor: Colors.black.withOpacity(0.3),
    //                   onTap: (int index) {
    //                     setState(() {
    //                       _currentIndex = index;
    //                       _controller.index = _currentIndex;
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //           backgroundColor:scaffoldColor,
    //           body: TabBarView(
    //             physics: NeverScrollableScrollPhysics(),
    //             controller: _controller,
    //             children: <Widget>[
    //               DashboardOverview(),
    //               DashboardApps(),
    //               DashboardMenu(),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
