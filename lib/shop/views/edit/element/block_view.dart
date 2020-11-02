import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/commons/utils/common_utils.dart';
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
          bool selectedSection = widget.screenBloc.state.selectedBlockId == block.id && selectChildId.length > 0;
          if (selectedSection) {
            if (templateSizeState.updateChildSize != null && selectedSection) {
              Future.microtask(
                      () => templateSizeState.setUpdateChildSize(null));
              _changeSection(childSize: templateSizeState.updateChildSize);
            } else if (templateSizeState.newChildSize != null && selectedSection) {
              bool wrongposition =
              wrongPosition(templateSizeState.newChildSize);
              print('wrong position: $wrongposition, Block ID: ${block.id}');
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
              print('BlockView: ${state.selectedSection}, ${state.selectedBlockSection}');
              if (state.selectedSection || state.selectedBlockSection) {
                setState(() {
                  selectChildId = '';
                });
                widget.screenBloc.add(RestSelectBlockEvent());
              }
            },
            bloc: widget.screenBloc,
            child: BlocBuilder(
              condition: (ShopEditScreenState state1, ShopEditScreenState state2) {
                if (state2.selectedBlockId != block.id) {
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
                  widget.screenBloc.add(SelectBlockEvent(
                      sectionId: widget.sectionId,
                      blockId: block.id,
                      selectedBlockChild: true));
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
     //    width: blockStyles.width,
     //    height: blockStyles.height,
     // // decoration: decoration,
     //    margin: EdgeInsets.only(
     //        left: blockStyles.getMarginLeft(sectionStyles),
     //        right: blockStyles.marginRight,
     //        top: blockStyles.getMarginTop(sectionStyles),
     //        bottom: blockStyles.marginBottom),
        alignment: blockStyles.getBackgroundImageAlignment(),
        child: Stack(
          overflow: Overflow.visible,
            children: widgets));
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

  _changeSection({NewChildSize childSize}) {
    Map<String, dynamic> payload = childPayload(childSize);

    print('payload: $payload');
    widget.screenBloc.add(UpdateSectionEvent(sectionId:widget.sectionId, payload: payload));
  }

  Map<String, dynamic> childPayload(NewChildSize size) {
    Map<String, dynamic> payloadSection = {};
    BaseStyles baseStyles = getBaseStyles(selectChildId);
    double marginTop = baseStyles.getMarginTopAssist(size.newTop, blockStyles.gridTemplateRows, baseStyles.gridRow, isReverse: true);
    double marginLeft = baseStyles.getMarginLeftAssist(size.newLeft, blockStyles.gridTemplateColumns, baseStyles.gridColumn, isReverse: true);
    String margin = '$marginTop 0 0 $marginLeft';
    payloadSection['margin'] = margin;
    payloadSection['marginTop'] = marginTop;
    payloadSection['marginLeft'] = marginLeft;
    payloadSection['height'] = size.newHeight - baseStyles.paddingV * 2;
    payloadSection['width'] = (size.newWidth - baseStyles.paddingH * 2)/ GlobalUtils.shopBuilderWidthFactor;
    Map<String, dynamic>  payload = {
      selectChildId: payloadSection
    };
    return payload;
  }

  bool wrongPosition(NewChildSize childSize) {
    bool wrongBoundary = childSize.newTop < 0 ||
        childSize.newLeft < 0 ||
        (childSize.newTop + childSize.newHeight > blockStyles.height) ||
        (childSize.newLeft + childSize.newWidth > blockStyles.width);

    if (wrongBoundary) return true;
    for(Child child in block.children) {
      if (child.id == selectChildId) continue;
      BaseStyles baseStyles = getBaseStyles(child.id);
      if (baseStyles == null || baseStyles.display == 'none') continue;
      bool isWrong = wrongPositionWithOrderChildren(childSize, baseStyles);
      // if (child.type == 'button' && isWrong)
      // print('Child Type: ${child.type} wrong: $isWrong');
      if (isWrong)
        return true;
    }
    // print('New Position: Top: ${childSize.newTop}, Left: ${childSize.newLeft}, SectionID: ${section.id}, SelectedSectionId:${screenBloc.state.selectedSectionId}');
    return false;
  }

  bool wrongPositionWithOrderChildren(NewChildSize childSize, BaseStyles styles) {
    double x0 = styles.getMarginLeft(blockStyles);
    double y0 = styles.getMarginTop(blockStyles);
    double width0 = styles.width + styles.paddingH * 2;
    double height0 = styles.height + styles.paddingV * 2;

    double x1 = childSize.newLeft;
    double y1 = childSize.newTop;
    double width1 = childSize.newWidth;
    double height1 = childSize.newHeight;

    if (x0 + width0 < x1 || x1 + width1 < x0
        || y0 + height0 < y1 || y1 + height1 < y0)
      return false;
    else
      return true;
  }

  BaseStyles getBaseStyles(String childId) {
    return BaseStyles.fromJson(widget.screenBloc.state.stylesheets[deviceTypeId][childId]);
  }

  SectionStyles getSectionStyleSheet() {
    try {
      Map<String, dynamic> json = widget.screenBloc.state.stylesheets[deviceTypeId][block.id];
      if (json == null || json['display'] == 'none') return null;
      // print('$TAG Block ID ${block.id}');
      // print('$TAG Bloc style: $json');
      return SectionStyles.fromJson(json);
    } catch (e) {
      print('$TAG Error: ${e.toString()}');
      return null;
    }
  }
}
