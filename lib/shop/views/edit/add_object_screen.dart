import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/constant.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/sub_element/add_object_appbar.dart';
import 'package:shape_of_view/shape_of_view.dart';
import '../../../theme.dart';

class AddObjectScreen extends StatefulWidget {
  final ShopEditScreenBloc screenBloc;
  final TemplateSizeStateModel templateSizeStateModel;
  const AddObjectScreen({this.screenBloc, this.templateSizeStateModel});

  @override
  _AddObjectScreenState createState() => _AddObjectScreenState(screenBloc);
}

class _AddObjectScreenState extends State<AddObjectScreen> {
  bool isPortrait;
  bool isTablet;
  int selectedItemIndex = 0;
  final ShopEditScreenBloc screenBloc;

  _AddObjectScreenState(this.screenBloc);

  @override
  Widget build(BuildContext context) {
    isPortrait = GlobalUtils.isPortrait(context);
    isTablet = GlobalUtils.isTablet(context);

    return BlocBuilder(
      bloc: screenBloc,
      builder: (BuildContext context, state) {
        return Scaffold(
            appBar: AddObjectAppbar(onTapAdd: () {}),
            backgroundColor: Colors.grey[800],
            body: SafeArea(bottom: false, child: _body()));
      },
    );
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
            selectedItemIndex == 0 ? 7 : 6,
            (index) {
              return selectedItemIndex == 0 ? _objectGridItem(index) : _cartGridItem(index);
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
    ShopObject shopObject;
    Widget item;
    switch (index) {
      case 0:
        shopObject = ShopObject(name: 'text', type: 'text');
        item = Container(
          alignment: Alignment.center,
          child: Text(
            'Text',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
      case 1:
        shopObject = ShopObject(name: 'square', type: 'shape');
        item = Container(
          color: Colors.grey[300],
        );
        break;
      case 2:
        shopObject = ShopObject(name: 'circle', type: 'shape');
        item = Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
        );
        break;
      case 3:
        shopObject = ShopObject(name: 'triangle', type: 'shape');
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
      case 4:
        shopObject = ShopObject(name: 'button', type: 'button');
        item = Container(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1/0.6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: Text(
                'Button',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
        break;
      case 5:
        shopObject = ShopObject(name: 'button--rounded', type: 'button');
        item = Container(
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: 1/0.6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Text(
                'Button',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
        break;
      case 6:
        shopObject = ShopObject(name: 'menu', type: 'menu');
        item = Container(
          alignment: Alignment.center,
          child: Text(
            'Menu',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        );
        break;
    }
    return InkWell(
        onTap: () {
          Navigator.pop(context, shopObject);
        },
        child: item);
  }

  Widget _cartGridItem(int index) {
    ShopObject shopObject;
    Widget item;
    switch (index) {
      case 0:
        shopObject = ShopObject(name: 'square-cart', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart1.svg'),
        );
        break;
      case 1:
        shopObject = ShopObject(name: 'angular-cart', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart2.svg'),
        );
        break;
      case 2:
        shopObject = ShopObject(name: 'flat-cart', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart3.svg'),
        );
        break;
      case 3:
        shopObject = ShopObject(name: 'square-cart--empty', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart4.svg'),
        );
        break;
      case 4:
        shopObject = ShopObject(name: 'angular-cart--empty', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart5.svg'),
        );
        break;
      case 5:
        shopObject = ShopObject(name: 'flat-cart--empty', type: 'shop-cart');
        item = Container(
          padding: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/images/shop-edit-cart5.svg'),
        );
        break;
    }

    return InkWell(
        onTap: () {
          Navigator.pop(context, shopObject);
        },
        child: item);
  }
}
