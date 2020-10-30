import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/models/template_size_state_model.dart';
import 'package:payever/shop/views/edit/element/shape_view.dart';
import 'package:payever/shop/views/edit/element/shop_cart_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_category_view.dart';
import 'package:payever/shop/views/edit/element/shop_product_detail_view.dart';
import 'package:payever/shop/views/edit/element/shop_products_view.dart';
import 'package:payever/shop/views/edit/element/social_icon_view.dart';
import 'package:payever/shop/views/edit/element/sub_element/background_view.dart';
import 'package:payever/shop/views/edit/element/sub_element/resizeable_view.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/shop/views/edit/element/video_view.dart';
import 'package:provider/provider.dart';

import 'button_view.dart';
import 'image_view.dart';
import 'logo_view.dart';
import 'menu_view.dart';

class BlockView extends StatefulWidget {
  final Child child;
  final String sectionId;
  final String deviceTypeId;
  final SectionStyles sectionStyles;
  final ShopEditScreenBloc screenBloc;
  final bool enableTapChild;
  final Function onTapChild;
  final bool isSelected;

  const BlockView(
      {this.child,
      this.sectionId,
      this.deviceTypeId,
      this.sectionStyles,
      this.onTapChild,
      this.enableTapChild = true,
      this.isSelected = false,
      this.screenBloc});

  @override
  _BlockViewState createState() => _BlockViewState(
      block: child,
      sectionStyles: sectionStyles,
      deviceTypeId: deviceTypeId);
}

class _BlockViewState extends State<BlockView> {
  final Child block;
  final SectionStyles sectionStyles;
  final String deviceTypeId;
  SectionStyles blockStyles;
  final String TAG = 'BlockView : ';
  String selectChildId = '';

  _BlockViewState(
      {this.block, this.sectionStyles, this.deviceTypeId});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    blockStyles = getSectionStyleSheet();

