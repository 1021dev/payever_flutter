import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payever/apis/api_service.dart';
import 'package:payever/blocs/bloc.dart';
import 'package:payever/blocs/shop/shop_edit/shop_edit_bloc.dart';
import 'package:payever/commons/commons.dart';
import 'package:payever/shop/models/constant.dart';
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
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/shop/views/edit/element/video_view.dart';
import 'package:payever/shop/views/edit/sub_element/background_view.dart';
import 'package:payever/shop/views/edit/sub_element/resizeable_view.dart';
import 'package:provider/provider.dart';
import 'button_view.dart';
import 'image_view.dart';

class SectionView extends StatefulWidget {
  final String deviceTypeId;
  final String templateId;
  final String sectionId;
  final bool isSelected;
  final Function onTapChild;
  final ShopEditScreenBloc screenBloc;
  final bool enableTapChild;

  const SectionView(
      {this.deviceTypeId,
        this.templateId,
        this.sectionId,
        this.screenBloc,
        this.isSelected = false,
        this.enableTapChild = true,
        this.onTapChild});

  @override
  _SectionViewState createState() => _SectionViewState(
      deviceTypeId: deviceTypeId, sectionId: sectionId);
}

class _SectionViewState extends State<SectionView> {
  final String deviceTypeId;
  final String sectionId;
  final double limitSectionHeightChange = 20;
  Template template;
  Child section;
  ApiService api = ApiService();
  SectionStyles sectionStyles;

  StreamController<double> controller = StreamController.broadcast();
  double widgetHeight = 0;
  GlobalKey key = GlobalKey();

  String name;
  String selectChildId = '';
  String activeThemeId;
  double limitSectionHeight = 0;

  double relativeMarginLeft = -1;
  double relativeMarginTop = -1;

  bool blockDragging = false;
  ChildSize blockDraggingSize;

  _SectionViewState({this.deviceTypeId, this.sectionId});

  @override
  void dispose() {
    controller.close(); //Streams must be closed when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sectionStyles = getSectionStyles(sectionId);
    widgetHeight = sectionStyles.height;
    activeThemeId = Provider.of<GlobalStateModel>(context, listen: false)
        .activeTheme
        .themeId;

    return Consumer<TemplateSizeStateModel>(
        builder: (context, templateSizeState, child1) {
          progressResize(templateSizeState);
          return BlocListener(
            listener: (BuildContext context, ShopEditScreenState state) async {
              if (state.selectedSectionId == sectionId && state.selectedChild == null) {
                setState(() {
                  selectChildId = '';
                });
              }
            },
            bloc: widget.screenBloc,
            child: BlocBuilder(
              condition: (ShopEditScreenState state1, ShopEditScreenState state2) {
                if (state2.selectedSectionId != sectionId) {
                  setState(() {
                    selectChildId = '';
                  });
                  return false;
                }
                return true;
              },
              bloc: widget.screenBloc,
              builder: (BuildContext context, state) {
                return body(state);
              },
            ),
          );
        });
  }

  Widget body(ShopEditScreenState state) {
    template =  Template.fromJson(state.templates[widget.templateId]);
    section = template.children.firstWhere((element) => element.id == sectionId);
    sectionStyles = SectionStyles.fromJson(state.stylesheets[deviceTypeId][sectionId]);

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
      Widget resizeableWidget =
      getResizeableChildWidget(state, child, [sectionStyles]);
      if (resizeableWidget == null) continue;
      if (selectChildId == child.id)
        lastElement = resizeableWidget;
      else
        widgets.add(resizeableWidget);
      // Add Block View
      if (child.type == 'block') {
        child.children.forEach((element) { element.blocks = [];});
        addBlockChildren(state, widgets,[sectionStyles], child);
      }
    }

    if (lastElement != null) {
      widgets.add(lastElement);
      if (selectChildId == state.selectedBlockId && !blockDragging) {
        Child block = section.children.firstWhere((element) => element.id == selectChildId);
        addBlockChildren(state, widgets,[sectionStyles], block, add: true);
      }
    }
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
    addRelativeLines(widgets);
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

