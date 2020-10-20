import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/shap_view.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/commons/utils/draggable_widget.dart';
import '../../../../theme.dart';
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;

  const SectionView({this.shopPage, this.child, this.stylesheets});

  @override
  _SectionViewState createState() => _SectionViewState(
      shopPage: shopPage, child: child, stylesheets: stylesheets);
}

class _SectionViewState extends State<SectionView> {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;

  ApiService api = ApiService();
  DragController dragController = DragController();
  SectionStyleSheet styleSheet;

  StreamController<double> controller = StreamController.broadcast();
  double widgetHeight = 0;
  GlobalKey key = GlobalKey();

  _SectionViewState({this.shopPage, this.child, this.stylesheets}) {
    styleSheet = getSectionStyleSheet(child.id);
    widgetHeight = styleSheet.height;
  }

  @override
  Widget build(BuildContext context) {
    return _section();
  }

  Widget _section() {
    if (styleSheet == null) {
      return Container();
    }
    List<Widget> widgets = [];
    widgets.add(_sectionBackgroundWidget(styleSheet));
    child.children.forEach((child) {
      Widget widget;
      switch(child.type) {
        case 'text':
          widget = TextView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'button':
          widget = ButtonView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'image':
          widget = ImageView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'shape':
          widget = ShapeView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'block':
          break;
        case 'menu':
          break;
        case 'logo':
          break;
        case 'shop-cart':
          break;
        case 'shop-category':
          break;
        case 'shop-products':
          break;
        case 'logo':
          break;
        default:
          print('Special Child Type: ${child.type}');
      }
      if (widget != null) widgets.add(widget);
    });

    // Add Drag Buttons
    if (widgets.isNotEmpty) {
      widgets.add(Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
                onVerticalDragUpdate: (DragUpdateDetails details) {
                  setState(() {
                    double newHeight = details.globalPosition.dy;
                    RenderBox box = key.currentContext.findRenderObject();
                    Offset position1 = box
                        .localToGlobal(Offset.zero); //this is global position

                    widgetHeight = newHeight - position1.dy;
                    widgetHeight.isNegative
                        ? Navigator.pop(context)
                        : controller.add(widgetHeight);
                  });
                },
                behavior: HitTestBehavior.translucent,
                onVerticalDragDown: (details) {
                  print('onVerticalDragDown dy = ${details.globalPosition.dy}');
                },
                onVerticalDragEnd: (DragEndDetails details) {
                  print('onVerticalDragEnd ');
                },
                onVerticalDragStart: (details) {
                  print('onVerticalDragDown dy = ${details.globalPosition.dy}');
                },
                child: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.black,
                ))),
      ));
    }

    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) => Container(
        key: key,
        height: snapshot.hasData ? snapshot.data : styleSheet.height,
        width: double.infinity,
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  Widget _sectionBackgroundWidget(SectionStyleSheet styleSheet) {
    return Container(
      width: double.infinity,
      //styleSheet.width,
      height: widgetHeight,
      alignment: styleSheet.getBackgroundImageAlignment(),
      color: colorConvert(styleSheet.backgroundColor),
      child: BackgroundView(styles: styleSheet),
    );
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
//      print(
//          'Section StyleSheet: ${stylesheets[shopPage.stylesheetIds.mobile][childId]}');
      return SectionStyleSheet.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }

  void editAction() {
    Map payload = {
      '4ac8d549-460c-4511-9a16-18d3935bf8bd': {'height': widgetHeight}
    };
    Map effect = {
      'payload': payload,
      'target': "stylesheets:1b8d6841-84b1-469c-9fcf-6881a4efb8b3",
      'type': "stylesheet:update",
    };
    Map<String, dynamic> body = {
      'affectedPageIds': [''],
      'createdAt': '',
      'effects': [effect],
      'id': '',
      'targetPageId': ''
    };
    api.shopEditAction(GlobalUtils.activeToken.accessToken, 'themeId', body);
  }

//  affectedPageIds: ["269bf4d2-5fe5-48fe-8ce1-2560c2bd4f57"]
//  createdAt: "2020-10-19T15:28:12.831Z"
//  effects: [{type: "stylesheet:update", target: "stylesheets:1b8d6841-84b1-469c-9fcf-6881a4efb8b3",…}]
//  id: "40932d85-f984-45f8-adbe-f1b61031b615"
//  targetPageId: "269bf4d2-5fe5-48fe-8ce1-2560c2bd4f57"
}
