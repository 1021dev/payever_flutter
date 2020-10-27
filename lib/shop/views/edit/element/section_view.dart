import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/element/block_view.dart';
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
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final ShopPage shopPage;
  final Child child;
  final Map<String, dynamic> stylesheets;
  final bool isSelected;
  final Function onTapChild;

  const SectionView(
      {this.shopPage,
      this.child,
      this.stylesheets,
      this.isSelected = false,
      this.onTapChild});

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

  String name;
  String selectChildId = '';
  String activeThemeId;

  _SectionViewState(
      {this.shopPage, this.child, this.stylesheets, this.activeShop}) {
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
    activeThemeId = Provider.of<GlobalStateModel>(context, listen: false)
        .activeTheme
        .themeId;
    return Consumer<TemplateSizeStateModel>(
        builder: (context, templateSizeState, child1) {
      NewChildSize childSize = templateSizeState.newChildSize;
      if (childSize != null &&
          templateSizeState.selectedSectionId == child.id) {
        bool wrongposition = wrongPosition(childSize);
        if (wrongposition) {
          if (!templateSizeState.wrongPosition) Future.microtask(() =>
                // context.read<MyNotifier>(context).fetchSomething(someValue);
                templateSizeState.setWrongPosition(wrongposition));
        } else {
          if (templateSizeState.wrongPosition)
            Future.microtask(
                () => templateSizeState.setWrongPosition(wrongposition));
        }
      }
      if (templateSizeState.selectedSectionId != child.id ||
          templateSizeState.refreshSelectedChild) {
        selectChildId = '';
      }
      return body;
    });
  }

  bool wrongPosition(NewChildSize childSize) {
    bool wrongBoundary = childSize.newTop < 0 ||
        childSize.newLeft < 0 ||
        (childSize.newTop + childSize.newHeight > widgetHeight) ||
        (childSize.newLeft + childSize.newWidth > Measurements.width);
    if (wrongBoundary) return true;

    for(Child element in child.children) {
      if (element.id == selectChildId) continue;
      BaseStyles baseStyles = BaseStyles.fromJson(stylesheets[shopPage.stylesheetIds.mobile][element.id]);
      bool isWrong = wrongPosition1(childSize, baseStyles);
      if (isWrong)
        return true;
    }
    return false;
  }

  bool wrongPosition1(NewChildSize childSize, BaseStyles styles) {
    if (styles == null || styles.display == 'none') return false;

    double x01 = styles.getMarginLeft(styleSheet);
    double y01 = styles.getMarginTop(styleSheet);
    double x02 = x01 + styles.width;
    double y02 = y01 + styles.height;

    double x1 = childSize.newLeft;
    double y1 = childSize.newTop;
    double x2 = x1 + childSize.newWidth;
    double y2 = y1 + childSize.newHeight;
    // top left (x1, y1)
    if ((x01< x1 && x1 <= x02) && (y01< y1 && y1 <= y02))
      return true;
    // top right (x2, y1)
    if ((x01< x2 && x2 <= x02) && (y01< y1 && y1 <= y02))
      return true;
    // bottom left (x1, y2)
    if ((x01< x1 && x1 <= x02) && (y01< y2 && y2 <= y02))
      return true;
    // bottom right (x2, y2)
    if ((x01< x2 && x2 <= x02) && (y01< y2 && y2 <= y02))
      return true;
    // Revers
    // top left (x01, y01)
    if ((x1< x01 && x01 <= x1) && (y1< y01 && y01 <= y2))
      return true;
    // top right (x02, y01)
    if ((x1< x02 && x02 <= x2) && (y1< y01 && y01 <= y2))
      return true;
    // bottom left (x01, y02)
    if ((x1< x01 && x01 <= x2) && (y1< y02 && y02 <= y2))
      return true;
    // bottom right (x02, y02)
    if ((x1< x02 && x02 <= x2) && (y1< y02 && y02 <= y2))
      return true;
    return false;
  }

  Widget get body {
    if (styleSheet == null) {
      return Container();
    }

    name = 'Section';
    if (child.data != null) {
      name = Data.fromJson(child.data).name;
    }

    List<Widget> widgets = [];
    widgets.add(sectionBackgroundWidget);
    child.children.forEach((child) {
      Widget childWidget = getChild(child);
      if (childWidget != null) {
        Widget element = GestureDetector(
          onTap: () {
            context
                .read<TemplateSizeStateModel>()
                .setSelectedSectionId(widget.child.id);
            widget.onTapChild();
            setState(() {
              selectChildId = child.id;
            });
          },
          child: childWidget,
        );
        widgets.add(element);
      }
    });

    addActiveWidgets(widgets);

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

  Widget getChild(Child child) {
    Widget widget;
    switch (child.type) {
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
        widget = BlockView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
        );
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
          isSelected: selectChildId == child.id,
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
          isSelected: selectChildId == child.id,
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
          isSelected: selectChildId == child.id,
        );
        break;
      case 'social-icon':
        widget = SocialIconView(
          child: child,
          stylesheets: stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyleSheet: styleSheet,
          isSelected: selectChildId == child.id,
        );
        break;
      default:
        print('Special Child Type: ${child.type}');
        print(
            'Special Styles: ${stylesheets[shopPage.stylesheetIds.mobile][child.id]}');
    }
    return widget;
  }

  void addActiveWidgets(List<Widget> widgets) {
    if (!widget.isSelected) return;
    // Add Drag Buttons
    // Top
    widgets.add(Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: dragArrow(true),
    ));
    // Bottom
    widgets.add(Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: dragArrow(false),
    ));
    // Add Edges ---
    // top
    widgets.add(Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 4,
        color: Colors.blueAccent,
      ),
    ));
    // Left
    widgets.add(Positioned(
      top: 0,
      left: 0,
      bottom: 0,
      child: Container(
        width: 4,
        color: Colors.blueAccent,
      ),
    ));
    // Bottom
    widgets.add(Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 4,
        color: Colors.blueAccent,
      ),
    ));
    // Right
    widgets.add(Positioned(
      top: 0,
      right: 0,
      bottom: 0,
      child: Container(
        width: 4,
        color: Colors.blueAccent,
      ),
    ));
    // Section Name
    widgets.add(Positioned(
      top: 4,
      left: 4,
      child: Container(
        width: 40,
        height: 18,
        alignment: Alignment.center,
        color: Colors.blue,
        child: Text(
          name,
          style: TextStyle(fontSize: 10),
        ),
      ),
    ));
  }

  Widget dragArrow(bool top) {
    return Container(
        width: 40,
        height: 15,
        alignment: Alignment.center,
        child: GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                RenderBox box = key.currentContext.findRenderObject();
                Offset position1 =
                    box.localToGlobal(Offset.zero); //this is global position
                double newHeight;
                if (top) {
                  newHeight = widgetHeight - details.localPosition.dy;
                } else {
                  newHeight = details.globalPosition.dy - position1.dy;
                }
                if (newHeight >= 30) {
                  widgetHeight = newHeight;
                  widgetHeight.isNegative
                      ? Navigator.pop(context)
                      : controller.add(widgetHeight);
                }
              });
            },
            behavior: HitTestBehavior.translucent,
            onVerticalDragDown: (details) {
              print('onVerticalDragDown dy = ${details.globalPosition.dy}');
            },
            onVerticalDragEnd: (DragEndDetails details) {
              editAction();
            },
            onVerticalDragStart: (details) {
              print('onVerticalDragDown dy = ${details.globalPosition.dy}');
            },
            child: Container(
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(top ? 10 : 0),
                  bottomRight: Radius.circular(top ? 10 : 0),
                  topLeft: Radius.circular(top ? 0 : 10),
                  topRight: Radius.circular(top ? 0 : 10),
                ),
              ),
              child: Icon(
                top ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                color: Colors.blue,
                size: 15,
              ),
            )));
  }

  get sectionBackgroundWidget {
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
    if (shopPage.id != 'dbe497ff-97dd-4e30-8230-67ccb37343e1') return;
    Map payload = {
      child.id: {'height': widgetHeight}
    };
    Map effect = {
      'payload': payload,
      'target': 'stylesheets:${shopPage.stylesheetIds.mobile}',
      // shopPage.stylesheetIds.mobile
      'type': "stylesheet:update",
    };
    print('activeThemeId: $activeThemeId');
    if (activeThemeId != null && activeThemeId.isNotEmpty) {
      Map<String, dynamic> body = {
        'affectedPageIds': [shopPage.id],
        'createdAt': DateFormat("yyyy-MM-dd'T'hh:mm:ss").format(DateTime.now()),
        'effects': [effect],
        'id': Uuid().v4(),
        'targetPageId': shopPage.id
      };
      print('update Body: $body');
      api
          .shopEditAction(
              GlobalUtils.activeToken.accessToken, activeThemeId, body)
          .then((value) {
        if (value is DioError) {
          Fluttertoast.showToast(msg: value.error);
        }
      });
    } else {
      print('Error: No active Theme!');
    }
  }
}