  void addBlockChildren(ShopEditScreenState state, List<Widget> widgets,
      List<SectionStyles> sectionStyles, Child block,
      {bool add = false}) {
    bool isDraggingBlock = selectChildId == block.id && blockDragging;
    if (selectChildId == block.id && add == false || isDraggingBlock) return;

    Widget lastElement;
    Map<String, dynamic> json = state.stylesheets[deviceTypeId][block.id];
    SectionStyles blockStyles = SectionStyles.fromJson(json);
    List<SectionStyles> newSectionStyles = [blockStyles];
    newSectionStyles.addAll(sectionStyles);
    for (Child child in block.children) {
      Widget resizeableWidget = getResizeableChildWidget(state, child, newSectionStyles);
      if (resizeableWidget == null) continue;
      List<Child>blocks = [block];
      blocks.addAll(block.blocks);
      child.blocks = blocks;
      if (selectChildId == child.id)
        lastElement = resizeableWidget;
      else
        widgets.add(resizeableWidget);

      // Add Block View
      if (child.type == 'block') {
        addBlockChildren(state, widgets, newSectionStyles, child, add: add);
      }
    }

    if (lastElement != null) {
      widgets.add(lastElement);
      if (selectChildId == state.selectedBlockId && !blockDragging) {
        Child block1 = block.children.firstWhere((element) => element.id == selectChildId);
        addBlockChildren(state, widgets, sectionStyles, block1, add: true);
      }
    }
  }

