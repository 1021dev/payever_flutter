import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:payever/models/global_state_model.dart';

import 'package:payever/utils/utils.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';
import 'package:payever/views/settings/employees/employees_groups_list_screen.dart';
import 'package:payever/views/settings/employees/employees_list_screen.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
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
    return Stack(
      children: <Widget>[
        Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            top: 0.0,
            child: CachedNetworkImage(
              imageUrl: globalStateModel.currentWallpaper ??
                  "https://payevertest.azureedge.net/images/commerseos-background-blurred.jpg",
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
                      IconButton(icon: Icon(Icons.add),
                        onPressed: () {
                          if(tabController.index == 0) {
                            print("tabController.index0: ${tabController.index}");
                          } else {
                            print("tabController.index1: ${tabController.index}");
                          }
                      },),
                    ],
                  ),
                  body: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          width: Measurements.width * 0.7,
                          child: TabBar(
                            controller: tabController,
                            indicatorColor: Colors.transparent,
                            indicator: BubbleTabIndicator(
                              indicatorHeight: 45,
                              indicatorColor: Colors.white.withOpacity(0.3),
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white,
                            isScrollable: false,
                            tabs: <Widget>[
                              Container(
//                                color: tabController.index == 0
//                                            ? Colors.red
//                                            : Colors.yellow,
                                child: Tab(
                                  child: Container(
                                    height: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
//                                        color: Colors.green,
//                                        color: tabController.index == 0
//                                            ? Colors.red
//                                            : Colors.yellow,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20))),
                                    child: Center(
                                      child: Text(
                                        'Employees',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
//                                color: Colors.green,
                                child: Tab(
                                  child: Container(
                                    height: 40,
//                                padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
//                                      color: Colors.green,
//                                        color: tabController.index == 1
//                                            ? Colors.red
//                                            : Colors.yellow,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                    child: Center(
                                      child: Text(
                                        'Groups',
                                        style: TextStyle(fontSize: 18),
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
                            EmployeesListScreen(),
                            EmployeesGroupsListScreen()
                          ],
                        ),
                      ),
                    ],
                  )),
            )),
      ],
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
