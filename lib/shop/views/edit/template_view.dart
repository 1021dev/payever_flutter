import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/draggable_widget.dart';
import 'package:payever/shop/models/models.dart';
import 'package:payever/shop/views/edit/element/button_view.dart';
import 'package:payever/shop/views/edit/element/image_view.dart';
import 'package:payever/shop/views/edit/element/text_view.dart';
import 'package:payever/theme.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  final Function onTap;
  final bool scrollable;
  const TemplateView(
      {this.shopPage, this.template, this.stylesheets, this.onTap, this.scrollable = true});

  @override
  _TemplateViewState createState() =>
      _TemplateViewState(shopPage, template, stylesheets);
}

class _TemplateViewState extends State<TemplateView> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  DragController dragController = DragController();
  _TemplateViewState(this.shopPage, this.template, this.stylesheets);

  @override
  Widget build(BuildContext context) {
//    if (shopPage.name != '404 1') {
//      return Container();
//    }
    List sections = [];
    template.children.forEach((child) {
      SectionStyleSheet styleSheet = getSectionStyleSheet(child.id);
      if (styleSheet == null) {
        return Container();
      }
      if (child.type == 'section' &&
          child.children != null &&
          /*child.children.isNotEmpty &&*/
          styleSheet.display != 'none') {
        sections.add(_section(child, styleSheet));
      }
    });

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.grey,
        child: ListView.separated(
          physics: widget.scrollable
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          itemCount: sections.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return sections[index];
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 0,
              thickness: 0,
              color: Colors.transparent,
            );
          },
        ),
      ),
    );
  }

  Widget _section(Child child, SectionStyleSheet styleSheet) {
    List<Widget> widgets = [];
    widgets.add(_sectionBackgroundWidget(styleSheet));
    child.children.forEach((child) {
      if (child.type == EnumToString.convertToString(ChildType.text)) {
        Widget text = TextView(child: child, stylesheets: stylesheets, deviceTypeId: shopPage.stylesheetIds.mobile,);
        if (text != null) widgets.add(text);
      } else if (child.type == EnumToString.convertToString(ChildType.button)) {
        Widget button = ButtonView(child:child, stylesheets: stylesheets, deviceTypeId: shopPage.stylesheetIds.mobile,);
        if (button != null) widgets.add(button);
      } else if (child.type == EnumToString.convertToString(ChildType.image)) {
        Widget image = ImageView(child);
        if (image != null) widgets.add(image);
      } else if (child.type == EnumToString.convertToString(ChildType.shape)) {
      } else if (child.type == EnumToString.convertToString(ChildType.block)) {
        // If Type only Block, has sub children
//        widgets.add(_blockWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.menu)) {
      } else if (child.type == EnumToString.convertToString(ChildType.logo)) {
      } else if (child.type == 'shop-cart') {
      } else if (child.type == 'shop-category') {
      } else if (child.type == 'shop-products') {
      } else {
        print('Special Child Type: ${child.type}');
      }
    });

    return Stack(
      children: widgets,
    );
  }

  Widget _sectionBackgroundWidget(SectionStyleSheet styleSheet) {
    return Container(
      width: double.infinity, //styleSheet.width,
      height: styleSheet.height,
      alignment: Alignment.topLeft,
      color: colorConvert(styleSheet.backgroundColor),
      child: styleSheet.backgroundImage.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: styleSheet.backgroundImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.transparent /*background.backgroundColor*/,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Container(child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                size: 40,
              ),
            )
          : Container(),
    );
  }

  Widget _blockWidget(Child child) {
    dynamic obj = stylesheets[shopPage.stylesheetIds.mobile][child.id];
    if (obj != null) {
//      print('Block StyleSheet: ${obj.toString()}');
    }
    child.children.forEach((element) {
//      print('Block Children type: ${element.type}');
    });
    return Container();
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
//      print('Section StyleSheet: ${stylesheets[shopPage.stylesheetIds.mobile][childId]}');
      return SectionStyleSheet.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }
}
