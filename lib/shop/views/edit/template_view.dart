import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:payever/commons/utils/common_utils.dart';
import 'package:payever/shop/models/models.dart';
import 'package:flutter_html/flutter_html.dart';

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
    List sections = [];
    template.children.forEach((child) {
      if (child.type == 'section') {
        sections.add(_section(child));
      } else {
        print('Special Section Type: ${child.type}');
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
    Background background = getBackground(child);
    if (background == null) {
      print('background NULL, Child ID: ${child.id}');
    }

    List widgets = [];
    child.children.forEach((child) {
      if (child.type == EnumToString.convertToString(ChildType.text)) {
        widgets.add(_textWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.button)) {
        widgets.add(_buttonWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.image)) {
        widgets.add(_imageWidget(child));
      } else if (child.type == EnumToString.convertToString(ChildType.shape)) {

      } else if (child.type == EnumToString.convertToString(ChildType.block)) {

      } else if (child.type == EnumToString.convertToString(ChildType.menu)) {

      } else if (child.type == EnumToString.convertToString(ChildType.logo)) {

      } else if (child.type == 'shop-cart') {

      } else if (child.type == 'shop-category') {

      } else if (child.type == 'shop-products') {

      } else {
        print('Special Child Type: ${child.type}');
      }

      if (child.children != null && child.children.isNotEmpty) {
//        print('Special Child Type: ${child.type}');
        if (child.type == 'logo') {

          print('${child.children}');
        }

      }
    });

    if (background != null &&
        background.backgroundImage != null &&
        background.backgroundImage.isNotEmpty) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            height: background.height.toDouble(),
            child: CachedNetworkImage(
              imageUrl: background.backgroundImage,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.white /*background.backgroundColor*/,
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
          ),
          Container(
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
          ),
        ],
      );
    } else {
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
  }

  Widget _textWidget(Child child) {
    Background background = getBackground(child);
    if (background == null) {

    } else {

    }

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
      return Center(
        child: SingleChildScrollView(
          child: Html(
            data: """
                $txt
                """,
            onLinkTap: (url) {
              print("Opening $url...");
            },
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
//        height: background.height,
//        width: background.width,
        alignment: Alignment.center,
        child: Text(txt, style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  Widget _buttonWidget(Child child) {
    try {
      print('Button Style: ${child.styles.toJson().toString()}');
      return Container(
        width: child.styles.height.toDouble(),
        height: child.styles.height.toDouble(),
        color: GlobalUtils.colorConvert(child.styles.backgroundColor),
        child: Text(Data.fromJson(child.data).text, style: TextStyle(color: Colors.black54),),
      );
    } catch(e) {
      return Container();
    }
  }

  Widget _imageWidget(Child child) {
    Styles styles = child.styles;
    Data data;
    try {
      data = Data.fromJson(child.data);
    } catch (e) {}
    if (data == null || data.src == null || data.src.isEmpty)
      return Container();

    return Container(
      height: styles.height.toDouble(),
      width: styles.width.toDouble(),
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

  Background getBackground(Child child) {
    try {
      return Background.fromJson(
          stylesheets[shopPage.stylesheetIds.mobile][child.id]);
    } catch (e) {
      return null;
    }
  }
}
//Logo Image
//https://payeverproduction.blob.core.windows.net/builder/24b4e49a-33d3-4b59-8366-3f0e49ac07d7-0-2.jpeg