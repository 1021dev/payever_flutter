import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/models/employees.dart';
import 'package:payever/views/customelements/drop_down_menu.dart';
import 'package:payever/views/settings/employees/groups_selector_screen.dart';
import 'package:provider/provider.dart';

import 'package:payever/utils/utils.dart';
import 'package:payever/view_models/global_state_model.dart';
import 'package:payever/views/customelements/custom_app_bar.dart';

import 'expandable_component.dart';

bool _isPortrait;
bool _isTablet;

class AddEmployeeScreen extends StatefulWidget {
  @override
  createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  var openedEmployeeInfoRow = ValueNotifier(0);
  var openedAppsAccessRow = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    GlobalStateModel globalStateModel = Provider.of<GlobalStateModel>(context);

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        _isPortrait =
            Orientation.portrait == MediaQuery.of(context).orientation;
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
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                child: Scaffold(
                  backgroundColor: Colors.black.withOpacity(0.2),
                  appBar: CustomAppBar(
                    title: Text("Add Employee"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  body: ListView(
                    children: <Widget>[
                      Form(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              EmployeeInfoRow(openedRow: openedEmployeeInfoRow),
                              //        EmployeeInfoRow(
                              //        openedRow: openedEmployeeInfoRow,
                              //        employee: widget.employee,
                              //        employeeGroups: snapshot.data,
                              //        ),
                              //        AppsAccessRow(
                              //        openedRow: openedAppsAccessRow,
                              //        employee: widget.employee,
                              //        employeeGroups: snapshot.data,
                              //        ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class EmployeeInfoRow extends StatefulWidget {

  final ValueNotifier openedRow;
  final Employees employee;
  final dynamic employeeGroups;

  EmployeeInfoRow({this.openedRow, this.employee, this.employeeGroups});

  @override
  createState() => _EmployeeInfoRowState();
}

class _EmployeeInfoRowState extends State<EmployeeInfoRow>
    with TickerProviderStateMixin {

  bool isOpen = true;

  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        isOpen = !isOpen;
//        if(openedEmployeeInfoRow.value == 1) {
//          openedAppsAccessRow.value = 0;
//          openedAppsAccessRow.notifyListeners();
//        } else {
//          openedAppsAccessRow.value = 1;
//          openedAppsAccessRow.notifyListeners();
//        }
      } else {
        isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {

    Widget getEmployeeInfoRow() {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
//                    initialValue: widget.employee.firstName,
                    decoration: InputDecoration(
                      hintText: "First Name",
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                    onSaved: (firstName) {
                    },
//                    validator: (value) {
//
//                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
//                    initialValue: widget.employee.lastName,
                    decoration: InputDecoration(
                        hintText: "Last Name",
                        border: InputBorder.none,
                        labelText: "Last Name",
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    onSaved: (lastName) {},
//                    validator: (value) {
//                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.010),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
                  child: TextFormField(
                    style: TextStyle(fontSize: Measurements.height * 0.02),
//                    initialValue: widget.employee.email,
//                    initialValue: widget.parts.editMode?widget.parts.product.price.toString():"",
//                    inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9.]"))],
                    decoration: InputDecoration(
//                      hintText: Language.getProductStrings("price.placeholders.price"),
                      hintText: "Email",
//                      hintStyle: TextStyle(
//                          color: widget.priceError
//                              ? Colors.red
//                              : Colors.white.withOpacity(0.5)),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
//                    keyboardType: TextInputType.number,
                    onSaved: (email) {
//                      widget.parts.product.price = num.parse(price);
                    },
//                    validator: (value) {
//
//                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.025),
//                  alignment: Alignment.center,
                  color: Colors.white.withOpacity(0.05),
                  width: Measurements.width * 0.475,
                  height: Measurements.height * (_isTablet ? 0.05 : 0.07),
//                  child: TextFormField(
//                    style: TextStyle(fontSize: Measurements.height * 0.02),
//                    initialValue: widget.employee.position[0].positionType,
//                    decoration: InputDecoration(
//                        hintText: "Position",
//                        border: InputBorder.none,
//                        labelText: "Position",
//                        labelStyle: TextStyle(
//                          color: Colors.grey,
//                        )),
//                    onSaved: (position) {},
////                    validator: (value) {
////                    },
//                  ),

                  child: SizedBox(
                    width: double.infinity,
                    child: DropDownMenu(
                      optionsList: <String>[
                        "Cashier",
                        "Sales",
                        "Marketing",
                        "Staff",
                        "Admin",
                        "Others",
                      ],
//                      defaultValue: widget.employee.position,
                      placeHolderText: "Position",
                      onChangeSelection: (selectedOption, index) {
                        print("selectedOption: $selectedOption");
                        print("index: $index");
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.020),
          ),
          Container(
            width: Measurements.width * 0.96,
            child: Row(
              children: <Widget>[
                Text(
                  "Groups: ",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                IconButton(icon: Icon(Icons.add_box),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return GroupsSelectorScreen();
                        },
                        fullscreenDialog: true));
                },),
                SizedBox(
                  height: Measurements.height * 0.060,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
//                    itemCount: widget.employee.position.length,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(Measurements.width * 0.025),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Measurements.width * 0.025),
                                child: Center(
                                    child: Text("Example Group")),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.all(Measurements.width * 0.014),
                                child: InkWell(
                                  radius: 20,
                                  child: Icon(
                                    IconData(58829,
                                        fontFamily: 'MaterialIcons'),
                                    size: 20,
                                  ),
                                  onTap: () {},
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Measurements.width * 0.01),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
//                  child: Text(Language.getProductStrings("sections.main")),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Info",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 0;
                  },
                ),
              ],
            ),
            onTap: () {
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
        ),
        AnimatedContainer(
            color: Colors.white.withOpacity(0.05),
//            height: widget.isOpen ? Measurements.height * 0.62 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              child: isOpen
                  ? AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      vsync: this,
                      child: Container(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: Measurements.width * 0.025),
                        color: Colors.black.withOpacity(0.3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                getEmployeeInfoRow(),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            )),
        Container(
            color: Colors.white.withOpacity(0.1),
            child: isOpen
                ? Divider(
                    color: Colors.white.withOpacity(0),
                  )
                : Divider(
                    color: Colors.white,
                  )),
        //
      ],
    );
  }
}


class AppsAccessRow extends StatefulWidget {

  final ValueNotifier openedRow;
  final Employees employee;
  final dynamic employeeGroups;


  AppsAccessRow({this.openedRow, this.employee, this.employeeGroups});

  @override
  createState() => _AppsAccessRowState();
}

class _AppsAccessRowState extends State<AppsAccessRow>
    with TickerProviderStateMixin {

  bool isOpen = false;

  var appPermissionsRow = ValueNotifier(0);

  listener() {
    setState(() {
      if (widget.openedRow.value == 0) {
        isOpen = !isOpen;
      } else {
        isOpen = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.openedRow.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    Widget getAppsAccessRow() {
//      return Container(child: Text("Hello"),);

      return Container(
        width: Measurements.width - 2,
//       height: 100,
        child: ListView.builder(
          padding: EdgeInsets.all(0.1),
          shrinkWrap: true,
          itemCount: widget.employee.roles.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container();
            } else {
              return Column(
                children: <Widget>[
//                  ExpandableListView(
//                    iconData: Icons.shopping_basket,
//                    title: widget
//                        .employee.roles[index].permission[0].acls[0].microService,
//                    isExpanded: true,
//                    widgetList: Center(child: Text("Hello"),),
//                  ),
                  ExpandableListView(
                    iconData: Icons.shopping_basket,
                    title: widget
                        .employee.roles[index].permission[0].acls[0].microService,
                    isExpanded: false,
                    widgetList: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Measurements.width * 0.020),
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
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].create,
                                  onChanged: (bool value) {
                                    setState(() {

                                    });
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
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].read,
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
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].update,
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
                                  value: widget.employee.roles[index].permission[0]
                                      .acls[0].delete,
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
                  ),
                ],
              );

            }
          },
        ),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
          ),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
//                  child: Text(Language.getProductStrings("sections.main")),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.business_center,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Apps Access",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.05),
                ),
                IconButton(
                  icon: Icon(isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                  onPressed: () {
                    widget.openedRow.notifyListeners();
                    widget.openedRow.value = 0;
                  },
                ),
              ],
            ),
            onTap: () {
              widget.openedRow.notifyListeners();
              widget.openedRow.value = 0;
            },
          ),
        ),
        AnimatedContainer(
            color: Colors.white.withOpacity(0.05),
//            height: widget.isOpen ? Measurements.height * 0.62 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: Measurements.width * 0.999,
              child: isOpen
                  ? AnimatedSize(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                vsync: this,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Measurements.width * 0.0015),
                  color: Colors.black.withOpacity(0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
//                                    Expanded(child: getAppsAccessRow()),
                              getAppsAccessRow(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Measurements.width * 0.020),
                              ),
                              InkWell(
                                child: Container(
                                  color: Colors.white.withOpacity(0.1),
                                  width: Measurements.width * 0.99,
                                  height: Measurements.height *
                                      (_isTablet ? 0.05 : 0.07),
                                  child: Center(
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 19),
                                      )),
                                ),
                                onTap: () {},
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Measurements.width * 0.01),
                              ),
                            ],
                          ),
//                                Container(
//                                  height: Measurements.height * 0.3,
//                                  child: getAppsAccessRow(),
//                                ),
                        ],
                      )
                    ],
                  ),
                ),
              )
                  : Container(width: 0, height: 0),
            )),
        Container(
            color: isOpen
                ? Colors.transparent
                : Colors.white.withOpacity(0.1),
            height: Measurements.height * 0.01,
            child: isOpen
                ? Divider(
              color: Colors.white.withOpacity(0),
            )
                : Divider(
              color: Colors.white,
            )),
      ],
    );
  }
}
