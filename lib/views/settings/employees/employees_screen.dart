import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:payever/network/rest_ds.dart';
import 'package:payever/view_models/employees_state_model.dart';
import 'package:payever/view_models/global_state_model.dart';

import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/settings/employees/add_employee_screen.dart';
import 'package:payever/views/settings/employees/employees_groups_list_tab_screen.dart';
import 'package:payever/views/settings/employees/employees_list_tab_screen.dart';
import 'package:provider/provider.dart';

import 'add_group_screen.dart';

bool _isPortrait;
bool _isTablet;

class EmployeesScreen extends StatefulWidget {
  @override
  createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalStateModel globalStateModel;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    setState(() {
      _currentIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalStateModel = Provider.of<GlobalStateModel>(context);

    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = Measurements.width < 600 ? false : true;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Stack(
          children: <Widget>[
            Positioned(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                top: 0.0,
                child: CachedNetworkImage(
                  imageUrl: globalStateModel.currentWallpaper ??
                      globalStateModel.defaultCustomWallpaper,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                )),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  child: Scaffold(
                      backgroundColor: Colors.black.withOpacity(0.2),
                      appBar: CustomAppBar(
                        title: Text("Employees"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              if (tabController.index == 0) {
//                                Navigator.push(
//                                    context,
//                                    PageTransition(
//                                      child: AddEmployeeScreen(),
//                                      type: PageTransitionType.fade,
//                                    ));

                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProxyProvider<RestDatasource, EmployeesStateModel>(
                                        builder: (context, api, employeesState) =>
                                            EmployeesStateModel(globalStateModel, api),
                                        child: AddEmployeeScreen(),
                                      ),
                                      type: PageTransitionType.fade,
                                    ));



                              } else {
//                                Navigator.push(
//                                    context,
//                                    PageTransition(
//                                      child: AddGroupScreen(),
//                                      type: PageTransitionType.fade,
//                                    ));

                                Navigator.push(
                                    context,
                                    PageTransition(
                                      child: ProxyProvider<RestDatasource, EmployeesStateModel>(
                                        builder: (context, api, employeesState) =>
                                            EmployeesStateModel(globalStateModel, api),
                                        child: AddGroupScreen(),
                                      ),
                                      type: PageTransitionType.fade,
                                    ));
                              }
                            },
                          ),
                        ],
                      ),
                      body: ListView(
//                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
//                                color: Colors.white.withOpacity(0.3),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: Measurements.width * 0.8,
                              child: TabBar(
                                controller: tabController,
                                indicatorColor: Colors.transparent,
//                                indicator: BubbleTabIndicator(
//                                  indicatorHeight: 45,
////                              indicatorColor: Colors.white.withOpacity(0.3),
//                                  indicatorColor: Colors.white.withOpacity(0.1),
//                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
//                                ),
//                                indicator: ShapeDecoration(
//                                  color: Colors.blue,
//                                  shape: BeveledRectangleBorder(
//                                      side: BorderSide(color: Colors.blue),
//                                      borderRadius: BorderRadius.circular(0)),
//                                ),

                                labelColor: Colors.white,
                                labelPadding: EdgeInsets.all(2),
                                unselectedLabelColor: Colors.white,
                                isScrollable: false,
                                tabs: <Widget>[
                                  Container(
                                    child: Tab(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                        color: _currentIndex == 0
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                bottomLeft:
                                                    Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            'Employees',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Tab(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                        color: _currentIndex == 1
                                            ? Colors.white.withOpacity(0.3)
                                            : Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20))),
                                        child: Center(
                                          child: Text(
                                            'Groups',
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height - 2,
                            child: TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: tabController,
                              children: <Widget>[
                                EmployeesListTabScreen(),
                                EmployeesGroupsListTabScreen()
                              ],
                            ),
                          ),
                        ],
                      )),
                )),
          ],
        );
      },
    );
  }
}

//class MyBubbleTabIndicator extends Decoration {
//
//  @override
//  _BubblePainter createBoxPainter([VoidCallback onChanged]) {
//    return new _BubblePainter(this, onChanged);
//  }
//
//}

class BubbleTabIndicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final double indicatorRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry insets;
  final TabBarIndicatorSize tabBarIndicatorSize;

  const BubbleTabIndicator({
    this.indicatorHeight: 20.0,
    this.indicatorColor: Colors.greenAccent,
    this.indicatorRadius: 100.0,
    this.tabBarIndicatorSize = TabBarIndicatorSize.label,
    this.padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.insets: const EdgeInsets.symmetric(horizontal: 0),
  })  : assert(indicatorHeight != null),
        assert(indicatorColor != null),
        assert(indicatorRadius != null),
        assert(padding != null),
        assert(insets != null);

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is BubbleTabIndicator) {
      return new BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(a.padding, padding, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is BubbleTabIndicator) {
      return new BubbleTabIndicator(
        padding: EdgeInsetsGeometry.lerp(padding, b.padding, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _BubblePainter createBoxPainter([VoidCallback onChanged]) {
    return new _BubblePainter(this, onChanged);
  }
}

class _BubblePainter extends BoxPainter {
  _BubblePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final BubbleTabIndicator decoration;

  double get indicatorHeight => decoration.indicatorHeight;

  Color get indicatorColor => decoration.indicatorColor;

  double get indicatorRadius => decoration.indicatorRadius;

  EdgeInsetsGeometry get padding => decoration.padding;

  EdgeInsetsGeometry get insets => decoration.insets;

  TabBarIndicatorSize get tabBarIndicatorSize => decoration.tabBarIndicatorSize;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);

    Rect indicator = padding.resolve(textDirection).inflateRect(rect);

    if (tabBarIndicatorSize == TabBarIndicatorSize.tab) {
      indicator = insets.resolve(textDirection).deflateRect(rect);
    }

    return new Rect.fromLTWH(
      indicator.left,
      indicator.top,
      indicator.width,
      indicator.height,
    );
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = Offset(
            offset.dx, (configuration.size.height / 2) - indicatorHeight / 2) &
        Size(configuration.size.width, indicatorHeight);
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = _indicatorRectFor(rect, textDirection);
    final Paint paint = Paint();
    paint.color = indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
//        RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
        RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
        paint);
  }
}