    if (blockStyles == null) {
      return Container();
    }
    return Consumer<TemplateSizeStateModel>(
        builder: (context, templateSizeState, child1) {
          bool selectedSection = widget.screenBloc.state.selectedSectionId == widget.sectionId;
          if (selectedSection) {
            if (templateSizeState.updateChildSize != null && selectedSection) {
              Future.microtask(
                      () => templateSizeState.setUpdateChildSize(null));
              // _changeSection(childSize: templateSizeState.updateChildSize);
            } else if (templateSizeState.newChildSize != null && selectedSection) {
              // bool wrongposition =
              // wrongPosition(templateSizeState.newChildSize);
              // // print('wrong position: $wrongposition, SectionID: ${section.id}, SelectedSectionId:${screenBloc.state.selectedSectionId}');
              // if (wrongposition) {
              //   if (!templateSizeState.wrongPosition)
              //     Future.microtask(() =>
              //         templateSizeState.setWrongPosition(wrongposition));
              // } else {
              //   if (templateSizeState.wrongPosition)
              //     Future.microtask(() =>
              //         templateSizeState.setWrongPosition(wrongposition));
              // }
            }
          }
          return BlocListener(
            listener: (BuildContext context, ShopEditScreenState state) async {
              if (state.selectedSection) {
                setState(() {
                  selectChildId = '';
                });
                widget.screenBloc.add(RestSelectSectionEvent());
              }
            },
            bloc: widget.screenBloc,
            child: BlocBuilder(
              condition: (ShopEditScreenState state1, state2) {
                if (state2.selectedSectionId != widget.sectionId) {
                  setState(() {
                    selectChildId = '';
                  });
                  return false;
                }
                return true;
              },
              bloc: widget.screenBloc,
              builder: (BuildContext context, state) {
                return ResizeableView(
                    width: blockStyles.width,
                    height: blockStyles.height,
                    left: blockStyles.getMarginLeft(sectionStyles),
                    top: blockStyles.getMarginTop(sectionStyles),
                    isSelected: widget.isSelected,
                    child: body(state));
              },
            ),
          );
        });

  }

  Widget body(ShopEditScreenState state) {
    List<Widget> widgets = [];
    Widget lastElement;
    widgets.add(BackgroundView(styles: blockStyles));
    for (Child child in block.children) {
      BaseStyles styles = getBaseStyles(child.id);
      if (styles == null || styles.display == 'none') {
        continue;
      }
      Widget childWidget = getChild(state, child);
      if (childWidget != null) {
        // _getLimitedSectionHeight(child);
        Widget element = GestureDetector(
          key: ObjectKey(child.id),
          onTap: (widget.enableTapChild && selectChildId != child.id)
              ? () {
            widget.onTapChild();
            widget.screenBloc.add(SelectSectionEvent(
                sectionId: widget.sectionId, selectedChild: true));
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

    return Container(
        // width: styleSheet.width,
        // height: styleSheet.height,
//      decoration: decoration,
//         margin: EdgeInsets.only(
//             left: styleSheet.getMarginLeft(sectionStyles),
//             right: styleSheet.marginRight,
//             top: styleSheet.getMarginTop(sectionStyles),
//             bottom: styleSheet.marginBottom),
        alignment: blockStyles.getBackgroundImageAlignment(),
        child: Stack(children: widgets));
  }

  Widget getChild(ShopEditScreenState state, Child child) {
    Widget childView;
    switch (child.type) {
      case 'text':
        childView = TextView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'button':
        childView = ButtonView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'image':
        childView = ImageView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'video':
        childView = VideoView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shape':
        childView = ShapeView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'block':
        childView = BlockView(
          child: child,
          sectionId: widget.sectionId,
          screenBloc: widget.screenBloc,
          enableTapChild: widget.enableTapChild,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          onTapChild: widget.onTapChild,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'menu':
        childView = MenuView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-cart':
        childView = ShopCartView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-category':
        childView = ShopProductCategoryView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-products':
        childView = ShopProductsView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'shop-product-details':
        childView = ShopProductDetailView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'logo':
        childView = LogoView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      case 'social-icon':
        childView = SocialIconView(
          child: child,
          stylesheets: state.stylesheets,
          deviceTypeId: deviceTypeId,
          sectionStyles: blockStyles,
          isSelected: selectChildId == child.id,
        );
        break;
      default:
        print('Special Child Type: ${child.type}');
    }
    return childView;
  }

  // _changeSection({NewChildSize childSize}) {
  //   Map<String, dynamic> payload = {};
  //   if (selectChildId != null && childSize != null) {
  //     payload = childPayload(childSize);
  //   } else {
  //     payload = sectionPayload;
  //   }
  //   print('payload: $payload');
  //   widget.screenBloc.add(UpdateSectionEvent(sectionId:widget.sectionId, payload: payload));
  // }
  //
  // Map<String, dynamic> get sectionPayload {
  //   Map<String, dynamic> payloadSection = {};
  //   payloadSection['height'] = widgetHeight;
  //   if (sectionStyles.gridTemplateRows != null && sectionStyles.gridTemplateRows.isNotEmpty) {
  //     List<String>gridRows = sectionStyles.gridTemplateRows.split(' ');
  //     double marginBottom = double.parse(gridRows.last); // To Last Vertical Element
  //     double dy = widgetHeight - sectionStyles.height;
  //     double updatedMarginBottom = marginBottom + dy;
  //     gridRows.removeLast();
  //     // gridRows.add('${updatedMarginBottom.round()}');
  //     gridRows.add('0');
  //     payloadSection['gridTemplateRows'] = '$gridRows'.replaceAll(RegExp(r"[^\s\w]"), '');
  //   }
  //   Map<String, dynamic> payload = {
  //     section.id: payloadSection
  //   };
  //   return payload;
  // }
  //
  // Map<String, dynamic> childPayload(NewChildSize size) {
  //   Map<String, dynamic> payloadSection = {};
  //   BaseStyles baseStyles = getBaseStyles(selectChildId);
  //   double marginTop = baseStyles.getMarginTopAssist(size.newTop, sectionStyles.gridTemplateRows, baseStyles.gridRow, isReverse: true);
  //   double marginLeft = baseStyles.getMarginLeftAssist(size.newLeft, sectionStyles.gridTemplateColumns, baseStyles.gridColumn, isReverse: true);
  //   String margin = '$marginTop 0 0 $marginLeft';
  //   payloadSection['margin'] = margin;
  //   payloadSection['marginTop'] = marginTop;
  //   payloadSection['marginLeft'] = marginLeft;
  //   payloadSection['height'] = size.newHeight;
  //   payloadSection['width'] = size.newWidth / GlobalUtils.shopBuilderWidthFactor;
  //   Map<String, dynamic>  payload = {
  //     selectChildId: payloadSection
  //   };
  //   return payload;
  // }

  BaseStyles getBaseStyles(String childId) {
    return BaseStyles.fromJson(widget.screenBloc.state.stylesheets[deviceTypeId][childId]);
  }

  SectionStyles getSectionStyleSheet() {
    try {
      Map<String, dynamic> json = widget.screenBloc.state.stylesheets[deviceTypeId][block.id];
      if (json == null || json['display'] == 'none') return null;
      print('$TAG Block ID ${block.id}');
      print('$TAG Bloc style: $json');
      return SectionStyles.fromJson(json);
    } catch (e) {
      print('$TAG Error: ${e.toString()}');
      return null;
    }
  }
}
