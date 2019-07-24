import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:payever/models/acl.dart';
import 'package:payever/models/business_employees_groups.dart';
import 'package:payever/models/employees.dart';
import 'package:payever/utils/utils.dart';

import 'expandable_component.dart';

class EmployeesGroupComponent extends StatefulWidget {
  final BusinessEmployeesGroups businessEmployeesGroups;

  EmployeesGroupComponent(this.businessEmployeesGroups);

  @override
  createState() => _EmployeesGroupComponentState();
}

class _EmployeesGroupComponentState extends State<EmployeesGroupComponent>
    with SingleTickerProviderStateMixin {
  bool _isPortrait;
  bool _isTablet;

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    _isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    _isTablet = Measurements.width < 600 ? false : true;
    Measurements.height = (_isPortrait
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width);
    Measurements.width = (_isPortrait
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height);

    return Container(
//      width: Measurements.width * 0.99,
      color: Colors.black.withOpacity(0.3),
      child: Column(
//      mainAxisSize: MainAxisSize.min,
//      padding: EdgeInsets.all(0),
//      shrinkWrap: true,
//      scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: Measurements.width * 0.6,
              child: TabBar(
                controller: tabController,
                indicatorColor: Colors.transparent,
                indicator: BubbleTabIndicator(
                  indicatorHeight: 40,
                  indicatorColor: Colors.black.withOpacity(0.1),
                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                isScrollable: false,
                tabs: <Widget>[
                  Container(
                    child: Tab(
                      child: Container(
                        height: 25,
//                      padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20))),
                        child: Center(
                          child: Text(
                            'Employees',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
//                                color: Colors.green,
                    child: Tab(
                      child: Container(
                        height: 25,
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
                            'Access',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
//          width: Measurements.width,
//          height: Measurements.height - 600,
//          height: 100,
            child: TabBarView(
//            physics: NeverScrollableScrollPhysics(),
              controller: tabController,
              children: <Widget>[
                EmployeesList(
                    employeesList: widget.businessEmployeesGroups.employees),
                EmployeesAppsAccess(acls: widget.businessEmployeesGroups.acls),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeesList extends StatefulWidget {
  final List<Employees> employeesList;

  const EmployeesList({Key key, this.employeesList}) : super(key: key);

  @override
  createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  @override
  Widget build(BuildContext context) {
    bool _isTablet = Measurements.width < 600 ? false : true;
    return ListView.separated(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      itemCount: widget.employeesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: Measurements.width * 0.14,
          padding: EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerLeft,
//                    width: Measurements.width * 0.2,
                  child: AutoSizeText(
                      widget.employeesList[index].firstName +
                          " " +
                          widget.employeesList[index].lastName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                  style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    radius: _isTablet
                        ? Measurements.height * 0.02
                        : Measurements.width * 0.07,
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.02),
                        //width: widget._active ?50:120,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: _isTablet
                            ? Measurements.height * 0.02
                            : Measurements.width * 0.07,
                        child: Center(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Delete",
                                style: TextStyle(fontSize: 14),
                              )),
                        )),
                    onTap: () {
//                    Navigator.push(
//                        context,
//                        PageTransition(
//                          child: EmployeesGroupsDetailsScreen(
//                              _currentEmployeesGroup),
//                          type: PageTransitionType.fade,
//                        ));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(color: Colors.white,);
      },
    );
  }
}

class EmployeesAppsAccess extends StatefulWidget {
  final List<Acl> acls;

  const EmployeesAppsAccess({Key key, this.acls}) : super(key: key);

  @override
  createState() => _EmployeesAppsAccessState();
}

class _EmployeesAppsAccessState extends State<EmployeesAppsAccess> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      itemCount: widget.acls.length,
      itemBuilder: (BuildContext context, int index) {
//        return Text("Microservice: ${widget.acls[index].microService}");
        return ExpandableListView(
          iconData: Icons.shopping_basket,
          title: widget.acls[index].microService,
          isExpanded: false,
          widgetList: Container(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Measurements.width * 0.020),
              child: Column(
                children: <Widget>[
                  Divider(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Create",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        activeColor: Color(0XFF0084ff),
                        value: widget.acls[index].create,
                        onChanged: (bool value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Read",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        activeColor: Color(0XFF0084ff),
                        value: widget.acls[index].read,
                        onChanged: (bool value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Update",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        activeColor: Color(0XFF0084ff),
                        value: widget.acls[index].update,
                        onChanged: (bool value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        activeColor: Color(0XFF0084ff),
                        value: widget.acls[index].delete,
                        onChanged: (bool value) {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

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