  Widget getResizeableChildWidget(ShopEditScreenState state, Child child, List<SectionStyles> sectionStyles) {
    BaseStyles styles = getBaseStyles(child.id);
    if (styles == null || !styles.active) return null;

    Widget childElement = getChild(state, child, sectionStyles.first);
    if (childElement == null) return null;
    if (child.type == 'text') {
      styles = TextStyles.fromJson(state.stylesheets[deviceTypeId][child.id]);
    }
    double width = styles.width + styles.paddingH * 2;
    double height = styles.height + styles.paddingV * 2;

    double marginTop = 0; double marginLeft = 0;
    if (child.isButton && styles.height == 0) {
      height = 22 + styles.paddingV * 2;
    }
    for (int i = 0; i < sectionStyles.length; i++) {
      SectionStyles sectionStyle = sectionStyles[i];
      marginLeft += styles.getMarginLeft(sectionStyle);
      marginTop += styles.getMarginTop(sectionStyle);
      styles = sectionStyle;
    }

    Widget childWidget;
    if (child.type == 'shop-category'|| child.type == 'shop-product-details') {
      childWidget = childElement;
    } else {
      childWidget = ResizeableView(
          width: width,
          height: height,
          left: marginLeft,
          top: marginTop,
          sizeChangeable: child.type != 'shop-products',
          isSelected: selectChildId == child.id,
          child: childElement);
      // childWidget = Container(
      //     width: width,
      //     height: height,
      //     margin: EdgeInsets.only(left: marginLeft, top: marginTop),
      //     child: childElement);
    }

    bool isSection = sectionStyles.length == 1;
    if (isSection)
      _getLimitedSectionHeight(child);

    Widget element = GestureDetector(
      key: ObjectKey(child.id),
      onTap: (widget.enableTapChild && selectChildId != child.id)
          ? () {
        widget.onTapChild();
        Child block; String blockId;
        if (child.type == 'block') {
          block = child;
          blockId = child.id;
        } else {
          blockId = child.blocks.isEmpty ? '' : child.blocks.last.id;
        }
        widget.screenBloc.add(SelectSectionEvent(
            sectionId: section.id,
            selectedBlockId: blockId,
            selectedBlock: block,
            selectedChild: child));
        setState(() {
          selectChildId = child.id;
          print('Selected Child ID: $selectChildId');
        });
      }
          : null,
      onLongPress: () {
        RenderBox box = key.currentContext.findRenderObject();
        Offset position1 = box.localToGlobal(Offset.zero);
        final RenderBox overlay = Overlay.of(context).context.findRenderObject();
        var _tapPosition = Offset(marginLeft, marginTop + position1.dy - height/2 - 20);
        showMenu(
          context: context,
          position:  RelativeRect.fromRect(
              _tapPosition & Size(40, 40), // smaller rect, the touch area
              Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
          items: [
            PopupMenuItem(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    PopupMenuItem(
                      child: Text(
                        'Cut',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: ClipboardType.cut,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Copy',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: ClipboardType.copy,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Delete',
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Colors.red),
                      ),
                      value: ClipboardType.delete,
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Paste',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: ClipboardType.paste,
                    ),
                  ],
                ),
              ),
            ),
          ],
          color: Colors.black
        ).then((value) {
          _actionClipboard(state, value);
        });
      },
      child: childWidget,
    );
    return element;
  }

  Widget getChild(
      ShopEditScreenState state, Child child, SectionStyles sectionStyles) {
    Widget childView;
    Map<String, dynamic>stylesheets = state.stylesheets[deviceTypeId];
    switch (child.type) {
      case 'text':
        childView = TextView(
          child: child,
          isEditState: selectChildId == child.id,
          stylesheets: stylesheets,
          onChangeText: (value) {
            _updateTextAction(state, value);
          },
        );
        break;
      case 'button':
        childView = ButtonView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'image':
        childView = ImageView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'video':
        childView = VideoView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'shape':
        childView = ShapeView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'block':
        childView = BlockView(
          child: child,
          stylesheets: stylesheets,
        );
        if (selectChildId == child.id && blockDragging) {
          List<Widget>blockWidget = [childView];
          for (Child blockChild in child.children) {
            BaseStyles styles = getBaseStyles(blockChild.id);
            if (styles == null || !styles.active) continue;
            SectionStyles blockStyle = SectionStyles.fromJson(state.stylesheets[deviceTypeId][child.id]);
            Widget resizeableWidget =
            getResizeableChildWidget(state, blockChild, [blockStyle]);
            if (resizeableWidget == null) continue;
            blockWidget.add(resizeableWidget);
          }
          childView = Stack(
            children: blockWidget,
          );
        }
        break;
      case 'menu':
        childView = MenuView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'shop-cart':
        childView = ShopCartView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'shop-category':
        childView = ShopProductCategoryView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'shop-products':
        childView = ShopProductsView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'shop-product-details':
        childView = ShopProductDetailView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'logo':
        childView = LogoView(
          child: child,
          stylesheets: stylesheets,
        );
        break;
      case 'social-icon':
        childView = SocialIconView(
          child: child,
          stylesheets: stylesheets,
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

  void addRelativeLines(List<Widget> widgets) {
    // Add Relative Lines
    // - Horizontal line
    widgets.add(Positioned(
      top: relativeMarginTop,
      right: 0,
      left: 0,
      child: Container(
        height: 2,
        color: (relativeMarginTop < 0 ? Colors.transparent : Colors.blue),
      ),
    ));
    // - Vertical line
    widgets.add(Positioned(
      top: 0,
      bottom: 0,
      left: relativeMarginLeft,
      child: Container(
        width: 2,
        color: (relativeMarginLeft < 0 ? Colors.transparent : Colors.blue),
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
                  if (dHeight > 0) {
                    if (widgetHeight - limitSectionHeightChange <
                        limitSectionHeightChange) {
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
              // Change Section height
              _changeSectionAction();
            },
            onVerticalDragStart: (details) {
              print('onVerticalDragDown dy = ${details.globalPosition.dy}');
            },
            child: Container(
              width: 40,
              padding: EdgeInsets.only(top: top ? 0 : 10, bottom: top ? 10 : 0),
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

  void progressResize(TemplateSizeStateModel templateSizeState) {
    if (section == null || widget.screenBloc.state.selectedSectionId != section.id) return;

    if (templateSizeState.shopObject != null) {
      _addNewObject(templateSizeState.shopObject);
      Future.microtask(()=>templateSizeState.setShopObject(null));
    }

    if (widget.screenBloc.state.selectedChild == null) return;
    // Initialize Relative Lines after drag
    if (templateSizeState.updateChildSizeFailed) {
      Future.microtask(() {
        initializeRelativeLines();
        initBlockDragging();
      });
    }

    if (templateSizeState.updateChildSize != null) {
      _changeSectionAction(childSize: templateSizeState.updateChildSize);
      Future.microtask(() {
        templateSizeState.setUpdateChildSize(null);
        initializeRelativeLines();
        initBlockDragging();
      });
    }

    if (templateSizeState.newChildSize != null) {
      // Check Wrong position
      progressWrongPosition(templateSizeState);
      Future.microtask(() {
        // Hint Lines
        progressRelativeLines(templateSizeState.newChildSize);
        // Block Dragging
        Child selectedChild = widget.screenBloc.state.selectedChild;
        if (selectedChild.type == 'block' &&
            isDragging(templateSizeState.newChildSize, selectedChild)) {
          setState(() {
            blockDragging = true;
            blockDraggingSize = templateSizeState.newChildSize;
          });
        } else {
          initBlockDragging();
        }
      });
    }
  }

  void initBlockDragging() {
    setState(() {
      blockDragging = false;
      blockDraggingSize = null;
    });
  }

  bool isDragging (ChildSize newSize, Child child) {
    BaseStyles styles = BaseStyles.fromJson(widget.screenBloc.state.stylesheets[deviceTypeId][child.id]);
    return styles.width == newSize.width && styles.height == newSize.height;
  }

  void progressWrongPosition(TemplateSizeStateModel templateSizeState) {
    bool isWrongPosition = sectionStyles.wrongPosition(
        widget.screenBloc.state.stylesheets[deviceTypeId],
        section,
        widgetHeight,
        templateSizeState.newChildSize,
        widget.screenBloc.state.selectedChild);
    if (isWrongPosition) {
      if (!templateSizeState.wrongPosition)
        Future.microtask(
                () => templateSizeState.setWrongPosition(isWrongPosition));
    } else {
      if (templateSizeState.wrongPosition)
        Future.microtask(() {
          templateSizeState.setWrongPosition(isWrongPosition);
        });
    }
  }

  void progressRelativeLines(ChildSize newChildSize) {
    setState(() {
      relativeMarginTop = sectionStyles.relativeMarginTop(
          widget.screenBloc.state.stylesheets[deviceTypeId],
          section,
          newChildSize,
          widgetHeight,
          selectChildId);
      relativeMarginLeft = sectionStyles.relativeMarginLeft(
          widget.screenBloc.state.stylesheets[deviceTypeId],
          section,
          newChildSize,
          selectChildId);
    });
  }

  void initializeRelativeLines() {
      setState(() {
        relativeMarginTop = -1;
        relativeMarginLeft = -1;
      });
  }

  SectionStyles getSectionStyles(String childId) {
    try {
      Map<String, dynamic> json =
      widget.screenBloc.state.stylesheets[widget.deviceTypeId][childId];
      if (json['display'] != 'none') {
        // print('==============================================');
        // print('SectionID: $childId');
        // print('Section StyleSheet: $json');
      }
      return SectionStyles.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  _getLimitedSectionHeight(Child child) {
    BaseStyles baseStyles = getBaseStyles(child.id);
    if (baseStyles == null || !baseStyles.active) return;

    double height = baseStyles.height;
    double top = baseStyles.getMarginTop(sectionStyles);
    double newLimitSectionHeight =
        height + top + baseStyles.paddingV + baseStyles.marginBottom;
    if (limitSectionHeight < newLimitSectionHeight)
      limitSectionHeight = newLimitSectionHeight;
  }

  _changeSectionAction({ChildSize childSize}) {
    List<Map<String, dynamic>> effects = [];
    if (selectChildId.isNotEmpty && childSize != null) {
      try {
        effects = childPayload(childSize);
      } catch (e) {
        print('Get Child Payload error:${e.toString()}');
      }
    } else {
      effects = sectionPayload;
    }
    print('payload: $effects');
    if (effects.isNotEmpty)
      widget.screenBloc.add(UpdateSectionEvent(sectionId: section.id, effects: effects));
  }

  _updateTextAction(ShopEditScreenState state, String text) {
    Map<String, dynamic> sheets = state.stylesheets[deviceTypeId][selectChildId];
    TextStyles styles = TextStyles.fromJson(sheets);
    String htmlStr = styles.encodeHtmlString(widget.screenBloc.htmlText(), newText: text);
    List<Map<String, dynamic>> effects = styles.getUpdateTextPayload(section.id, selectChildId, sheets, htmlStr, state.activeShopPage.templateId);
    print('payload: $effects');
    widget.screenBloc.add(UpdateSectionEvent(
        sectionId: state.selectedSectionId, effects: effects));
  }

  List<Map<String, dynamic>> get sectionPayload {
    Map<String, dynamic> payloadSection = {};
    payloadSection['height'] = widgetHeight;
    if (sectionStyles.gridTemplateRows != null &&
        sectionStyles.gridTemplateRows.isNotEmpty) {
      List<String> gridRows = sectionStyles.gridTemplateRows.split(' ');
      double marginBottom =
      double.parse(gridRows.last); // To Last Vertical Element
      double dy = widgetHeight - sectionStyles.height;
      double updatedMarginBottom = marginBottom + dy;
      gridRows.removeLast();
      // gridRows.add('${updatedMarginBottom.round()}');
      gridRows.add('0');
      payloadSection['gridTemplateRows'] =
          '$gridRows'.replaceAll(RegExp(r"[^\s\w]"), '');
    }
    Map<String, dynamic> payload = {section.id: payloadSection};
    Map<String, dynamic> effect = {
      'payload': payload,
      'target': 'stylesheets:$deviceTypeId',
      'type': "stylesheet:update",
    };
    return [effect];
  }

  _addNewObject(ShopObject shopObject) {
    List<Map<String, dynamic>>effects = sectionStyles.getAddNewObjectPayload(shopObject, section.id, widget.screenBloc.state.activeShopPage.stylesheetIds, widget.screenBloc.state.activeShopPage.templateId);
    print('payload: $effects');
    widget.screenBloc.add(UpdateSectionEvent(sectionId: section.id, effects: effects));
  }

  List<Map<String, dynamic>> childPayload(ChildSize newSize) {
    List<Map<String, dynamic>> effects = [];
    BaseStyles baseStyles = getBaseStyles(selectChildId);
    Child selectedChild = widget.screenBloc.state.selectedChild;
    Map<String, dynamic>stylesheets = widget.screenBloc.state.stylesheets[deviceTypeId];

    String templateId = widget.screenBloc.state.activeShopPage.templateId;
    effects = baseStyles.getPayload(stylesheets,
        section, selectedChild, newSize, deviceTypeId, templateId);
    // if (baseStyles.isChildOverFromBlockView(stylesheets, section.id, selectedChild, newSize)) {
    //   selectedChild.blocks.first.children.remove(selectedChild);
    //   selectedChild.blocks = [];
    //   section.children.add(selectedChild);
    //   section.children.firstWhere((element) => element.id == selectedChild.blocks.first.id).children.remove(selectedChild);
    // }
    return effects;
  }

  _actionClipboard(ShopEditScreenState state, ClipboardType type) {
    print('value $type');
    List<Map<String, dynamic>>effects = [];
    switch(type) {
      case ClipboardType.cut:
        // TODO: Handle this case.
        break;
      case ClipboardType.copy:
        // TODO: Handle this case.
        break;
      case ClipboardType.paste:
        // TODO: Handle this case.
        break;
      case ClipboardType.delete:
        effects = sectionStyles.getDeleteObject(state.selectedChild.id, state.activeShopPage.templateId);
        break;
    }
    print('payload: $effects');
    if (effects.isNotEmpty)
      widget.screenBloc.add(UpdateSectionEvent(sectionId: section.id, effects: effects));
  }

  BaseStyles getBaseStyles(String childId) {
    return BaseStyles.fromJson(
        widget.screenBloc.state.stylesheets[deviceTypeId][childId]);
  }
}
