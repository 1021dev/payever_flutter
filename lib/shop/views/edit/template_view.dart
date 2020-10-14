import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payever/shop/models/models.dart';

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
        color: Colors.white,
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
      if (child.type == 'text') {
        widgets.add(_textWidget(child));
      } else if (child.type == 'button') {
//        widgets.add(_buttonWidget(child));
      } else if (child.type == 'image') {
        widgets.add(_imageWidget(child));
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
      print('Text background NULL, Child ID: ${child.id}');
    } else {
      print('Text background Valid, Child ID: ${child.id}');
    }

    String txt = '';
    if (child.data is Map) {
      Data data = Data.fromJson(child.data);
      if (data.text != null) txt = data.text;
    } else {
      print('Data is not Map: ${child.data}');
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
    Background background = getBackground(child);
    if (background == null) return Container();
    return Container(
      height: background.height,
      width: background.width,
      child: Text(child.data.text),
    );
  }

  Widget _imageWidget(Child child) {
    Background background = getBackground(child);
    if (background == null || background.backgroundImage == null)
      return Container();

    print('Background Image: ${background.backgroundImage}');
    return Container(
      height: background.height.toDouble(),
      width: background.width.toDouble(),
      child: CachedNetworkImage(
        imageUrl: '${background.backgroundImage}',
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
