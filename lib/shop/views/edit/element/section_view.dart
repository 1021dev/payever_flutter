import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
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
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final ShopPage shopPage;
  final Child section;
  final bool isSelected;
  final Function onTapChild;
  final ShopEditScreenBloc screenBloc;
  final bool enableTapChild;

  const SectionView(
      {this.shopPage,
      this.section,
      this.screenBloc,
      this.isSelected = false,
      this.enableTapChild = true,
      this.onTapChild});

  @override
  _SectionViewState createState() => _SectionViewState(
      shopPage: shopPage, section: section, screenBloc: screenBloc);
}

class _SectionViewState extends State<SectionView> {

  final ShopPage shopPage;
  final Child section;
  final ShopEditScreenBloc screenBloc;
  final double limitSectionHeightChange = 20;

  ApiService api = ApiService();
  SectionStyles sectionStyles;

  StreamController<double> controller = StreamController.broadcast();
  double widgetHeight = 0;
  GlobalKey key = GlobalKey();

  String name;
  String selectChildId = '';
  String activeThemeId;
  double limitSectionHeight = 0;

  _SectionViewState(
      {this.shopPage, this.section, this.screenBloc}) {
    sectionStyles = getSectionStyles(section.id);
    widgetHeight = sectionStyles.height;
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
          bool selectedSection = screenBloc.state.selectedSectionId == section.id;
          if (selectedSection) {
            if (templateSizeState.updateChildSize != null && selectedSection) {
              Future.microtask(
                      () => templateSizeState.setUpdateChildSize(null));
              _changeSection(childSize: templateSizeState.updateChildSize);
            } else if (templateSizeState.newChildSize != null && selectedSection) {
              bool wrongposition =
              wrongPosition(templateSizeState.newChildSize);
              // print('wrong position: $wrongposition, SectionID: ${section.id}, SelectedSectionId:${screenBloc.state.selectedSectionId}');
              if (wrongposition) {
                if (!templateSizeState.wrongPosition)
                  Future.microtask(() =>
                      templateSizeState.setWrongPosition(wrongposition));
              } else {
                if (templateSizeState.wrongPosition)
                  Future.microtask(() =>
                      templateSizeState.setWrongPosition(wrongposition));
              }
            }
          }
          return BlocListener(
            listener: (BuildContext context, ShopEditScreenState state) async {
              if (state.selectedSection) {
                setState(() {
                  selectChildId = '';
                });
                screenBloc.add(RestSelectSectionEvent());
              }
            },
            bloc: screenBloc,
            child: BlocBuilder(
              condition: (ShopEditScreenState state1, state2) {
                if (state2.selectedSectionId != section.id) {
                  setState(() {
                    selectChildId = '';
                  });
                  return false;
                }
                return true;
              },
              bloc: screenBloc,
              builder: (BuildContext context, state) {
                return body(state);
              },
            ),
          );
        });
  }

  Widget body(ShopEditScreenState state) {
    if (sectionStyles == null) {
      return Container();
    }

    name = 'Section';
    if (section.data != null) {
      name = Data.fromJson(section.data).name;
    }

    List<Widget> widgets = [];
    Widget lastElement;
    widgets.add(sectionBackgroundWidget);
    for (Child child in section.children) {
      BaseStyles styles = getBaseStyles(child.id);
      if (styles == null || styles.display == 'none') {
        continue;
      }
      Widget childWidget = getChild(state, child, styles);
      if (childWidget != null) {
        _getLimitedSectionHeight(child);
        Widget element = GestureDetector(
          key: ObjectKey(child.id),
          onTap: (widget.enableTapChild && selectChildId != child.id)
              ? () {
            widget.onTapChild();
            screenBloc.add(SelectSectionEvent(
                sectionId: section.id, selectedChild: true));
            setState(() {
              selectChildId = child.id;
            });
          }
              : null,
          child: childWidget,
        );
        if (selectChildId == child.id)
          lastElement = element;
        else
          widgets.add(element);
      }
    }
    if (lastElement != null)
      widgets.add(lastElement);
    // update Section Height:
    if (widgetHeight < limitSectionHeight) {
      widgetHeight = limitSectionHeight;
      // String gridTemplateRows = sectionStyles.gridTemplateRows;
      // if (gridTemplateRows != null && gridTemplateRows.isNotEmpty) {
      //   List<String>rows = gridTemplateRows.split(' ');
      //   if (rows.length > 1) {
      //     double heightFactor = double.parse(rows.last);
      //     if (sectionStyles.height - heightFactor > 0)
      //       widgetHeight = sectionStyles.height - heightFactor;
      //   }
      // }
    }
    addActiveWidgets(widgets);
    return StreamBuilder(
      stream: controller.stream,
      builder: (context, snapshot) => Container(
        key: key,
        height: snapshot.hasData ? snapshot.data : widgetHeight,
        width: double.infinity,
        child: Stack(
          children: widgets,
        ),
      ),
    );
  }

  Widget getChild(ShopEditScreenState state, Child child, BaseStyles styles) {
    Widget childView;
    switch (child.type) {
      case 'text':
        childView = TextView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'button':
        childView = ButtonView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'image':
        childView = ImageView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'video':
        childView = VideoView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shape':
        childView = ShapeView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'block':
        childView = BlockView(
          child: child,
          sectionId: section.id,
          screenBloc: screenBloc,
          enableTapChild: widget.enableTapChild,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          onTapChild: widget.onTapChild,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'menu':
        childView = MenuView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-cart':
        childView = ShopCartView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-category':
        childView = ShopProductCategoryView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-products':
        childView = ShopProductsView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-product-details':
        childView = ShopProductDetailView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'logo':
        childView = LogoView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'social-icon':
        childView = SocialIconView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: shopPage.stylesheetIds.mobile,
          sectionStyles: sectionStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      default:
        print('Special Child Type: ${child.type}');
    }
    return childView;
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
        height: 25,
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
                // Check Limitation
                if (limitSectionHeight > 0 && newHeight < limitSectionHeight)
                  return;
                double dHeight = widgetHeight - newHeight;
                if (top && dHeight.abs() > limitSectionHeightChange) {
                  if (dHeight> 0) {
                    if (widgetHeight - limitSectionHeightChange < limitSectionHeightChange) {
                      widgetHeight = limitSectionHeightChange;
                    } else {
                      widgetHeight -= limitSectionHeightChange;
                    }
                  } else {
                    widgetHeight += limitSectionHeightChange;
                  }
                  newHeight = widgetHeight;
                }
                if (newHeight >= limitSectionHeightChange) {
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
              _changeSection();
            },
            onVerticalDragStart: (details) {
              print('onVerticalDragDown dy = ${details.globalPosition.dy}');
            },
            child: Container(
              width: 40,
              padding: EdgeInsets.only(top: top ? 0: 10, bottom: top ? 10: 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(top ? 10 : 0),
                    bottomRight: Radius.circular(top ? 10 : 0),
                    topLeft: Radius.circular(top ? 0 : 10),
                    topRight: Radius.circular(top ? 0 : 10),
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  top ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.blue,
                  size: 15,
                ),
              ),
            )));
  }

  get sectionBackgroundWidget {
    return Container(
      width: double.infinity,
      //styleSheet.width,
      height: widgetHeight,
      alignment: sectionStyles.getBackgroundImageAlignment(),
      child: BackgroundView(styles: sectionStyles),
    );
  }

  SectionStyles getSectionStyles(String childId) {
    try {
      Map<String, dynamic> json = screenBloc.state.stylesheets[shopPage.stylesheetIds.mobile][childId];
      // if (json['display'] != 'none') {
      //   print('==============================================');
      //   print('SectionID: $childId');
      //   print('Section StyleSheet: $json');
      // }
      return SectionStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  _getLimitedSectionHeight(Child child) {
    BaseStyles baseStyles = getBaseStyles(child.id);
    if (baseStyles == null || baseStyles.display == 'none') return;

    double height = baseStyles.height;
    double top = baseStyles.getMarginTop(sectionStyles);
    double newLimitSectionHeight = height + top + baseStyles.paddingV + baseStyles.marginBottom;
    if (limitSectionHeight < newLimitSectionHeight)
      limitSectionHeight = newLimitSectionHeight;
  }

  _changeSection({NewChildSize childSize}) {
    Map<String, dynamic> payload = {};
    if (selectChildId != null && childSize != null) {
      payload = childPayload(childSize);
    } else {
      payload = sectionPayload;
    }
    print('payload: $payload');
    screenBloc.add(UpdateSectionEvent(sectionId:section.id, payload: payload));
  }

  Map<String, dynamic> get sectionPayload {
    Map<String, dynamic> payloadSection = {};
    payloadSection['height'] = widgetHeight;
    if (sectionStyles.gridTemplateRows != null && sectionStyles.gridTemplateRows.isNotEmpty) {
      List<String>gridRows = sectionStyles.gridTemplateRows.split(' ');
      double marginBottom = double.parse(gridRows.last); // To Last Vertical Element
      double dy = widgetHeight - sectionStyles.height;
      double updatedMarginBottom = marginBottom + dy;
      gridRows.removeLast();
      // gridRows.add('${updatedMarginBottom.round()}');
      gridRows.add('0');
      payloadSection['gridTemplateRows'] = '$gridRows'.replaceAll(RegExp(r"[^\s\w]"), '');
    }
    Map<String, dynamic> payload = {
      section.id: payloadSection
    };
    return payload;
  }

  Map<String, dynamic> childPayload(NewChildSize size) {
    Map<String, dynamic> payloadSection = {};
    BaseStyles baseStyles = getBaseStyles(selectChildId);
    double marginTop = baseStyles.getMarginTopAssist(size.newTop, sectionStyles.gridTemplateRows, baseStyles.gridRow, isReverse: true);
    double marginLeft = baseStyles.getMarginLeftAssist(size.newLeft, sectionStyles.gridTemplateColumns, baseStyles.gridColumn, isReverse: true);
    String margin = '$marginTop 0 0 $marginLeft';
    payloadSection['margin'] = margin;
    payloadSection['marginTop'] = marginTop;
    payloadSection['marginLeft'] = marginLeft;
    payloadSection['height'] = size.newHeight;
    payloadSection['width'] = size.newWidth / GlobalUtils.shopBuilderWidthFactor;
    Map<String, dynamic>  payload = {
      selectChildId: payloadSection
    };
    return payload;
  }

  bool wrongPosition(NewChildSize childSize) {
    bool wrongBoundary = childSize.newTop < 0 ||
        childSize.newLeft < 0 ||
        (childSize.newTop + childSize.newHeight > widgetHeight) ||
        (childSize.newLeft + childSize.newWidth > Measurements.width);

    if (wrongBoundary) return true;
    for(Child child in section.children) {
      if (child.id == selectChildId) continue;
      BaseStyles baseStyles = getBaseStyles(child.id);
      bool isWrong = wrongPositionWithOrderChildren(childSize, baseStyles);
      if (isWrong)
        return true;
    }
    // print('New Position: Top: ${childSize.newTop}, Left: ${childSize.newLeft}, SectionID: ${section.id}, SelectedSectionId:${screenBloc.state.selectedSectionId}');
    return false;
  }

  bool wrongPositionWithOrderChildren(NewChildSize childSize, BaseStyles styles) {
    if (styles == null || styles.display == 'none') return false;

    double x01 = styles.getMarginLeft(sectionStyles);
    double y01 = styles.getMarginTop(sectionStyles);
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

  BaseStyles getBaseStyles(String childId) {
    return BaseStyles.fromJson(screenBloc.state.stylesheets[shopPage.stylesheetIds.mobile][childId]);
  }
}
