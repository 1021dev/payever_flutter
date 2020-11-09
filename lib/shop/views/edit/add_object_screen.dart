import 'dart:math';

import 'package:clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/sub_element/add_object_appbar.dart';
import 'package:shape_of_view/shape_of_view.dart';
import '../../../theme.dart';

class AddObjectScreen extends StatefulWidget {
  @override
  _AddObjectScreenState createState() => _AddObjectScreenState();
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  bool isPortrait;
  bool isTablet;
  int selectedItemIndex = 0;

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return Scaffold(
        appBar: AddObjectAppbar(onTapAdd: () {}),
        backgroundColor: Colors.grey[800],
        body: SafeArea(bottom: false, child: _body()));
  }

  Widget _secondAppbar() {
    return Container(
      height: 50,
      color: overlaySecondAppBar(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: <Widget>[
            SizedBox(width: 8),
            InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/searchicon.svg',
                  width: 20,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(width: 16),
            Row(
              children: objectTitles.map((e) {
                int idx = objectTitles.indexOf(e);
                return _secondAppBarItem(e, idx);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _secondAppbar(),
        _gridViewBody(),
      ],
    );
  }

  Widget _gridViewBody() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: GridView.count(
          crossAxisCount: isTablet ? 5 : (isPortrait ? 3 : 5),
          crossAxisSpacing: isTablet ? 60 : (isPortrait ? 50 : 60),
          mainAxisSpacing: isTablet ? 60 : (isPortrait ? 50 : 60),
          children: List.generate(
            5,
            (index) {
              return _objectGridItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _secondAppBarItem(String title, int index) {
    bool isSelected = selectedItemIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedItemIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _objectGridItem(int index) {
    Widget item;
    switch (index) {
      case 0:
        item = Container(
          alignment: Alignment.center,
          child: Text(
            'Text',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
      case 1:
        item = Container(
          color: Colors.grey[300],
        );
        break;
      case 2:
        item = Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
        );
        break;
      case 3:
        item = Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
        break;
      case 4:
        item = Transform.rotate(
          angle: pi,
          child: ShapeOfView(
              shape: TriangleShape(
                  percentBottom: 0.5, percentLeft: 0, percentRight: 0),
              child: Transform.rotate(
                angle: pi,
                child: Container(
                  color: Colors.grey[300],
                ),
              )),
        );
        break;
    }
    return item;
  }
}
