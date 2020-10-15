import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payever/theme.dart';

class TemplateView extends StatefulWidget {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;
  final Function onTap;

  const TemplateView(
      {this.shopPage, this.template, this.stylesheets, this.onTap});

  @override
  _TemplateViewState createState() =>
      _TemplateViewState(shopPage, template, stylesheets);
}

class _TemplateViewState extends State<TemplateView> {
  final ShopPage shopPage;
  final Template template;
  final Map<String, dynamic> stylesheets;

  _TemplateViewState(this.shopPage, this.template, this.stylesheets);

  @override
  Widget build(BuildContext context) {
//    if (shopPage.name != '404 1') {
//      return Container();
//    }
    List sections = [];
    template.children.forEach((child) {
      SectionStyleSheet styleSheet = getSectionStyleSheet(child.id);
      if (child.type == 'section' &&
          child.children != null &&
          child.children.isNotEmpty &&
          styleSheet.display != 'none') {
        sections.add(_section(child));
      }
    });

    return InkWell(
      onTap: widget.onTap,
      child: Container(
        color: Colors.grey,
        child: ListView.separated(
          itemCount: sections.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return sections[index];
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 14,
              thickness: 0,
              color: Colors.transparent,
            );
          },
        ),
      ),
    );
  }

  Widget _section(Child child) {
    SectionStyleSheet styleSheet = getSectionStyleSheet(child.id);
    if (styleSheet == null) {
      print('background NULL, Child ID: ${child.id}');
    }

    List widgets = [];
    child.children.forEach((child) {
      if (child.type == EnumToString.convertToString(ChildType.text)) {
        Widget text = _textWidget(child);
        if (text != null) widgets.add(text);
      } else if (child.type == EnumToString.convertToString(ChildType.button)) {
        Widget button = _buttonWidget(child);
        if (button != null) widgets.add(_buttonWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.image)) {
        Widget image = _imageWidget(child);
        if (image != null) widgets.add(image);
      } else if (child.type == EnumToString.convertToString(ChildType.shape)) {
      } else if (child.type == EnumToString.convertToString(ChildType.block)) {
        // If Type only Block, has sub children
        widgets.add(_blockWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.menu)) {
      } else if (child.type == EnumToString.convertToString(ChildType.logo)) {
      } else if (child.type == 'shop-cart') {
      } else if (child.type == 'shop-category') {
      } else if (child.type == 'shop-products') {
      } else {
        print('Special Child Type: ${child.type}');
      }
    });

//    if (styleSheet != null &&
//        styleSheet.backgroundImage != null &&
//        styleSheet.backgroundImage.isNotEmpty) {
      return Stack(
        children: [
          _sectionBgWidget(styleSheet),
          _sectionBody(widgets, styleSheet),
        ],
      );
//    } else {
//      return _sectionBody(widgets, styleSheet);
//    }
  }

  Widget _sectionBgWidget(SectionStyleSheet styleSheet) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: styleSheet.height,
      color: colorConvert(styleSheet.backgroundColor),
      child: CachedNetworkImage(
        imageUrl: styleSheet.backgroundImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.transparent /*background.backgroundColor*/,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Container(child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(
          Icons.error,
          size: 40,
        ),
      ),
    );
  }

  Widget _sectionBody(List widgets, SectionStyleSheet styleSheet) {
    return Container(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: widgets.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return widgets[index];
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 14,
            thickness: 0,
            color: Colors.transparent,
          );
        },
      ),
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

  Widget _textWidget(Child child) {
    if (child.styles == null || child.styles.isEmpty) {
      return null;
    }
    TextStyles styles = TextStyles.fromJson(child.styles);
    String txt = '';
    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      print('Data is not Map: ${child.data}');
    }
    if (txt.contains('<div') ||
        txt.contains('<span') ||
        txt.contains('<font')) {
      return Html(
        data: """
            $txt
            """,
        onLinkTap: (url) {
          print("Opening $url...");
        },
      );
    }
    return Container(
      margin: EdgeInsets.only(
          left: styles.marginLeft,
          right: styles.marginRight,
          top: styles.marginTop,
          bottom: styles.marginBottom),
      alignment: Alignment.center,
      child: Text(txt,
          style: TextStyle(
              color: colorConvert(styles.color), fontSize: styles.fontSize)),
    );
  }

  Widget _buttonWidget(Child child) {
      if (child.styles == null || child.styles.isEmpty) {
        return null;
      }
      ButtonStyles styles = ButtonStyles.fromJson(child.styles);
      return Container(
        width: styles.width,
        height: styles.height,
        decoration: BoxDecoration(
          color: colorConvert(styles.backgroundColor),
          borderRadius: BorderRadius.circular(styles.borderRadius),
        ),
        margin: EdgeInsets.only(
            left: styles.marginLeft,
            right: styles.marginRight,
            top: styles.marginTop,
            bottom: styles.marginBottom),
        alignment: Alignment.center,
        child: Text(Data.fromJson(child.data).text,
            style: TextStyle(
              color: colorConvert(styles.color),
              fontSize: styles.fontSize
            )),
      );
  }

  Widget _imageWidget(Child child) {
    if (child.styles == null || child.styles.isEmpty) {
      return null;
    }
    ImageStyles styles = ImageStyles.fromJson(child.styles) ;
    Data data;
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}
    if (data == null || data.src == null || data.src.isEmpty)
      return null;

    return Container(
      height: styles.height,
      width: styles.width,
      child: CachedNetworkImage(
        imageUrl: '${data.src}',
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Colors.white /*background.backgroundColor*/,
            borderRadius: BorderRadius.circular(4),
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
          size: 80,
        ),
      ),
    );
  }

  SectionStyleSheet getSectionStyleSheet(String childId) {
    try {
      return SectionStyleSheet.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }

  ButtonStyles getButtonStyleSheet(String childId) {
    try {
      return ButtonStyles.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][childId]);
    } catch (e) {
      return null;
    }
  }
}
//Logo Image
//https://payeverproduction.blob.core.windows.net/builder/24b4e49a-33d3-4b59-8366-3f0e49ac07d7-0-2.jpeg
