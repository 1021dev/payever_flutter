import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/logo_view.dart';
import 'package:payever/shop/views/edit/element/menu_view.dart';
import 'package:payever/shop/views/edit/element/shape_view.dart';
import 'package:payever/shop/views/edit/element/shop_cart_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_category_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_detail_view.dart';
import 'package:payever/shop/views/edit/element/shop_products_view.dart';
import 'package:payever/shop/views/edit/element/social_icon_view.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/shop/views/edit/element/video_view.dart';
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
  final ShopDetailModel activeShop;

  ApiService api = ApiService();
  SectionStyleSheet styleSheet;

  StreamController<double> controller = StreamController.broadcast();
  double widgetHeight = 0;
  GlobalKey key = GlobalKey();

  _SectionViewState({this.shopPage, this.child, this.stylesheets, this.activeShop}) {
    styleSheet = getSectionStyleSheet(child.id);
    widgetHeight = styleSheet.height;
  }

  @override
  void dispose() {
    controller.close(); //Streams must be closed when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _section();
  }

  Widget _section() {
    if (styleSheet == null) {
      return Container();
    }
    print('SectionId: ${child.id}');
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
        case 'video':
          widget = VideoView(
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
          widget = MenuView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'shop-cart':
          widget = ShopCartView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'shop-category':
          widget = ShopProductCategoryView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'shop-products':
          widget = ShopProductsView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'shop-product-details':
          widget = ShopProductDetailView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'logo':
          widget = LogoView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        case 'social-icon':
          widget = SocialIconView(
            child: child,
            stylesheets: stylesheets,
            deviceTypeId: shopPage.stylesheetIds.mobile,
            sectionStyleSheet: styleSheet,
          );
          break;
        default:
          print('Special Child Type: ${child.type}');
          print('Special Styles: ${ stylesheets[shopPage.stylesheetIds.mobile][child.id]}');
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
